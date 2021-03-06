module.exports = function (api) {
  api.cache(true);

  return {
    "presets": [
      [
        "@babel/preset-env",
        {
          "forceAllTransforms": true,
          "modules": false,
          "targets": {
            "browsers": "> 1%"
          },
          "useBuiltIns": 'entry',
          "corejs": 3
        }
      ],
      "@babel/preset-react"
    ],
    "env": {
      "test": {
        "presets": [
          "@babel/preset-env",
          "@babel/preset-react"
        ]
      }
    },
    "plugins": [
      "@babel/plugin-syntax-dynamic-import",
      "@babel/plugin-proposal-object-rest-spread",
      [
        "@babel/plugin-proposal-class-properties",
        {
          "spec": true
        }
      ]
    ]
  }
}
