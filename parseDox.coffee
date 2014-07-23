fs = require 'fs'
dox = require 'dox'
path = require 'path'
r = require 'ramda'

# FILTERS
rejectPrivate = r.reject(r.where({isPrivate: true}))

# HELPERS
get = r.curry (key, item)->
    if item? then item[key]

# PARSE PARAMS
getTags = r.get("tags")
getParams = r.filter r.where({type: "param"})
removeTypes = r.map(r.omit(["type"]))
parseParams = r.compose removeTypes, getParams, getTags

# PARSE NAME
getCtx = get("ctx")
getName = get("name")
getString = get("string")

parseName = (obj)->
    ctx = getCtx(obj)
    name = getName(ctx)
    name ?= getString(ctx)
    name ?= "---"

# PARSE DESCRIPTION
getDescription = get("description")
getFullDescription = get("full")
parseDescription = r.compose getFullDescription, getDescription

# PARSE CODE
parseCode = get("code")

# PARSE TYPE
parseType = -> "Function"

# MAKE ANCHORS
constructAnchor = r.curry (base_path, name)->
    "#{base_path}##{name}"


parseEntry = r.curry (base_path, item)->
    name = parseName(item)
    params = parseParams(item)
    path = constructAnchor(base_path, name)
    description = parseDescription(item)
    code = parseCode(item)
    type = parseType(item)
    {name: name, description: description, params: params, code: code, type: type, path: path}


parseFile = (js_file, base_path)->
    js_contents = fs.readFileSync(js_file).toString()
    parser = parseEntry(base_path)
    dox_json = dox.parseComments(js_contents)
    docs = r.map(parser, rejectPrivate(dox_json))

module.exports.parseJS = parseFile
