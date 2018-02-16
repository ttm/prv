today,
Sex Fev 16 08:44:13 -02 2018,
only vimwiki, vimtex and vim-colorschems plugins
are here

One might just clone plugins here directly.
Any directory will be added to runtimepath,
so one-script plugins should be placed at:
  pack/plugins/<plugin\_name>/plugin/\<script.vim>

Vim looks at any directory in runtimepath
for the tree according to :h runtimepath
(plugin/ ftplugin/ etc)
and for other files, e.g. in ftdetect/
