# smart-extend
[![Build Status](https://travis-ci.org/danielkalen/smart-extend.svg?branch=master)](https://travis-ci.org/danielkalen/smart-extend)
[![Coverage](.config/badges/coverage-node.png?raw=true)](https://github.com/danielkalen/simplyimport)
[![Code Climate](https://codeclimate.com/github/danielkalen/smart-extend/badges/gpa.svg)](https://codeclimate.com/github/danielkalen/smart-extend)
[![NPM](https://img.shields.io/npm/v/smart-extend.svg)](https://npmjs.com/package/smart-extend)

`smart-extend` is an extension to jQuery's classic `extend()` method with additional features providing you with more power and control over your object extensions/clones. Works in both Node.JS and the browser.

**Features Summary**
- Deep/shallow object cloning/extension.
- Optional array concatination.
- Optionally copy only 'own' properties.
- Specify specific properties to copy.
- Apply filter functions to allow only specific properties/values to be copied.
- Expressive API.
- Clean, Focused, and actively maintained.

# Example Usage
```javascript
var extend = require('smart-extend');
var objA = {a:1, b:2};
var objB = {b:3, c:4};
var objC = {a:1, b:2, inner:{a:1, b:2}};
var objD = {b:3, c:4, inner:{b:3, c:4}};
var emptyObj = {};

// Copy objA into emptyObj
extend(emptyObj, objA)          //-> emptyObj === {a:1, b:2} 

// Copy objA & objB into emptyObj
extend(emptyObj, objA, objB)    //-> emptyObj === {a:1, b:3, c:4} 

// Shallow Copy objC & objD into a new object
extend({}, objC, objD)          //-> {a:1, b:3, c:4, inner:{b:3, c:4}} 

// Deep Copy objC & objD into a new object
extend.deep({}, objC, objD)     //-> {a:1, b:3, c:4, inner:{a:1, b:3, c:4}} 

// Clone objA (without specifying a target)
extend.clone(objA)              //-> {a:1, b:2}

// Clone objA with only property 'a'
extend.clone.keys(['a'])(objA)  //-> {a:1}

// Clone objC with properties named 'a' or 'inner'
extend.clone.keys(['a','inner'])(objC)  //-> {a:1, inner:{a:1}}

// Copy objA's & objB's properties that have a value greater than 2
extend.filter(value => value > 2)({}, objA, objB) //-> {b:3, c:4}

// Concat array values
extend({}, {arr:[1,2,3]}, {arr:[4,5,6]})        //-> {arr: [4,5,6]}
extend.concat({}, {arr:[1,2,3]}, {arr:[4,5,6]}) //-> {arr: [1,2,3,4,5,6]}

// And more...
```


# Usage
#### `extend(target, object1[, objectN...])`
Shallow copy all properties (own & inherited) of `object1` and any following objects into `target`.

#### `extend[.<option>[.<option>...]](...)`
Perform copy/extension with the specified [options](#options). `options` can be chained in any desired order and some accept arguments.

**Example**:
`extend.keys(['a', 'b']).clone.deep(targetObject)` will deep clone `targetObject`'s `'a'` and `'b'` properties.


## Options
#### `deep`
Performs a recursive copy of the specified objects.

**Example**:
```javascript
var objA = {a:1, b:2, inner:{a:1, b:2}};
var objB = {b:3, c:4, inner:{b:3, c:4}};
var cloneA = extend({}, objA);
var cloneB = extend.deep({}, objA);

cloneA === objA //-> false
cloneA.inner === objA.inner //-> true
cloneB.inner === objA.inner //-> false

extend({}, objA, objB)      //-> {a:1, b:3, c:4, inner:{b:3, c:4}}
extend.deep({}, objA, objB) //-> {a:1, b:3, c:4, inner:{a:1, b:3, c:4}}
```


#### `own`
Only copies 'own' properties of object and not inherited properties.

**Example**:
```javascript
var SomeConstructor = function(){this.a = 1; this.b = 2;}
SomeConstructor.prototype.inherited = 'abc'
var object = new SomeConstructor();

extend({}, object)      //-> {a:1, b:2, inherited:'abc'}
extend.own({}, object)  //-> {a:1, b:2}
```


#### `clone`
Clone the specified objects without specifying a target. This is basically a shortcut in which instead of passing an empty object as the first argument (i.e. the target object), an empty object will be created internally for you.

**Example**:
```javascript
// Both will render the same results
var A = extend({}, {a:1}, {b:2})   //-> {a:1, b:2}
var B = extend.clone({a:1}, {b:2}) //-> {a:1, b:2}
```


#### `concat`
Causes array properties to be merged/concatenated instead of the usual behavior in which the 2nd array replaces the first. Behaves the same in both deep & shallow copies.

**Example**:
```javascript
var objA = {arr: [1,2,3]};
var objB = {arr: [4,5,6]};
var objB2 = {arr: [null,4,5,6]};
extend({}, objA, objB)        //-> {arr: [4,5,6]}
extend.concat({}, objA, objB) //-> {arr: [1,2,3,4,5,6]}

extend({}, objA, objB2)       //-> {arr: [null,4,5,6]}
extend.deep({}, objA, objB2)  //-> {arr: [1,4,5,6]}
extend.deep.concat({}, objA, objB2)  //-> {arr: [1,2,3,4,5,6]}
```


#### `keys(array|object)`
Allows only properties whose name is included in the provided array. If a plain object is passed its keys/property names will be extracted into an array *(disregarding the property values)*.

**Example**:
```javascript
var objA = {a:1, b:2};
var objB = {b:3, c:4, d:5};

extend({}, objA, objB)                         //-> {a:1, b:3, c:4, d:5}
extend.keys(['a', 'c'])({}, objA, objB)        //-> {a:1, c:4}
extend.keys({b:true, d:false})({}, objA, objB) //-> {b:3, d:5}
```


#### `filter(filterFunction)`
Runs the provided `filterFunction` on each property encoutered in the provided sources with the following arguments: `filterFunction(value, key, source)`. The value returned from the `filterFunction` will be used to determine whether or not to copy the subject property - if the value is a truthy value the value property will be copied and if the value is a falsey value it will be omitted.

Arguments:
- `filterFunction` - a filter predicate to apply to each property encoutered. Return `true` to copy the property, otherwise return `false` to not copy the property.
    - `value` - The value of the current property being processed in the object.
    - `key` - The the name (or label) of the current property being processed in the object.
    - `source` - The object which this property belongs to.

**Example**:
```javascript
var objA = {a:1, b:10};
var objB = {b:3, c:4, d:5};
var myFilter = function(value, key, source){
    a
}
```


#### `filters(filterMap)`
Similar to the `filter` function but instead of accepting a function which will be applied to all encoutered properties, it accepts an object mapping individual filter functions to specific properties. The `filterMap` is an object with the signature of `{property: filterFunction}`. When iterating through the source's properties, if there is a function predicate matching the currently processed property's name then it will be invoked and treated like a `filterFunction`.

**Example**:
```javascript
var objA = {a:1, b:5, c:3};
var objB = {a:3, b:2, c:5, e:0};
var objC = {a:10, b:'20', c:30, d:40};

extend.filters({
    a: (value) => value < 2
    b: (value) => typeof value === 'string'
    c: (value) => value < 10
    e: (value) => value > 0
})(objA, objB, objC)
//-> {a:1, b:'20', c:5, d:40}
```



