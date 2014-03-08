module.exports = (grunt) ->
    # Project configuration.
    grunt.initConfig
        pkg: grunt.file.readJSON("package.json")
        meta:
            banner: '/*!\n' +
                'Structura scripts\n' +
                '@name structura.js\n' +
                '@author Alexander van Trijffel (@avtnl)\n' +
                '@version <%= pkg.version %>\n' +
                '@date <%= grunt.template.today("yyyy-mm-dd") %>\n' +
                '*/\n'
        notify:
            coffee:
                options:
                    title: 'grunt'
                    message: 'Compiled coffeescript'
            jade:
                options:
                    title: 'grunt'
                    message: 'Compiled jade'
            sass:
                options:
                    title: 'grunt'
                    message: 'Compiled sass'

        watch:
            css: {
                files: 'pub/**/*.css',
                options: {
                    livereload: true
                }
            }
            js: {
                files: 'pub/**/*.js',
                options: {
                    livereload: true
                }
            }
            html: {
                files: '**/*.html',
                options: {
                    livereload: true
                }
            }
            coffee:
                files: './**/*.coffee',
                tasks: ['coffee:compile', 'notify:coffee']

        coffee:
            compile:
                options:
                    bare: true
                    sourceMap: true
                    runtime:'inline'
                files:
                    'app.js': ['app.coffee']
                    'message_handler/index.js': ['message_handler/index.coffee']
                    'models/IncomingMessage.js': ['models/IncomingMessage.coffee']
                    'twitter_listener/index.js': ['twitter_listener/index.coffee']

            glob_to_multiple: {
                expand: true,
                flatten: true,
                sourceMap: true
                cwd: '',
                src: ['./**/*.coffee'],
                dest: '',
                ext: '.js'
            }
    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-iced-coffee"
    grunt.loadNpmTasks 'grunt-notify'

    grunt.registerTask 'default', ['watch']
    grunt.registerTask "release", [
        "coffee"
    ]