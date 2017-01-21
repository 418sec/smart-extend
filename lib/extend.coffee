isArray = (target)->
	Array.isArray(target)

isObject = (target)->
	target and typeof target is 'object'


module.exports = extend = (options, target, sources)->
	target = {} if not target or typeof target isnt 'object' and typeof target isnt 'function'

	for source in sources when source?
		for key of source
			sourceValue = source[key]
			targetValue = target[key]
			
			continue if sourceValue is target or
						not sourceValue? or
						(options.specificKeys and options.specificKeys.indexOf(key) is -1) or
						(options.onlyOwn and not source.hasOwnProperty(key)) or
						(options.globalFilter and not options.globalFilter(sourceValue, key, source)) or
						(options.filters and options.filters[key] and not options.filters[key](sourceValue, key, source))
	
			switch
				when options.concat and isArray(sourceValue) and isArray(targetValue)
					target[key] = targetValue.concat(sourceValue)
				
				when options.deep and isObject(sourceValue)
					subTarget = if isObject(targetValue) then targetValue else if isArray(sourceValue) then [] else {}
					target[key] = extend(options, subTarget, [sourceValue])

				else
					target[key] = sourceValue


	return target







