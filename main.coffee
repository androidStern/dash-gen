path = require 'path'
fs = require 'fs'
mkdir = require('mkdir-parents').sync
{buildSQL} = require './sql'
{parseJS} = require './parseDox'
{compileHTML} = require './compileHTML'

docsetPath = (name)->
    "#{name}.docset/Contents/Resources/Documents/"

htmlPath = (name)-> path.join docsetPath(name), "#{name}.html"

infoPlistPath = (name)->
    "#{name}.docset/Contents/Info.plist"

capitalize = (str)->
    str[0].toUpperCase() + str[1..-1].toLowerCase()


infoPlist = (name)->
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
    	<key>CFBundleIdentifier</key>
    	<string>#{name}</string>
    	<key>CFBundleName</key>
    	<string>#{name}</string>
    	<key>DocSetPlatformFamily</key>
    	<string>#{name}</string>
    	<key>isDashDocset</key>
    	<true/>
    </dict>
    </plist>
    """

mkPlist = (name)->
    fs.writeFileSync(infoPlistPath(name), infoPlist(name))

mkHTML = (name, entries)->
    fs.writeFileSync(htmlPath(name), compileHTML(entries))

buildDocset = (name, js_file)->
    mkdir docsetPath(name)
    mkPlist(name)
    entries = parseJS(js_file, "#{name}.html")
    mkHTML(name, entries)
    buildSQL(name, entries)


buildDocset("RAMDA", "ramda.js")
