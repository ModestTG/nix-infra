{ inputs, self, ... }:
{
  flake.modules.homeManager.nixvim =
    { lib, config, ... }:
    {
      imports = [
        inputs.nixvim.homeModules.nixvim
        self.modules.homeManager.nixvim-plugins
      ];
      programs.neovim.enable = lib.mkForce false;
      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        useGlobalPackages = true;
        globals = {
          mapleader = " ";
          maplocalleader = " ";
          have_nerd_font = true;
        };
        clipboard = {
          register = "unnamedplus";
          providers.wl-copy.enable = true;
        };
        opts = {
          number = true;
          relativenumber = true;
          mouse = "a";
          showmode = false;
          breakindent = true;
          undofile = true;
          ignorecase = true;
          smartcase = true;
          signcolumn = "yes";
          updatetime = 250;
          timeoutlen = 300;
          splitright = true;
          splitbelow = true;
          list = true;
          listchars = config.lib.nixvim.mkRaw "{ tab = '» ', trail = '·', nbsp = '␣' }";
          inccommand = "split";
          cursorline = true;
          scrolloff = 10;
          hlsearch = true;
          virtualedit = "block";
          wrap = false;
          termguicolors = true;
        };
        lsp = {
          servers = {
            gopls.enable = true;
            marksman.enable = true;
            nixd.enable = true;
            pylsp.enable = true;
            yamlls.enable = true;
            lua_ls = {
              enable = true;
              settings = {
                completion = {
                  callSnippet = "Replace";
                };
              };
            };
          };
          keymaps = [
            {
              mode = "n";
              key = "<leader>q";
              action = config.lib.nixvim.mkRaw "function() vim.diagnostic.setloclist() end";
              options.desc = "Open diagnostic [Q]uickfix list";
            }
            {
              mode = "n";
              key = "gd";
              action = config.lib.nixvim.mkRaw "require('telescope.builtin').lsp_definitions";
              options.desc = "LSP: [G]oto [D]efinition";
            }
            {
              mode = "n";
              key = "gr";
              action = config.lib.nixvim.mkRaw "require('telescope.builtin').lsp_references";
              options.desc = "LSP: [G]oto [R]eferences";
            }
            {
              mode = "n";
              key = "gI";
              action = config.lib.nixvim.mkRaw "require('telescope.builtin').lsp_implementations";
              options.desc = "LSP: [G]oto [I]mplementation";
            }
            {
              mode = "n";
              key = "<leader>D";
              action = config.lib.nixvim.mkRaw "require('telescope.builtin').lsp_type_definitions";
              options.desc = "LSP: Type [D]efinition";
            }
            {
              mode = "n";
              key = "<leader>ds";
              action = config.lib.nixvim.mkRaw "require('telescope.builtin').lsp_document_symbols";
              options.desc = "LSP: [D]ocument [S]ymbols";
            }
            {
              mode = "n";
              key = "<leader>ws";
              action = config.lib.nixvim.mkRaw "require('telescope.builtin').lsp_dynamic_workspace_symbols";
              options.desc = "LSP: [W]orkspace [S]ymbols";
            }
            {
              mode = "n";
              key = "<leader>rn";
              lspBufAction = "rename";
              options.desc = "LSP: [R]e[n]ame";
            }
            {
              mode = "n";
              key = "<leader>ca";
              lspBufAction = "code_action";
              options.desc = "LSP: [C]ode [A]ction";
            }
            {
              mode = "n";
              key = "gD";
              lspBufAction = "declaration";
              options.desc = "LSP: [G]oto [D]eclaration";
            }
          ];
        };
        onAttach = ''
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
          end
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = bufnr,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = bufnr,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        '';
        keymaps = [
          {
            mode = "n";
            key = "<Esc>";
            action = "<cmd>nohlsearch<CR>";
          }
          {
            mode = "t";
            key = "<Esc><Esc>";
            action = "<C-\\><C-n>";
            options = {
              desc = "Exit terminal mode";
            };
          }
          {
            mode = "n";
            key = "<C-h>";
            action = "<C-w><C-h>";
            options = {
              desc = "Move focus to the left window";
            };
          }
          {
            mode = "n";
            key = "<C-l>";
            action = "<C-w><C-l>";
            options = {
              desc = "Move focus to the right window";
            };
          }
          {
            mode = "n";
            key = "<C-j>";
            action = "<C-w><C-j>";
            options = {
              desc = "Move focus to the lower window";
            };
          }
          {
            mode = "n";
            key = "<C-k>";
            action = "<C-w><C-k>";
            options = {
              desc = "Move focus to the upper window";
            };
          }
        ];
        autoGroups = {
          ew-autogroup = {
            clear = true;
          };
        };
        autoCmd = [
          {
            event = [ "TextYankPost" ];
            desc = "Highlight when yanking (copying) text";
            group = "ew-autogroup";
            callback = config.lib.nixvim.mkRaw ''
              function()
                vim.highlight.on_yank()
              end
            '';
          }
          {
            event = [ "FileType" ];
            pattern = [ "go" ];
            desc = "Set golang shiftwidth to 2 instead of 8";
            group = "ew-autogroup";
            callback =
              config.lib.nixvim.mkRaw # lua
                ''
                  function()
                    vim.bo.tabstop = 2
                    vim.bo.shiftwidth = 2
                    vim.bo.expandtab = false
                    end
                '';
          }
          {
            event = [ "FileType" ];
            pattern = [ "yaml" ];
            desc = "Set yaml files to use spaces";
            group = "ew-autogroup";
            callback = config.lib.nixvim.mkRaw ''
              function()
                vim.bo.expandtab = true
                end
            '';
          }
        ];
        extraConfigLuaPre = ''
          if vim.g.have_nerd_font then
            require('nvim-web-devicons').setup {}
          end
        '';
        extraConfigLuaPost = ''
          -- vim: ts=2 sts=2 sw=2 et
        '';
      };
    };
}
