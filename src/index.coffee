extend = require './extend'
simpleClone = (source)->
	output = {}
	output[key] = value for key,value of source
	return output

normalizeKeys = (keys)-> if keys
	output = {}
	if typeof keys isnt 'object'
		output[keys] = true
	else
		keys = Object.keys(keys) if not Array.isArray(keys)
		output[key] = true for key in keys

	return output


build = (options)->
	if options.target
		builder = ()->
			EXPAND_ARGUMENTS(sources)
			extend(builder.options, builder.options.target, sources)
	else
		builder = (target)->
			EXPAND_ARGUMENTS(sources, 1)
			extend(builder.options, target, sources)
	
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
		newOptions.own = true
		return build(newOptions)

	'allowNull': get: ()->
		newOptions = simpleClone(@options)
		newOptions.allowNull = true
		return build(newOptions)

	'nullDeletes': get: ()->
		newOptions = simpleClone(@options)
		newOptions.nullDeletes = true
		return build(newOptions)

	'concat': get: ()->
		newOptions = simpleClone(@options)
		newOptions.concat = true
		return build(newOptions)

	'clone': get: ()->
		newOptions = simpleClone(@options)
		newOptions.target = {}
		return build(newOptions)

	'notDeep': get: ()->
		newOptions = simpleClone(@options)
		return (keys)->
			newOptions.notDeep = normalizeKeys(keys)			
			build(newOptions)

	'deepOnly': get: ()->
		newOptions = simpleClone(@options)
		return (keys)->
			newOptions.deepOnly = normalizeKeys(keys)			
			build(newOptions)

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
				newOptions.globalTransform = transform
			else if transform and typeof transform is 'object'
				newOptions.transforms = transform
			
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