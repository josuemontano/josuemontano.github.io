'use strict';

module.exports = function (grunt) {
    require('load-grunt-tasks')(grunt);
    require('time-grunt')(grunt);

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        watch: {
            sass: {
                files: 'src/scss/*.scss',
                tasks: ['sass', 'copy']
            },
            browserify: {
                files: ['src/js/app/**/*.coffee', 'src/js/app/**/*.hbs'],
                tasks: ['browserify']
            }
        },
        browserify: {
            dist: {
                files: {
                    'static/<%= pkg.name %>.js': ['src/js/app/**/*.coffee'],
                },
                options: {
                    browserifyOptions: {
                        debug: true,
                        extensions: ['.coffee', '.hbs']
                    },
                    transform: ['coffeeify', 'hbsfy'],
                }
            },
        },
        sass: {
            dist: {
                options: {
                    style: 'compressed',
                    sourcemap: 'none',
                },
                files: [{
                    expand: true,
                    cwd: 'src/scss',
                    src: ['*.scss'],
                    dest: 'static',
                    ext: '.min.css'
                }, {
                    expand: true,
                    cwd: 'bower_components/foundation/scss',
                    src: ['*.scss'],
                    dest: 'static',
                    ext: '.min.css'
                }]
            }
        },
        copy: {
            files: {
                cwd: 'src/img',
                src: '**/*',
                dest: 'static/img',
                expand: true
            }
        },
        uglify: {
            options: {
                banner: '/**' +
                        '\n * <%= pkg.name %>' +
                        '\n * @version <%= pkg.version %>' +
                        '\n * @date <%= grunt.template.today("dd-mm-yyyy") %>' +
                        '\n**/\n'
            },
            dist: {
                files: {
                    'static/<%= pkg.name %>.min.js': ['static/<%= pkg.name %>.js']
                }
            }
        },
        coffeelint: {
            app: ['src/js/app/**/*.coffee'],
            options: {
                'max_line_length': {
                  'level': 'warn'
                }
            }
        }
    });

    grunt.registerTask('default', [
        'watch'
    ]);

    grunt.registerTask('build', [
        'copy',
        'sass',
        'coffeelint',
        'browserify',
        'uglify'
    ]);
};
