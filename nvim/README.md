# nvim-required-plugins-fast-v5

This copy keeps the new config, but restores the lighter old-style bufferline/title-bar colors.

## What changed

- Keeps darker line-number/sidebar colors.
- Keeps bufferline separators/selected indicator disabled so the black blocks do not come back.
- Restores the title-bar palette:
  - title-bar background: `#143455`
  - inactive/visible filenames: `#7c8f8f`
  - selected filename: `#c3ccdc`, bold/italic

The title-bar colors are set in `lua/plugins/ui.lua`. `lua/config/colors.lua` no longer touches bufferline colors, so manually running `:lua require('config.colors').apply()` will not change the title bar after it already looks right.

## Install

```sh
rm -rf ~/.config/nvim/lua ~/.config/nvim/init.lua ~/.config/nvim/coc-settings.json
cp -r nvim-required-plugins-fast-v5/init.lua nvim-required-plugins-fast-v5/coc-settings.json nvim-required-plugins-fast-v5/lua ~/.config/nvim/
nvim --headless '+Lazy! sync' +qa
```

Restart Neovim fully afterward.

## Note

Do not run the old hot-reload lines for the title bar:

```vim
:lua require('config.colors').apply()
:BufferLineRefresh
```

They are not needed for this version. A full restart is the clean path.


Second title-bar fix: switched bufferline separators to `thin` and gave them a subtle darker-blue divider so the chunky left block disappears while keeping the lighter old title-bar colors.
