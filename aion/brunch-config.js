exports.config = {
    notifications: false,
    files: {
        javascripts: {
            joinTo: 'js/app.js'
        },
        stylesheets: {
            joinTo: {
                'css/app.css': [
                    'web/static/css/app.css',
                    'web/elm/elm-stuff/packages/pablen/toasty/1.0.4/examples/src/main.css',
                    'web/elm/elm-stuff/packages/pablen/toasty/1.0.4/src/Toasty/Defaults.css'
                ]
            },
            order: {
                after: ['web/static/css/app.css'] // concat app.css last
            }
        },
        templates: {
            joinTo: 'js/app.js'
        }
    },
    conventions: {
        assets: /^(web\/static\/assets)/
    },
    paths: {
        watched: [
            'web/static',
            'test/static',
            'web/elm'
        ],
        public: 'priv/static'
    },
    plugins: {
        elmBrunch: {
            executablePath: '../../node_modules/elm/binwrappers',
            elmFolder: 'web/elm',
            mainModules: ['src/App.elm'],
            outputFolder: '../static/vendor',
            makeParameters: ['--warn']
        },
        babel: {
            ignore: [/web\/static\/vendor/]
        }
    },
    modules: {
        autoRequire: {
            'js/app.js': ['web/static/js/app']
        }
    },
    npm: {
        enabled: true
    }
};
