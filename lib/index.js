var build, extend, modifiers, normalizeKeys, simpleClone;

extend = require('./extend');

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
  var i, key, len, output;
  if (keys) {
    output = {};
    if (typeof keys !== 'object') {
      output[keys] = true;
    } else {
      if (!Array.isArray(keys)) {
        keys = Object.keys(keys);
      }
      for (i = 0, len = keys.length; i < len; i++) {
        key = keys[i];
        output[key] = true;
      }
    }
    return output;
  }
};

build = function(options) {
  var builder;
  if (options.target) {
    builder = function() {
      var $_len = arguments.length, $_i = -1, sources = new Array($_len); while (++$_i < $_len) sources[$_i] = arguments[$_i];
      return extend(builder.options, builder.options.target, sources);
    };
  } else {
    builder = function(target) {
      var $_len = arguments.length, $_i = 0, sources = new Array($_len); while (++$_i < $_len) sources[$_i] = arguments[$_i];
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
  'deepOnly': {
    get: function() {
      var newOptions;
      newOptions = simpleClone(this.options);
      return function(keys) {
        newOptions.deepOnly = normalizeKeys(keys);
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
