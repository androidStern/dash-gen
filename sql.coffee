Sequelize = require("sequelize")

buildSQL = (name, entries)->

    seq = new Sequelize('database', 'username', null, {
        dialect: 'sqlite'
        storage: "#{name}.docset/Contents/Resources/docSet.dsidx"
    })


    populate = (SearchIndex, items)->


    SearchIndex = seq.define('searchIndex', {
        id:
            type: Sequelize.INTEGER
            primaryKey: true
        name:
            type: Sequelize.TEXT
        type:
            type: Sequelize.TEXT
        path:
            type: Sequelize.TEXT
        },{
        timestamps: false
    })

    SearchIndex.sync().success ->
        for item in entries
            si = SearchIndex.build(name: item.name, type: item.type, path: item.path)
            si.save()
        console.log "All done."

module.exports.buildSQL = buildSQL
