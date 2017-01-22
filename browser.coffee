do ()->
	import * as extend from ./lib/smart-extend

	if module?.exports?
		module.exports = extend
	else if typeof define is 'function' and define.amd
		define ['smart-extend'], ()-> extend
	else
		window.extend = extend

	return