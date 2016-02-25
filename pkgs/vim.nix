{ neovim }:
neovim.overrideDerivation (drv: {
  postInstall = drv.postInstall + ''
    ln -s nvim.1 $out/share/man/man1/vim.1
    ln -s nvim $out/bin/vim
  '';
})
