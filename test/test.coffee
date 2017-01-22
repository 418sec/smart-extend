mocha = require 'mocha'
chai = require 'chai'
expect = chai.expect
sourceDir = if process.env.forCoverage then 'forCoverage' else 'lib'
extend = require "../#{sourceDir}/smart-extend"


suite "smart-extend", ()->
	suite "Basic Extend", ()->
		test "Shallow", ()->
			objA = a:1, b:2
			objB = b:3, c:4
			newObj = extend({}, objA, objB)

			expect(objA).to.eql(a:1, b:2)
			expect(objB).to.eql(b:3, c:4)
			expect(newObj).to.eql(a:1, b:3, c:4)

		
		test "Deep", ()->
			objA = a:1, b:2, inner:{A:1, B:2}
			objB = b:3, c:4, inner:{B:3, C:4}
			newObj = extend.deep({}, objA, objB)

			expect(objA).to.eql(a:1, b:2, inner:{A:1, B:2})
			expect(objB).to.eql(b:3, c:4, inner:{B:3, C:4})
			expect(newObj).to.eql(a:1, b:3, c:4, inner:{A:1, B:3, C:4})
	


	suite "Own Property Extend", ()->
		test "Shallow", ()->
			objA = a:1, b:2
			objB = b:3, c:4
			objA.__proto__ = {'hiddenOne':5}
			objB.__proto__ = {'hiddenOne':10}
			newObj = extend({}, objA, objB)

			expect(objA).to.eql(a:1, b:2, hiddenOne:5)
			expect(objB).to.eql(b:3, c:4, hiddenOne:10)
			expect(newObj).to.eql(a:1, b:3, c:4, hiddenOne:10)

			newObjOwn = extend.own({}, objA, objB)
			expect(objA).to.eql(a:1, b:2, hiddenOne:5)
			expect(objB).to.eql(b:3, c:4, hiddenOne:10)
			expect(newObjOwn).to.eql(a:1, b:3, c:4)

		
		test "Deep", ()->
			objA = a:1, b:2, inner:{A:1, B:2}
			objB = b:3, c:4, inner:{B:3, C:4}
			objA.__proto__ = {'hiddenOne':5}
			objB.__proto__ = {'hiddenOne':10}
			newObj = extend.deep({}, objA, objB)

			expect(objA).to.eql(a:1, b:2, inner:{A:1, B:2}, hiddenOne:5)
			expect(objB).to.eql(b:3, c:4, inner:{B:3, C:4}, hiddenOne:10)
			expect(newObj).to.eql(a:1, b:3, c:4, inner:{A:1, B:3, C:4}, hiddenOne:10)

			newObjOwn = extend.own.deep({}, objA, objB)
			expect(objA).to.eql(a:1, b:2, inner:{A:1, B:2}, hiddenOne:5)
			expect(objB).to.eql(b:3, c:4, inner:{B:3, C:4}, hiddenOne:10)
			expect(newObjOwn).to.eql(a:1, b:3, c:4, inner:{A:1, B:3, C:4})




	suite "Clone", ()->
		test "Shallow", ()->
			objA = a:1, b:2
			objB = b:3, c:4
			newObj = extend.clone(objA, objB)

			expect(objA).to.eql(a:1, b:2)
			expect(objB).to.eql(b:3, c:4)
			expect(newObj).to.eql(a:1, b:3, c:4)

		
		test "Deep", ()->
			objA = a:1, b:2, inner:{A:1, B:2}
			objB = b:3, c:4, inner:{B:3, C:4}
			newObj = extend.deep.clone(objA, objB)
			newObjB = extend.clone.deep(objA, objB)

			expect(objA).to.eql(a:1, b:2, inner:{A:1, B:2})
			expect(objB).to.eql(b:3, c:4, inner:{B:3, C:4})
			expect(newObj).to.eql(a:1, b:3, c:4, inner:{A:1, B:3, C:4})
			expect(newObj).to.eql(newObjB)




	suite "Concat Arrays", ()->
		test "Shallow", ()->
			objA = a:1, b:[0,1,2]
			objB = b:[3,4,5], c:4
			newObj = extend.clone(objA, objB)
			newObjB = extend.concat.clone(objA, objB)

			expect(newObj).to.eql(a:1, b:[3,4,5], c:4)
			expect(newObjB).to.eql(a:1, b:[0,1,2,3,4,5], c:4)

		
		test "Deep", ()->
			objA = a:1, b:[0,1,2], inner:{A:1, B:[0,1,2]}
			objB = b:[3,4,5], c:4, inner:{B:[3,4,5], C:4}
			newObj = extend.deep.clone(objA, objB)
			newObjB = extend.concat.deep.clone(objA, objB)

			expect(objA).to.eql(a:1, b:[0,1,2], inner:{A:1, B:[0,1,2]})
			expect(objB).to.eql(b:[3,4,5], c:4, inner:{B:[3,4,5], C:4})
			expect(newObj).to.eql(a:1, b:[3,4,5], c:4, inner:{A:1, B:[3,4,5], C:4})
			expect(newObjB).to.eql(a:1, b:[0,1,2,3,4,5], c:4, inner:{A:1, B:[0,1,2,3,4,5], C:4})
	


	suite "Extend Specific Keys", ()->
		test "Shallow", ()->
			objA = a:1, b:2
			objB = b:3, c:4
			newObj = extend.keys(['b','c'])({}, objA, objB)
			newObjB = extend.keys({b:false, c:true})({}, objA, objB)

			expect(objA).to.eql(a:1, b:2)
			expect(objB).to.eql(b:3, c:4)
			expect(newObj).to.eql(b:3, c:4)
			expect(newObj).to.eql(newObjB)

		
		test "Deep", ()->
			objA = a:1, b:2, inner:{a:1, b:2}
			objB = b:3, c:4, inner:{b:3, c:4}
			newObj = extend.keys(['b','c','inner']).deep({}, objA, objB)
			newObjB = extend.keys({b:false, c:true, inner:null})({}, objA, objB)

			expect(objA).to.eql(a:1, b:2, inner:{a:1, b:2})
			expect(objB).to.eql(b:3, c:4, inner:{b:3, c:4})
			expect(newObj).to.eql(b:3, c:4, inner:{b:3, c:4})
			expect(newObj).to.eql(newObjB)




	suite "Extend + Transform", ()->
		test "Arguments", ()->
			invoked = 0
			objA = a:1, b:2
			objB = b:3, c:4
			newObj = extend.transform((value, key, object)->
				invoked++
				expect(key).not.to.equal 'fromSource'
				expect(typeof object).to.equal 'object'
				expect(typeof key).to.equal 'string'
				expect(typeof value).to.equal 'number'
				expect(typeof object[key]).to.equal 'number'
				return value
			)({'fromSource':true}, objA, objB)

			expect(newObj.fromSource).to.be.true
			expect(invoked).to.equal 4


		test "Shallow", ()->
			objA = a:'a1', b:'b2'
			objB = b:'b3', c:'c4'
			newObj = extend.clone.transform((v)->v.toUpperCase())(objA, objB)

			expect(objA).to.eql(a:'a1', b:'b2')
			expect(objB).to.eql(b:'b3', c:'c4')
			expect(newObj).to.eql(a:'A1', b:'B3', c:'C4')

		
		test "Deep", ()->
			objA = a:'a1', b:'b2', inner:{A:'a1', B:'b2'}
			objB = b:'b3', c:'c4', inner:{B:'b3', C:'c4'}
			newObj = extend.deep.clone.transform((v)->v.toUpperCase())(objA, objB)

			expect(objA).to.eql(a:'a1', b:'b2', inner:{A:'a1', B:'b2'})
			expect(objB).to.eql(b:'b3', c:'c4', inner:{B:'b3', C:'c4'})
			expect(newObj).to.eql(a:'A1', b:'B3', c:'C4', inner:{A:'A1', B:'B3', C:'C4'})




	suite "Extend + global filter", ()->
		test "Arguments", ()->
			invoked = 0
			objA = a:1, b:2
			objB = b:3, c:4
			newObj = extend.filter((value, key, object)->
				invoked++
				expect(key).not.to.equal 'fromSource'
				expect(typeof object).to.equal 'object'
				expect(typeof key).to.equal 'string'
				expect(typeof value).to.equal 'number'
				expect(typeof object[key]).to.equal 'number'
			)({'fromSource':true}, objA, objB)

			expect(newObj.fromSource).to.be.true
			expect(invoked).to.equal 4
		

		test "Shallow", ()->
			objA = a:1, b:2
			objB = b:3, c:4
			newObj = extend.filter((v)-> v<3)({}, objA, objB)

			expect(objA).to.eql(a:1, b:2)
			expect(objB).to.eql(b:3, c:4)
			expect(newObj).to.eql(a:1, b:2)

		
		test "Deep", ()->
			objA = a:1, b:2, inner:{A:1, B:2}
			objB = b:3, c:4, inner:{B:3, C:4, E:-1}
			newObj = extend.deep.filter((v)-> v<3 or typeof v is 'object')({}, objA, objB)

			expect(objA).to.eql(a:1, b:2, inner:{A:1, B:2})
			expect(objB).to.eql(b:3, c:4, inner:{B:3, C:4, E:-1})
			expect(newObj).to.eql(a:1, b:2, inner:{A:1, B:2, E:-1})




	suite "Extend + filters", ()->
		test "Arguments", ()->
			invoked = 0
			objA = a:1, b:2
			objB = b:3, c:4
			filter = (value, key, object)->
				invoked++
				expect(typeof object).to.equal 'object'
				expect(typeof key).to.equal 'string'
				expect(typeof value).to.equal 'number'
				expect(typeof object[key]).to.equal 'number'
				return value > 2
			
			extend.filters(a:filter, b:filter)({}, objA, objB)
			expect(invoked).to.equal 3
		

		test "Shallow", ()->
			objA = a:1, b:2
			objB = b:3, c:4
			newObj = extend.filters(b:(v)-> v<3)({}, objA, objB)

			expect(objA).to.eql(a:1, b:2)
			expect(objB).to.eql(b:3, c:4)
			expect(newObj).to.eql(a:1, b:2, c:4)

		
		test "Deep", ()->
			objA = a:1, b:2, inner:{a:1, b:2}
			objB = b:3, c:4, inner:{b:3, c:4}
			newObj = extend.deep.filters(b:(v)-> v<3)({}, objA, objB)

			expect(objA).to.eql(a:1, b:2, inner:{a:1, b:2})
			expect(objB).to.eql(b:3, c:4, inner:{b:3, c:4})
			expect(newObj).to.eql(a:1, b:2, c:4, inner:{a:1, b:2, c:4})



	suite "Misc", ()->
		test "Undefined & null values won't be copied", ()->
			objA = a:1, b:null
			objB = b:undefined, c:4
			newObj = extend({}, objA, objB)

			expect(objA).to.eql(a:1, b:null)
			expect(objB).to.eql(b:undefined, c:4)
			expect(newObj).to.eql(a:1, c:4)


		test "Non-object sources shall be ignored except for strings and functions", ()->
			fn = ()->
			fn.c = 4
			newObj = extend.clone(undefined, null, 2, NaN, true, {a:1, b:true}, '^%$', fn)
			expect(newObj).to.eql {a:1, b:true, 0:'^', 1:'%', 2:'$', c:4}


		test "Functions can be extension targets", ()->
			fnA = ()->
			fnB = ()->
			fnA.a = 1
			fnB.b = 2
			fnB.c = 3
			updatedFn = extend(fnA, fnB, {b:5, d:4})

			expect(updatedFn).to.equal(fnA)
			expect(updatedFn.a).to.equal(1)
			expect(updatedFn.b).to.equal(5)
			expect(updatedFn.c).to.equal(3)
			expect(updatedFn.d).to.equal(4)
			expect(Object.keys updatedFn).to.eql(['a','b','c','d'])


		test "Non-object/function sources shall be replaced with objects", ()->
			source = a:1, b:2
			targets = [true, undefined, null, NaN, 55, 'abc']

			for target in targets
				newTarget = extend(target, source)
				expect(typeof newTarget).to.equal 'object'
				expect(newTarget).to.eql a:1, b:2


		test "Providing no sources shall produce non-mutating results", ()->
			target = a:1, b:2
			copiedA = extend(target)
			copiedB = extend.clone()

			expect(copiedA).to.equal target
			expect(copiedB).to.eql {}


		test "Providing invalid arguments to method flags will cause the flags to be ignored", ()->
			objA = a:1, b:2
			objB = b:3, c:4
			copies = 
				'stringKeys': extend.keys('b')({}, objA, objB)
				'nullKeys': extend.keys(null)({}, objA, objB)
				'stringTransform': extend.transform('b')({}, objA, objB)
				'nullTransform': extend.transform(null)({}, objA, objB)
				'stringFilter': extend.filter('b')({}, objA, objB)
				'nullFilter': extend.filter(null)({}, objA, objB)
				'stringFilters': extend.filters('b')({}, objA, objB)
				'nullFilters': extend.filters(null)({}, objA, objB)
				'arrayFilters': extend.filters(['a'])({}, objA, objB)

			expect(copies.stringKeys).to.eql(a:1, b:3, c:4)
			expect(copies.nullKeys).to.eql(a:1, b:3, c:4)
			expect(copies.stringTransform).to.eql(a:1, b:3, c:4)
			expect(copies.nullTransform).to.eql(a:1, b:3, c:4)
			expect(copies.stringFilter).to.eql(a:1, b:3, c:4)
			expect(copies.nullFilter).to.eql(a:1, b:3, c:4)
			expect(copies.stringFilters).to.eql(a:1, b:3, c:4)
			expect(copies.nullFilters).to.eql(a:1, b:3, c:4)
			expect(copies.arrayFilters).to.eql(a:1, b:3, c:4)








