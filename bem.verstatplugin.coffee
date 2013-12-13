module.exports = (next) ->
	@on "templateData", (file, templateData) =>
		templateData.renderBlock = (blockName, data) =>
			if blockMarkupFile = @queryFile(filename: "blocks/#{blockName}/#{blockName}.html")
				@depends file, [ blockMarkupFile ]
				data or= {}
				@emit "templateData", blockMarkupFile, data
				data.BEM_RENDERING_BLOCK = blockName
				blockMarkupFile.fn data
			else
				"[block #{blockName} not found]"

	@on "readFile", (file) =>
		if file.srcFilename.match ///^blocks/.*///
			file.write = no
			file.process = no if file.extname is '.html'
			@modified file

	next()
