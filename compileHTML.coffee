handlebars = require 'handlebars'
{Parse} = require './parseDox'


template = handlebars.compile('''
<!DOCTYPE html>
<html>
<head>
  <link href="css/github.css" rel="stylesheet" type="text/css">
  <meta charset="utf-8" />
</head>
<body>
{{#each entries}}
    <div>
        <h1><a href="{{path}}">{{name}}</a></h1>
        <h2>{{description}}</h2>
        <pre>{{code}}</pre>
    </div>
{{/each}}
</body>
</html>
''')

compileHTML = (entries)->
    template({entries:entries})

module.exports.compileHTML = compileHTML
