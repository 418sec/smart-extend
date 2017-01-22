var slice = [].slice;

(function() {
  var _sim_2f982, extend;
  _sim_2f982 = (function(_this) {
    return function(exports) {
      var module = {exports:exports};
      var build, define, extend, modifiers, simpleClone;
      extend = (function(exports) {
        var module = {exports:exports};
        var isArray, isObject;
        isArray = function(target) {
          return Array.isArray(target);
        };
        isObject = function(target) {
          return target && typeof target === 'object';
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
                if (sourceValue === target || (sourceValue == null) || (options.specificKeys && options.specificKeys.indexOf(key) === -1) || (options.onlyOwn && !source.hasOwnProperty(key)) || (options.globalFilter && !options.globalFilter(sourceValue, key, source)) || (options.filters && options.filters[key] && !options.filters[key](sourceValue, key, source))) {
                  continue;
                }
                switch (false) {
                  case !(options.concat && isArray(sourceValue) && isArray(targetValue)):
                    target[key] = targetValue.concat(sourceValue);
                    break;
                  case !(options.deep && isObject(sourceValue)):
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
        builder.__proto__ = modifiers;
        return builder;
      };
      modifiers = build.__proto__ = {};
      define = function(property, descriptor) {
        return Object.defineProperty.call(Object, modifiers, property, descriptor);
      };
      define('deep', {
        get: function() {
          var newOptions;
          newOptions = simpleClone(this.options);
          newOptions.deep = true;
          return build(newOptions);
        }
      });
      define('own', {
        get: function() {
          var newOptions;
          newOptions = simpleClone(this.options);
          newOptions.onlyOwn = true;
          return build(newOptions);
        }
      });
      define('concat', {
        get: function() {
          var newOptions;
          newOptions = simpleClone(this.options);
          newOptions.concat = true;
          return build(newOptions);
        }
      });
      define('clone', {
        get: function() {
          var newOptions;
          newOptions = simpleClone(this.options);
          newOptions.target = {};
          return build(newOptions);
        }
      });
      define('keys', {
        get: function() {
          var newOptions;
          newOptions = simpleClone(this.options);
          return function(keys) {
            if (Array.isArray(keys)) {
              newOptions.specificKeys = keys;
            } else if (keys && typeof keys === 'object') {
              newOptions.specificKeys = Object.keys(keys);
            }
            return build(newOptions);
          };
        }
      });
      define('filter', {
        get: function() {
          var newOptions;
          newOptions = simpleClone(this.options);
          return function(filter) {
            if (typeof filter === 'function') {
              newOptions.globalFilter = filter;
            }
            return build(newOptions);
          };
        }
      });
      define('filters', {
        get: function() {
          var newOptions;
          newOptions = simpleClone(this.options);
          return function(filters) {
            if (filters && typeof filters === 'object') {
              newOptions.filters = filters;
            }
            return build(newOptions);
          };
        }
      });
      module.exports = build({});
      return module.exports;
    };
  })(this)({});
  extend = _sim_2f982;
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
