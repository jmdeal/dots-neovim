local cfg = require('yaml-companion').setup({
    builtin_matchers = {
        kubernetes = { enabled = true },
        cloud_init = { enabled = true },
    },
})

require('lspconfig')['yamlls'].setup(cfg)
