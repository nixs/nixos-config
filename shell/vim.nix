{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    catppuccin.enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = ''
      vim.opt.autochdir = true
      vim.opt.backup = false

      vim.opt.autoindent = true
      vim.opt.cindent = true
      vim.opt.smartindent = true

      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.smarttab = true
      vim.opt.softtabstop = 2
      vim.opt.tabstop = 2

      vim.opt.backspace = "indent,eol,start"
      vim.g.mapleader = ';'
      vim.g.maplocalleader = ';'

      vim.opt.hlsearch = true
      vim.opt.ignorecase = true

      vim.opt.showmatch = true

      vim.opt.number = true
      vim.opt.background = dark
      vim.opt.termguicolors = true

      function map(mode, lhs, rhs, opts)
        local options = {noremap = true, silent = false}
        if opts then
          options = vim.tbl_extend("force", options, opts)
        end
        vim.keymap.set(mode, lhs, rhs, options)
      end

      map('n', '<leader>t',        ':ToggleTerm<CR>'      )
      map('i', '<leader><leader>', '<Esc>'                )
      map('t', '<Esc>',            '<C-\\><C-n>'          )
      map('n', '<leader>p',        ':NvimTreeToggle<CR>'  )
      map('n', '<leader><Space>',  ':NvimTreeToggle<CR>'  )
      map('n', '<leader>ff',       ':Telescope find_files<CR>')
      map('n', '<leader>fg',       ':Telescope live_grep<CR>' )
      map('n', '<leader>fb',       ':Telescope buffers<CR>'   )
      map('n', '<leader>fh',       ':Telescope help_tags<CR>' )
      map('n', '<leader>fo',       ':Telescope vim_options<CR>' )

      map('n', '<leader>h',        ':split<CR>' )
      map('n', '<leader>v',        ':vsplit<CR>' )
      map('n', '<leader>q',        ':q<CR>' )

      -- vim-powered terminal in split window (disabled, use toggleterm instead).
      -- map('n', '<leader>t',        ':below term<CR>10<C-w>_' )
      -- map('t', '<leader>t',        '<C-w>:below term<CR>10<C-w>_' )

      -- Comment bindings
      map('i', '<C-_>', '<Esc>:Comment<CR>')
      map('n', '<C-_>', 'gcc', { remap = true })
      map('v', '<C-_>', 'gc',  { remap = true })

      vim.cmd.colorscheme "catppuccin"
    '';

    plugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      telescope-nvim
      vim-nix
      vim-tmux-navigator
      vim-visual-multi
      {
        plugin = nvim-comment;
        type = "lua";
        config = ''
          require('nvim_comment').setup()
        '';
      }
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          require('nvim-tree').setup({ update_cwd = true })
        '';
      }
      {
        plugin = lightline-vim;
        type = "viml";
        config = ''
          let g:lightline = {'colorscheme': 'catppuccin'}
        '';
      }
      {
        plugin = toggleterm-nvim;
        type = "lua";
        config = ''
          require('toggleterm').setup{ insert_mappings = true }
        '';
      }
    ];
  };
}
