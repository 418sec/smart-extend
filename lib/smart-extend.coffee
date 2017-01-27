extend = require './extend'
simpleClone = (source)->
	output = {}
	output[key] = value for key,value of source
	return output

normalizeKeys = (keys)->
	return if not keys
	return Object.keys(keys) if typeof keys is 'object' and not Array.isArray(keys)
	return [].concat(keys)


build = (options)->
	if options.target
		builder = (sources...)-> extend(builder.options, builder.options.target, sources)
	else
		builder = (target, sources...)-> extend(builder.options, target, sources)
	
	builder.options = options
	Object.defineProperties(builder, modifiers)
	return builder


modifiers = 
	'deep': get: ()->
		newOptions = simpleClone(@options)
		newOptions.deep = true
		return build(newOptions)

	'own': get: ()->
		newOptions = simpleClone(@options)
		newOptions.onlyOwn = true
		return build(newOptions)

	'allowNull': get: ()->
		newOptions = simpleClone(@options)
		newOptions.allowNull = true
		return build(newOptions)

	'concat': get: ()->
		newOptions = simpleClone(@options)
		newOptions.concat = true
		return build(newOptions)

	'clone': get: ()->
		newOptions = simpleClone(@options)
		newOptions.target = {}
		return build(newOptions)

	'keys': get: ()->
		newOptions = simpleClone(@options)
		return (keys)->
			newOptions.keys = normalizeKeys(keys)			
			build(newOptions)

	'notKeys': get: ()->
		newOptions = simpleClone(@options)
		return (keys)->
			newOptions.notKeys = normalizeKeys(keys)			
			build(newOptions)

	'transform': get: ()->
		newOptions = simpleClone(@options)
		return (transform)->
			if typeof transform is 'function'
				newOptions.transform = transform
			
			build(newOptions)


	'filter': get: ()->
		newOptions = simpleClone(@options)
		return (filter)->
			if typeof filter is 'function'
				newOptions.globalFilter = filter
			else if filter and typeof filter is 'object'
				newOptions.filters = filter
			
			build(newOptions)



module.exports = build({})