local util = require 'lspconfig.util'

local root_file = {
  '.eslintrc',
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.yaml',
  '.eslintrc.yml',
  '.eslintrc.json',
  'eslint.config.js',
  'eslint.config.mjs',
  'eslint.config.cjs',
  'eslint.config.ts',
  'eslint.config.mts',
  'eslint.config.cts',
}

require("lvim.lsp.manager").setup("eslint", {
  root_dir = function(fname)
    root_file = util.insert_package_json(root_file, 'eslintConfig', fname)
    return util.root_pattern(unpack(root_file))(fname)
  end,
})
