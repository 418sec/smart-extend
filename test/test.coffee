mocha = require 'mocha'
chai = require 'chai'
extend = require '../lib/smart-extend'
expect = chai.expect


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









