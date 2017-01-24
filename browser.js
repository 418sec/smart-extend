var slice = [].slice;

(function() {
  var _sim_26e33, extend;
  _sim_26e33 = (function(_this) {
    return function(exports) {
      var module = {exports:exports};
      var build, extend, modifiers, simpleClone;
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
                if (sourceValue === target || sourceValue === void 0 || (sourceValue === null && !options.allowNull) || (options.specificKeys && options.specificKeys.indexOf(key) === -1) || (options.onlyOwn && !source.hasOwnProperty(key)) || (options.globalFilter && !options.globalFilter(sourceValue, key, source)) || (options.filters && options.filters[key] && !options.filters[key](sourceValue, key, source))) {
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
                    if (options.transform) {
                      sourceValue = options.transform(sourceValue, key, source);
                    }
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
            newOptions.onlyOwn = true;
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
        'keys': {
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
        },
        'transform': {
          get: function() {
            var newOptions;
            newOptions = simpleClone(this.options);
            return function(transform) {
              if (typeof transform === 'function') {
                newOptions.transform = transform;
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
              }
              return build(newOptions);
            };
          }
        },
        'filters': {
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
        }
      };
      module.exports = build({});
      return module.exports;
    };
  })(this)({});
  extend = _sim_26e33;
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
