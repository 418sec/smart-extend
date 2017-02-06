isArray = (target)->
	Array.isArray(target)

isObject = (target)->
	target and Object::toString.call(target) is '[object Object]'

shouldSkipDeep = (target, options)->
	if options.notDeep then options.notDeep.indexOf(target) isnt -1 else false


module.exports = extend = (options, target, sources)->
	target = {} if not target or typeof target isnt 'object' and typeof target isnt 'function'

	for source in sources when source?
		for key of source
			sourceValue = source[key]
			targetValue = target[key]
			
			continue if sourceValue is target or
						sourceValue is undefined or
						(sourceValue is null and not options.allowNull) or
						(options.keys and options.keys.indexOf(key) is -1) or
						(options.notKeys and options.notKeys.indexOf(key) isnt -1) or
						(options.own and not source.hasOwnProperty(key)) or
						(options.globalFilter and not options.globalFilter(sourceValue, key, source)) or
						(options.filters and options.filters[key] and not options.filters[key](sourceValue, key, source))
			
			if options.globalTransform
				sourceValue = options.globalTransform(sourceValue, key, source)
			if options.transforms and options.transforms[key]
				sourceValue = options.transforms[key](sourceValue, key, source)
	
			switch
				when options.concat and isArray(sourceValue) and isArray(targetValue)
					target[key] = targetValue.concat(sourceValue)
				
				when options.deep and isObject(sourceValue) and not shouldSkipDeep(key, options)
					subTarget = if isObject(targetValue) then targetValue else if isArray(sourceValue) then [] else {}
					target[key] = extend(options, subTarget, [sourceValue])

				else
					target[key] = sourceValue


	return target







