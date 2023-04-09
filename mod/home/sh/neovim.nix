{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      nord-nvim
      lualine-nvim
      nvim-web-devicons
      lazygit-nvim
      nvim-scrollbar
      gitsigns-nvim
      dashboard-nvim
      nui-nvim
      searchbox-nvim
    ];
    # use wl-clipboard to access system clipboard
    extraPackages = with pkgs; [ wl-clipboard ];
    extraConfig = ''
      set guicursor=a:ver25-iCursor-blinkwait100-blinkon300-blinkoff100
      colorscheme nord
      set number
      if !exists('g:GtkGuiLoaded')
        hi Normal guibg=NONE
      endif
      lua << END
        require('lualine').setup()
        require('gitsigns').setup()
        require('scrollbar').setup()
        require('scrollbar.handlers.gitsigns').setup()
        require('dashboard').setup()
      END
      cnoreabbrev git LazyGitCurrentFile
      set clipboard=unnamedplus
      vmap <C-c> "+yi
      vmap <C-x> "+c
      vmap <C-v> c<ESC>"+p
      imap <C-v> <C-r><C-o>+
      map <C-z> u
      imap <C-z> <C-u>
      map <C-a> <ESC>ggVG
      vmap <BS> <Del> 
      map <C-f> :SearchBoxIncSearch<CR>
      map <C-h> :SearchBoxReplace<CR>
      noremap <ScrollWheelUp> H5k
      noremap <ScrollWheelDown> L5j
      autocmd BufEnter * silent! lcd %:p:h
    '';
  };
}
