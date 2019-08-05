module.exports = function(api) {
  api.cache(true);

  const presets = ['@babel/env'];

  const plugins = ['@babel/plugin-transform-modules-commonjs'];

  return {
    presets,
    plugins
  };
};
