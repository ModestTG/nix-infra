{ ... }:
{
  flake.modules.homeManager.nixvim-plugins =
    { pkgs, ... }:
    {
      programs.nixvim = {
        extraPackages = with pkgs; [
          gofumpt
          markdownlint-cli
          nixfmt
          stylua
        ];
        extraConfigLua = ''
          require('dap').listeners.after.event_initialized['dapui_config'] = require('dapui').open
          require('dap').listeners.before.event_terminated['dapui_config'] = require('dapui').close
          require('dap').listeners.before.event_exited['dapui_config'] = require('dapui').close
          require('mini.statusline').section_location = function()
            return '%2l:%-2v'
          end
        '';
        keymaps = [
          {
            mode = "";
            key = "<leader>f";
            action.__raw = ''
              function()
                require('conform').format { async = true, lsp_fallback = true }
              end
            '';
            options = {
              desc = "[F]ormat buffer";
            };
          }
          {
            mode = "n";
            key = "<F5>";
            action.__raw = ''
              function()
                require('dap').continue()
              end
            '';
            options = {
              desc = "Debug: Start/Continue";
            };
          }
          {
            mode = "n";
            key = "<F1>";
            action.__raw = ''
              function()
                require('dap').step_into()
              end
            '';
            options = {
              desc = "Debug: Step Into";
            };
          }
          {
            mode = "n";
            key = "<F2>";
            action.__raw = ''
              function()
                require('dap').step_over()
              end
            '';
            options = {
              desc = "Debug: Step Over";
            };
          }
          {
            mode = "n";
            key = "<F3>";
            action.__raw = ''
              function()
                require('dap').step_out()
              end
            '';
            options = {
              desc = "Debug: Step Out";
            };
          }
          {
            mode = "n";
            key = "<leader>b";
            action.__raw = ''
              function()
                require('dap').toggle_breakpoint()
              end
            '';
            options = {
              desc = "Debug: Toggle Breakpoint";
            };
          }
          {
            mode = "n";
            key = "<leader>B";
            action.__raw = ''
              function()
                require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
              end
            '';
            options = {
              desc = "Debug: Set Breakpoint";
            };
          }
          {
            mode = "n";
            key = "<F7>";
            action.__raw = ''
              function()
                require('dapui').toggle()
              end
            '';
            options = {
              desc = "Debug: See last session result.";
            };
          }
          {
            mode = "n";
            key = "-";
            action.__raw = "function() require('oil').open() end";
          }
          {
            mode = "n";
            key = "<leader>/";
            action.__raw = ''
              function()
                require('telescope.builtin').current_buffer_fuzzy_find(
                  require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false
                  }
                )
              end
            '';
            options = {
              desc = "[/] Fuzzily search in current buffer";
            };
          }
          {
            mode = "n";
            key = "<leader>s/";
            action.__raw = ''
              function()
                require('telescope.builtin').live_grep {
                  grep_open_files = true,
                  prompt_title = 'Live Grep in Open Files'
                }
              end
            '';
            options = {
              desc = "[S]earch [/] in Open Files";
            };
          }
          {
            mode = "n";
            key = "<leader>sn";
            action.__raw = ''
              function()
                require('telescope.builtin').find_files {
                  cwd = vim.fn.stdpath 'config'
                }
              end
            '';
            options = {
              desc = "[S]earch [N]eovim files";
            };
          }
        ];
        autoGroups = {
          lint.clear = true;
          "kickstart-lsp-attach".clear = true;
        };
        plugins = {
          conform-nvim = {
            enable = true;
            settings = {
              notify_on_error = false;
              format_on_save = ''
                function(bufnr)
                  -- Disable "format_on_save lsp_fallback" for lanuages that don't
                  -- have a well standardized coding style. You can add additional
                  -- lanuages here or re-enable it for the disabled ones.
                  local disable_filetypes = { c = true, cpp = true }
                  return {
                    timeout_ms = 500,
                    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype]
                  }
                end
              '';
              formatters_by_ft = {
                lua = [ "stylua" ];
                nix = [ "nixfmt" ];
                go = [ "gofumpt" ];
              };
            };
          };
          dap.enable = true;
          dap-ui = {
            enable = true;
            settings = {
              icons = {
                expanded = "▾";
                collapsed = "▸";
                current_frame = "*";
              };
              controls = {
                icons = {
                  pause = "⏸";
                  play = "▶";
                  step_into = "⏎";
                  step_over = "⏭";
                  step_out = "⏮";
                  step_back = "b";
                  run_last = "▶▶";
                  terminate = "⏹";
                  disconnect = "⏏";
                };
              };
              dap-go = {
                enable = true;
                delve.path = "${pkgs.delve}/bin/dlv";
              };
            };
          };
          cmp = {
            enable = true;
            settings = {
              snippet = {
                expand = ''
                  function(args)
                    require('luasnip').lsp_expand(args.body)
                  end
                '';
              };
              completion = {
                completeopt = "menu,menuone,noinsert";
              };
              mapping = {
                "<C-n>" = "cmp.mapping.select_next_item()";
                "<C-p>" = "cmp.mapping.select_prev_item()";
                "<C-b>" = "cmp.mapping.scroll_docs(-4)";
                "<C-f>" = "cmp.mapping.scroll_docs(4)";
                "<C-y>" = "cmp.mapping.confirm { select = true }";
                "<C-Space>" = "cmp.mapping.complete {}";
                "<C-l>" = ''
                  cmp.mapping(function()
                    if luasnip.expand_or_locally_jumpable() then
                      luasnip.expand_or_jump()
                    end
                  end, { 'i', 's' })
                '';
                "<C-h>" = ''
                  cmp.mapping(function()
                    if luasnip.locally_jumpable(-1) then
                      luasnip.jump(-1)
                    end
                  end, { 'i', 's' })
                '';
              };
              sources = [
                {
                  name = "luasnip";
                }
                {
                  name = "nvim_lsp";
                }
                {
                  name = "path";
                }
              ];
            };
          };
          cmp-nvim-lsp.enable = true;
          fidget.enable = true;
          luasnip.enable = true;
          gitsigns = {
            enable = true;
            settings = {
              signs = {
                add = {
                  text = "+";
                };
                change = {
                  text = "~";
                };
                delete = {
                  text = "_";
                };
                topdelete = {
                  text = "‾";
                };
                changedelete = {
                  text = "~";
                };
              };
            };
          };
          indent-blankline.enable = true;
          lint = {
            enable = true;
            lintersByFt = {
              nix = [ "nix" ];
              markdown = [ "markdownlint" ];
            };
            autoCmd = {
              callback.__raw = ''
                function()
                  require('lint').try_lint()
                end
              '';
              group = "lint";
              event = [
                "BufEnter"
                "BufWritePost"
                "InsertLeave"
              ];
            };
          };
          lspconfig.enable = true;
          mini = {
            enable = true;
            modules = {
              ai = {
                n_lines = 500;
              };
              pairs = { };
              surround = { };
              statusline = {
                use_icons.__raw = "vim.g.have_nerd_font";
              };
            };
          };
          oil = {
            enable = true;
            settings = {
              default_file_explorer = true;
              columns = [ "icon" ];
              buff_options = {
                buflisted = false;
                bufhidden = "hide";
              };
              win_options = {
                wrap = false;
                signcolumn = "no";
                cursorcolumn = false;
                foldcolumn = "0";
                spell = false;
                list = false;
                conceallevel = 3;
                concealcursor = "nvic";
              };
              delete_to_trash = false;
              skip_confirm_for_simple_edits = false;
              prompt_save_on_select_new_entry = true;
              cleanup_delay_ms = 2000;
              lsp_file_methods = {
                autosave_changes = false;
              };
              constrain_cursor = "editable";
              keymaps = {
                "g?" = "actions.show_help";
                "<CR>" = "actions.select";
                "<C-s>" = "actions.select_vsplit";
                "<C-h>" = "actions.select_split";
                "<C-t>" = "actions.select_tab";
                "<C-p>" = "actions.preview";
                "<C-c>" = "actions.close";
                "<C-l>" = "actions.refresh";
                "-" = "actions.parent";
                "_" = "actions.open_cwd";
                "`" = "actions.cd";
                "~" = "actions.tcd";
                "gs" = "actions.change_sort";
                "gx" = "actions.open_external";
                "g." = "actions.toggle_hidden";
                "g\\" = "actions.toggle_trash";
              };
              use_default_keymaps = true;
              view_options = {
                show_hidden = true;
              };
              sort = {
                "type" = "asc";
                "name" = "asc";
              };
              float = {
                padding = 2;
                max_width = 0;
                max_height = 0;
                border = "rounded";
                win_options = {
                  winblend = 0;
                };
              };
              preview = {
                max_width = 0.9;
                min_width = 0.4;
                width = null;
                max_height = 0.9;
                min_height = 0.1;
                height = null;
                border = "rounded";
                win_options = {
                  winblend = 0;
                };
                update_on_cursor_moved = true;
              };
              progress = {
                max_width = 0.9;
                min_width = 0.4;
                width = null;
                max_height = 0.9;
                min_height = 0.1;
                height = null;
                border = "rounded";
                minimized_border = "none";
                win_options = {
                  winblend = 0;
                };
              };
            };
          };
          sleuth.enable = true;
          telescope = {
            enable = true;
            extensions = {
              fzf-native.enable = true;
              ui-select.enable = true;
            };
            keymaps = {
              "<leader>sh" = {
                mode = "n";
                action = "help_tags";
                options = {
                  desc = "[S]earch [H]elp";
                };
              };
              "<leader>sk" = {
                mode = "n";
                action = "keymaps";
                options = {
                  desc = "[S]earch [K]eymaps";
                };
              };
              "<leader>sf" = {
                mode = "n";
                action = "find_files";
                options = {
                  desc = "[S]earch [F]iles";
                };
              };
              "<leader>ss" = {
                mode = "n";
                action = "builtin";
                options = {
                  desc = "[S]earch [S]elect Telescope";
                };
              };
              "<leader>sw" = {
                mode = "n";
                action = "grep_string";
                options = {
                  desc = "[S]earch current [W]ord";
                };
              };
              "<leader>sg" = {
                mode = "n";
                action = "live_grep";
                options = {
                  desc = "[S]earch by [G]rep";
                };
              };
              "<leader>sd" = {
                mode = "n";
                action = "diagnostics";
                options = {
                  desc = "[S]earch [D]iagnostics";
                };
              };
              "<leader>sr" = {
                mode = "n";
                action = "resume";
                options = {
                  desc = "[S]earch [R]esume";
                };
              };
              "<leader>s" = {
                mode = "n";
                action = "oldfiles";
                options = {
                  desc = "[S]earch Recent Files ('.' for repeat)";
                };
              };
              "<leader><leader>" = {
                mode = "n";
                action = "buffers";
                options = {
                  desc = "[ ] Find existing buffers";
                };
              };
            };
            settings = {
              extensions.__raw = "{ ['ui-select'] = { require('telescope.themes').get_dropdown() } }";
            };
          };
          tmux-navigator.enable = true;
          treesitter = {
            enable = true;
            highlight.enable = true;
            indent.enable = true;
          };
          treesitter-textobjects = {
            enable = true;
          };
          web-devicons.enable = true;
          which-key = {
            enable = true;
            settings = {
              spec = [
                {
                  __unkeyed-1 = "<leader>c";
                  group = "[C]ode";
                }
                {
                  __unkeyed-1 = "<leader>d";
                  group = "[D]ocument";
                }
                {
                  __unkeyed-1 = "<leader>r";
                  group = "[R]ename";
                }
                {
                  __unkeyed-1 = "<leader>s";
                  group = "[S]earch";
                }
                {
                  __unkeyed-1 = "<leader>w";
                  group = "[W]orkspace";
                }
                {
                  __unkeyed-1 = "<leader>t";
                  group = "[T]oggle";
                }
                {
                  __unkeyed-1 = "<leader>h";
                  group = "Git [H]unk";
                  mode = [
                    "n"
                    "v"
                  ];
                }
              ];
            };
          };
        };
        extraPlugins = with pkgs.vimPlugins; [
          nvim-sops # sops file encryption/decryption
        ];
      };
    };
}
