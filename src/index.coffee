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


build = (options, isBase)->
	if options.target
		builder = ()->
			EXPAND_ARGUMENTS(sources)
			extend(builder.options, builder.options.target, sources)
	else
		builder = (target)->
			EXPAND_ARGUMENTS(sources, 1)
			extend(builder.options, target, sources)
	
	builder.isBase = true if isBase
	builder.options = options
	Object.defineProperties(builder, modifiers)
	return builder


modifiers = 
	'deep': get: ()->
		_ = if @isBase then build({}) else @
		_.options.deep = true
		return _

	'own': get: ()->
		_ = if @isBase then build({}) else @
		_.options.own = true
		return _

	'allowNull': get: ()->
		_ = if @isBase then build({}) else @
		_.options.allowNull = true
		return _

	'allowSpecial': get: ()->
		_ = if @isBase then build({}) else @
		_.options.allowSpecial = true
		return _

	'nullDeletes': get: ()->
		newOptions = simpleClone(@options)
		newOptions.nullDeletes = true
		return build(newOptions)

	'concat': get: ()->
		_ = if @isBase then build({}) else @
		_.options.concat = true
		return _

	'clone': get: ()->
		# _ = if @isBase then build({}) else @
		# _.options.target = {}
		# return _
		newOptions = simpleClone(newOptions)
		newOptions.target = {}
		return build(newOptions)

	'notDeep': get: ()->
		_ = if @isBase then build({}) else @
		return (keys)->
			_.options.notDeep = normalizeKeys(keys)			
			return _

	'deepOnly': get: ()->
		newOptions = simpleClone(@options)
		return (keys)->
			newOptions.deepOnly = normalizeKeys(keys)			
			build(newOptions)

	'keys': get: ()->
		_ = if @isBase then build({}) else @
		return (keys)->
			_.options.keys = normalizeKeys(keys)			
			return _

	'notKeys': get: ()->
		_ = if @isBase then build({}) else @
		return (keys)->
			_.options.notKeys = normalizeKeys(keys)			
			return _

	'transform': get: ()->
		_ = if @isBase then build({}) else @
		return (transform)->
			if typeof transform is 'function'
				_.options.globalTransform = transform
			else if transform and typeof transform is 'object'
				_.options.transforms = transform
			
			return _


	'filter': get: ()->
		_ = if @isBase then build({}) else @
		return (filter)->
			if typeof filter is 'function'
				_.options.globalFilter = filter
			else if filter and typeof filter is 'object'
				_.options.filters = filter
			
			return _



module.exports = build({}, true)