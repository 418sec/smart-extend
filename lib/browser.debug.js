var slice = [].slice;

(function() {
  var extend;
  extend = (function(_this) {
    return function(exports) {
      var module = {exports:exports};
      var build, modifiers, normalizeKeys, simpleClone;
      extend = (function(exports) {
        var module = {exports:exports};
        var isArray, isObject, shouldSkipDeep;
        isArray = function(target) {
          return Array.isArray(target);
        };
        isObject = function(target) {
          return target && Object.prototype.toString.call(target) === '[object Object]' || isArray(target);
        };
        shouldSkipDeep = function(target, options) {
          if (options.notDeep) {
            return options.notDeep.indexOf(target) !== -1;
          } else {
            return false;
          }
        };
        module.exports = extend = function(options, target, sources) {
          var i, key, len, source, sourceValue, subTarget, targetValue;
          if (!target || typeof target !== 'object' && typeof target !== 'function') {
            target = {};
          }
          for (i = 0, len = sources.length; i < len; i++) {
            source = sources[i];
            if (source != null) {
              for (key in source) {
                sourceValue = source[key];
                targetValue = target[key];
                if (sourceValue === target || sourceValue === void 0 || (sourceValue === null && !options.allowNull) || (options.keys && options.keys.indexOf(key) === -1) || (options.notKeys && options.notKeys.indexOf(key) !== -1) || (options.own && !source.hasOwnProperty(key)) || (options.globalFilter && !options.globalFilter(sourceValue, key, source)) || (options.filters && options.filters[key] && !options.filters[key](sourceValue, key, source))) {
                  continue;
                }
                if (options.globalTransform) {
                  sourceValue = options.globalTransform(sourceValue, key, source);
                }
                if (options.transforms && options.transforms[key]) {
                  sourceValue = options.transforms[key](sourceValue, key, source);
                }
                switch (false) {
                  case !(options.concat && isArray(sourceValue) && isArray(targetValue)):
                    target[key] = targetValue.concat(sourceValue);
                    break;
                  case !(options.deep && isObject(sourceValue) && !shouldSkipDeep(key, options)):
                    subTarget = isObject(targetValue) ? targetValue : isArray(sourceValue) ? [] : {};
                    target[key] = extend(options, subTarget, [sourceValue]);
                    break;
                  default:
                    target[key] = sourceValue;
                }
              }
            }
          }
          return target;
        };
        return module.exports;
      })({});
      simpleClone = function(source) {
        var key, output, value;
        output = {};
        for (key in source) {
          value = source[key];
          output[key] = value;
        }
        return output;
      };
      normalizeKeys = function(keys) {
        if (!keys) {
          return;
        }
        if (typeof keys === 'object' && !Array.isArray(keys)) {
          return Object.keys(keys);
        }
        return [].concat(keys);
      };
      build = function(options) {
        var builder;
        if (options.target) {
          builder = function() {
            var sources;
            sources = 1 <= arguments.length ? slice.call(arguments, 0) : [];
            return extend(builder.options, builder.options.target, sources);
          };
        } else {
          builder = function() {
            var sources, target;
            target = arguments[0], sources = 2 <= arguments.length ? slice.call(arguments, 1) : [];
            return extend(builder.options, target, sources);
          };
        }
        builder.options = options;
        Object.defineProperties(builder, modifiers);
        return builder;
      };
      modifiers = {
        'deep': {
          get: function() {
            var newOptions;
            newOptions = simpleClone(this.options);
            newOptions.deep = true;
            return build(newOptions);
          }
        },
        'own': {
          get: function() {
            var newOptions;
            newOptions = simpleClone(this.options);
            newOptions.own = true;
            return build(newOptions);
          }
        },
        'allowNull': {
          get: function() {
            var newOptions;
            newOptions = simpleClone(this.options);
            newOptions.allowNull = true;
            return build(newOptions);
          }
        },
        'concat': {
          get: function() {
            var newOptions;
            newOptions = simpleClone(this.options);
            newOptions.concat = true;
            return build(newOptions);
          }
        },
        'clone': {
          get: function() {
            var newOptions;
            newOptions = simpleClone(this.options);
            newOptions.target = {};
            return build(newOptions);
          }
        },
        'notDeep': {
          get: function() {
            var newOptions;
            newOptions = simpleClone(this.options);
            return function(keys) {
              newOptions.notDeep = normalizeKeys(keys);
              return build(newOptions);
            };
          }
        },
        'keys': {
          get: function() {
            var newOptions;
            newOptions = simpleClone(this.options);
            return function(keys) {
              newOptions.keys = normalizeKeys(keys);
              return build(newOptions);
            };
          }
        },
        'notKeys': {
          get: function() {
            var newOptions;
            newOptions = simpleClone(this.options);
            return function(keys) {
              newOptions.notKeys = normalizeKeys(keys);
              return build(newOptions);
            };
          }
        },
        'transform': {
          get: function() {
            var newOptions;
            newOptions = simpleClone(this.options);
            return function(transform) {
              if (typeof transform === 'function') {
                newOptions.globalTransform = transform;
              } else if (transform && typeof transform === 'object') {
                newOptions.transforms = transform;
              }
              return build(newOptions);
            };
          }
        },
        'filter': {
          get: function() {
            var newOptions;
            newOptions = simpleClone(this.options);
            return function(filter) {
              if (typeof filter === 'function') {
                newOptions.globalFilter = filter;
              } else if (filter && typeof filter === 'object') {
                newOptions.filters = filter;
              }
              return build(newOptions);
            };
          }
        }
      };
      module.exports = build({});
      return module.exports;
    };
  })(this)({});
  if ((typeof module !== "undefined" && module !== null ? module.exports : void 0) != null) {
    module.exports = extend;
  } else if (typeof define === 'function' && define.amd) {
    define(['smart-extend'], function() {
      return extend;
    });
  } else {
    window.extend = extend;
  }
})();
