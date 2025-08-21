---
title: "Infrastructure on a budget: A case study"
description: "Don't overengineer infrastructure. I run an app with over 30,000 MAU on a single shared vCPU server costing $24 a month. Simple, lean setups handle real traffic."
pubDate: "Aug 21, 2025"
---

Many startups pour massive amounts of money into building highly resilient infrastructure from day one. Among the first
hires, is a DevOps engineer who spends weeks writing Terraform or Helm code that no one else fully understands—or dares
to touch. A few more weeks go by deploying everything to AWS, and by the time the environment is up, it still lacks
observability, environments, etc. Meanwhile, the startup has already spent tens of thousands before the engineering team
can even start shipping features.

I find it funny how so much energy is often poured into infrastructure, yet code quality often gets neglected. My take
on infrastructure: keep it simple until it's truly necessary.

For the past 8 years, I've been running a volunteer shifts app with over 30,000 MAU on a single shared vCPU instance
costing just $24 a month. It runs every service the app needs, except email, and requires very little maintenance.
Despite its simplicity, it can easily handle 50 requests per second.

## The app

The app itself is built with Python, using [FastAPI](https://fastapi.tiangolo.com) at its core. It exposes a REST API,
connects to a PostgreSQL database, caches data in Redis, and runs background jobs with [Huey](https://github.com/coleifer/huey).

The same Python app serves the frontend, a React app.

[Gunicorn](https://gunicorn.org) is the HTTP server, with [uvicorn workers](https://www.uvicorn.org/deployment/#gunicorn).
Only 6 gunicorn workers handle all the traffic.

```bash
gunicorn -n gizmo_app -w 6 -k uvicorn.workers.UvicornWorker api.main:app --forwarded-allow-ips='*' --capture-output
```

## The virtual machine

Over the years, I experimented with different providers and eventually settled on [Vultr](https://www.vultr.com). To my
surprise, it proved far more reliable than [DigitalOcean](https://www.digitalocean.com), consistently keeping its 100% SLA.

I deployed what Vultr calls a High Performance Cloud Compute instance: 2 shared AMD EPYC vCPUs, 4 GB of memory, and 100
GB of storage.

These statis provide an overview of the machine's usage:

![VPS Stats](../../assets/2025_08_21_infrastructure_on_a_budget_vps_stats.png)

Python apps can be more memory-intensive than CPU-intensive.

## A PaaS to deploy and manage the app

I've always loved the simplicity of [Heroku](https://www.heroku.com). It lets you forget about infrastructure almost
entirely. Unfortunately, for this project, Heroku was far too expensive. We were working with a very limited budget,
and every dollar mattered.

The solution? [Dokku](https://dokku.com), an open-source alternative to Heroku. Some of its features:

- It's powered by [Docker](https://www.docker.com)
- Uses [nginx](https://nginx.org) as the reverse-proxy by default
- Ships with [Vector](https://vector.dev) for log management
- Provides an API very similar to Heroku's
- There's a rich ecosystem of plugins available
- You can deploy any `Dockerfile`

[Here](https://gist.github.com/josuemontano/56ec527722a77c87c004476cff3302cc) you'll find the gist of the setup required
for this server. Check the [dokku ACL plugin](https://github.com/dokku-community/dokku-acl) if you need to manage users
and their permissions. On the other hand, the postgres and redis plugins allow you to schedule encrypted backups to S3.

Add a remote to your git repo and you are ready to deploy with just `git push`!

## CI/CD

[GitHub Actions](https://github.com/features/actions) is an amazing platform for automating deployments, there's really
no excuse not to use it.

First, create an SSH key for automated deployments, add it to Dokku, and store the private key along with any other
necessary values as environment variables in your GitHub repository.

Once that's done, this GitHub Actions workflow file will handle deploying the app automatically, taking all the manual
steps off your plate.

```yml
name: Deploy to Dokku

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup SSH
        uses: webfactory/ssh-agent@v0.8.1
        with:
          ssh-private-key: ${{ secrets.DOKKU_DEPLOY_KEY }}

      - name: Add server to known_hosts
        run: |
          mkdir -p ~/.ssh
          ssh-keyscan -H ${{ secrets.DOKKU_HOST }} >> ~/.ssh/known_hosts

      - name: Deploy to Dokku
        run: |
          git remote add production dokku@${{ secrets.DOKKU_HOST }}:${{ secrets.DOKKU_APP }} || true
          git push production HEAD:refs/heads/main -f
```

## A stress test

To evaluate the app's performance under load, we ran a stress test on one of its REST endpoints using a sample of ~6,000
requests. Each request cycle involves authenticating the current user, executing multiple queries against the PostgreSQL
database, and serializing roughly 20KB of data.

The following table shows the response times in milliseconds:

| req/sec | p50     | p90     | max     |
| ------- | ------- | ------- | ------- |
| 50      | 483.01  | 696.818 | 1373.95 |
| 100     | 869.33  | 1587.8  | 3562.0  |
| 200     | 1983.95 | 3258.23 | 8347.38 |

It's worth noting that the PostgreSQL database is small — around 150 MB, containing roughly 1 million records. But
that's exactly the data that matters for the app and our users. I delete old data frequently. Your database might be
even smaller at the start, unless you're working in the big data business, of course.

## Next steps

Yes, there's a bit more work involved when configuring the server for the first time. You'll want to disable root
password login, enforce SSH key access for all users, configure the firewall, and so on. And you should definitely proxy
the app behind [Cloudflare](https://cloudflare.com/). We also haven't discussed provisioning new servers for test
environments. Or setting [OpenTelemetry](https://opentelemetry.io) up for better observability.

Still, you can have a solid environment up and running in half a day — it usually takes me less than 2 hours to set up a
server and deploy an app to production using this workflow.

## Lessons learned

Can you really rely on a single server? I've done it for the past few years, and I think you might be able to get away
with it for a bit. I've seen successful startups running costly k8s clusters on AWS with only 2 nodes.

Should you deploy your app and all its services on a shared vCPU machine? Probably not. Still, this case study
demonstrates just how much you can accomplish with minimal resources.

What if I later need to move to a k8s cluster? The deployment process for my app is Docker-based, so I'm not locked in.
Remember — good architecture lets you defer decisions for as long as possible!
