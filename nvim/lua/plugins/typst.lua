local state = {
  watch_job = nil,
  watch_file = nil,
  output = {},
}

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = 'Typst' })
end

local function executable(name)
  if vim.fn.executable(name) == 1 then
    return true
  end
  notify(name .. ' is not installed or is not in $PATH', vim.log.levels.ERROR)
  return false
end

local function paths()
  local input = vim.api.nvim_buf_get_name(0)
  if input == '' then
    notify('Save the Typst buffer first.', vim.log.levels.ERROR)
    return nil, nil
  end

  input = vim.fn.fnamemodify(input, ':p')
  local output = vim.fn.fnamemodify(input, ':r') .. '.pdf'
  return input, output
end

local function project_root(input)
  local start = vim.fn.fnamemodify(input, ':h')
  local found = vim.fs.find({ 'typst.toml', '.git' }, {
    path = start,
    upward = true,
  })

  if #found > 0 then
    return vim.fs.dirname(found[1])
  end

  return start
end

local function append_output(lines)
  if not lines then
    return
  end

  for _, line in ipairs(lines) do
    if line ~= nil and line ~= '' then
      table.insert(state.output, line)
    end
  end

  if #state.output > 1000 then
    state.output = vim.list_slice(state.output, #state.output - 999, #state.output)
  end
end

local function open_sioyek(pdf)
  if not executable('sioyek') then
    return
  end

  vim.fn.jobstart({ 'sioyek', pdf }, { detach = true })
end

local function show_output()
  vim.cmd('botright 12new')

  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = true
  vim.bo[buf].filetype = 'text'

  local lines = #state.output > 0
      and state.output
      or { 'No Typst compiler output yet.' }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  pcall(vim.api.nvim_buf_set_name, buf, 'Typst compile output')
end

local function compile_once(open_after)
  if not executable('typst') then
    return
  end

  local input, output = paths()
  if not input then
    return
  end

  vim.cmd('silent write')
  state.output = {}

  vim.system({
    'typst',
    '--color=never',
    'compile',
    '--diagnostic-format=short',
    input,
    output,
  }, {
    text = true,
    cwd = project_root(input),
  }, function(result)
    append_output(vim.split(result.stdout or '', '\n', { plain = true }))
    append_output(vim.split(result.stderr or '', '\n', { plain = true }))

    vim.schedule(function()
      if result.code == 0 then
        notify('Compiled ' .. vim.fn.fnamemodify(output, ':t'))
        if open_after then
          open_sioyek(output)
        end
      else
        notify('Typst compilation failed. Use \\lo for compiler output.', vim.log.levels.ERROR)
      end
    end)
  end)
end

local function start_watch()
  if state.watch_job then
    notify('Typst watch is already running.')
    return
  end

  if not executable('typst') or not executable('sioyek') then
    return
  end

  local input, output = paths()
  if not input then
    return
  end

  vim.cmd('silent write')
  state.output = {}
  state.watch_file = input

  local function on_data(_, data)
    append_output(data)
  end

  local job = vim.fn.jobstart({
    'typst',
    '--color=never',
    'watch',
    '--diagnostic-format=short',
    '--open=sioyek',
    input,
    output,
  }, {
    cwd = project_root(input),
    stdout_buffered = false,
    stderr_buffered = false,
    on_stdout = on_data,
    on_stderr = on_data,
    on_exit = function(_, code)
      vim.schedule(function()
        state.watch_job = nil
        state.watch_file = nil

        -- SIGTERM from jobstop commonly appears as a non-zero exit.
        if code ~= 0 and code ~= 143 then
          notify('Typst watch exited with code ' .. code .. '. Use \\lo for output.', vim.log.levels.WARN)
        end
      end)
    end,
  })

  if job <= 0 then
    state.watch_file = nil
    notify('Failed to start typst watch.', vim.log.levels.ERROR)
    return
  end

  state.watch_job = job
  notify('Typst watch started.')
end

local function stop_watch()
  if not state.watch_job then
    notify('Typst watch is not running.')
    return
  end

  vim.fn.jobstop(state.watch_job)
  state.watch_job = nil
  state.watch_file = nil
  notify('Typst watch stopped.')
end

local function toggle_watch()
  if state.watch_job then
    stop_watch()
  else
    start_watch()
  end
end

local function view_pdf()
  local input, output = paths()
  if not input then
    return
  end

  if vim.fn.filereadable(output) == 1 then
    open_sioyek(output)
  else
    compile_once(true)
  end
end

local function clean_pdf()
  local _, output = paths()
  if not output then
    return
  end

  if vim.fn.filereadable(output) == 1 then
    vim.fn.delete(output)
    notify('Removed ' .. vim.fn.fnamemodify(output, ':t'))
  else
    notify('No generated PDF to remove.')
  end
end

local function clean_all()
  stop_watch()
  clean_pdf()
end

local function status()
  local input, output = paths()
  if not input then
    return
  end

  local running = state.watch_job and 'running' or 'stopped'
  local pdf = vim.fn.filereadable(output) == 1 and 'exists' or 'missing'
  local coc_ready = vim.fn['coc#rpc#ready']() == 1 and 'ready' or 'not ready'

  notify(table.concat({
    'watch: ' .. running,
    'pdf: ' .. pdf,
    'coc: ' .. coc_ready,
    'file: ' .. vim.fn.fnamemodify(input, ':t'),
  }, '\n'))
end

local function info()
  local typst_version = executable('typst')
      and vim.trim(vim.fn.system({ 'typst', '--version' }))
      or 'typst: missing'

  local tinymist_version = executable('tinymist')
      and vim.trim(vim.fn.system({ 'tinymist', '--version' }))
      or 'tinymist: missing'

  notify(typst_version .. '\n' .. tinymist_version)
end

local function set_typst_keymaps(bufnr)
  local function map(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, {
      buffer = bufnr,
      silent = true,
      desc = desc,
    })
  end

  -- VimTeX-style workflow.
  map('<localleader>ll', toggle_watch, 'Typst: toggle continuous compile')
  map('<localleader>lv', view_pdf, 'Typst: view PDF in Sioyek')
  map('<localleader>lk', stop_watch, 'Typst: stop continuous compile')
  map('<localleader>lL', function() compile_once(false) end, 'Typst: compile once')
  map('<localleader>le', '<cmd>CocDiagnostics<cr>', 'Typst: errors')
  map('<localleader>lo', show_output, 'Typst: compiler output')
  map('<localleader>lg', status, 'Typst: status')
  map('<localleader>li', info, 'Typst: info')
  map('<localleader>lc', clean_pdf, 'Typst: clean PDF')
  map('<localleader>lC', clean_all, 'Typst: stop and clean')
  map('<localleader>lt', '<cmd>CocList outline<cr>', 'Typst: table of contents / outline')

  -- Extra Tinymist browser-preview controls.
  map('<localleader>lp', '<cmd>TypstPreviewToggle<cr>', 'Typst: toggle browser preview')
  map('<localleader>lf', '<cmd>TypstPreviewFollowCursorToggle<cr>', 'Typst: toggle preview follow-cursor')
  map('<localleader>ls', '<cmd>TypstPreviewSyncCursor<cr>', 'Typst: sync preview to cursor')
end

return {
  {
    'chomosuke/typst-preview.nvim',
    ft = 'typst',
    version = '1.*',
    opts = {
      dependencies_bin = {
        tinymist = 'tinymist',
      },
      follow_cursor = true,
    },
    config = function(_, opts)
      require('typst-preview').setup(opts)

      local group = vim.api.nvim_create_augroup('typst_workflow', { clear = true })

      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = 'typst',
        callback = function(args)
          set_typst_keymaps(args.buf)
        end,
      })

      -- lazy.nvim loads this plugin on the Typst FileType event, so install
      -- mappings for the buffer that caused the plugin to load as well.
      if vim.bo.filetype == 'typst' then
        set_typst_keymaps(vim.api.nvim_get_current_buf())
      end
    end,
  },
}
