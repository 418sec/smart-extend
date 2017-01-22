extend = require './extend'
simpleClone = (source)->
	output = {}
	output[key] = value for key,value of source
	return output


build = (options)->
	if options.target
		builder = (sources...)-> extend(builder.options, builder.options.target, sources)
	else
		builder = (target, sources...)-> extend(builder.options, target, sources)
	
	builder.options = options
	builder.__proto__ = modifiers
	return builder


modifiers = build.__proto__ = {}
define = (property, descriptor)-> Object.defineProperty.call(Object, modifiers, property, descriptor)

define 'deep', get: ()->
	newOptions = simpleClone(@options)
	newOptions.deep = true
	return build(newOptions)

define 'own', get: ()->
	newOptions = simpleClone(@options)
	newOptions.onlyOwn = true
	return build(newOptions)

define 'concat', get: ()->
	newOptions = simpleClone(@options)
	newOptions.concat = true
	return build(newOptions)

define 'clone', get: ()->
	newOptions = simpleClone(@options)
	newOptions.target = {}
	return build(newOptions)

define 'keys', get: ()->
	newOptions = simpleClone(@options)
	return (keys)->
		if Array.isArray(keys)
			newOptions.specificKeys = keys
		else if keys and typeof keys is 'object'
			newOptions.specificKeys = Object.keys(keys)
		
		build(newOptions)

define 'transform', get: ()->
	newOptions = simpleClone(@options)
	return (transform)->
		if typeof transform is 'function'
			newOptions.transform = transform
		
		build(newOptions)


define 'filter', get: ()->
	newOptions = simpleClone(@options)
	return (filter)->
		if typeof filter is 'function'
			newOptions.globalFilter = filter
		
		build(newOptions)


define 'filters', get: ()->
	newOptions = simpleClone(@options)
	return (filters)->
		if filters and typeof filters is 'object'
			newOptions.filters = filters
		
		build(newOptions)




module.exports = build({})