module.exports = (grunt) ->
    # Project configuration.
    grunt.initConfig
        pkg: grunt.file.readJSON("package.json")
        notify:
            coffee:
                options:
                    title: 'grunt'
                    message: 'Compiled coffeescript'

        watch:
            coffee:
                files: './**/*.coffee',
                tasks: ['coffee:compile', 'notify:coffee']

        coffee:
            compile:
                options:
                    bare: true
                    sourceMap: true
                files:
                    'app.js': ['app.coffee']
                    'lib/db.js': ['lib/db.coffee']
                    'lib/dispatcher.js': ['lib/dispatcher.coffee']
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