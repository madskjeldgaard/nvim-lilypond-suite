local Utils = require('nvls.utils')
local nvls_options = require('nvls').get_nvls_options()
local audio_format = nvls_options.player.options.audio_format
local midi_synth = nvls_options.player.options.midi_synth
local os = vim.loop.os_uname().sysname

local main_folder
local main_file

local M = {}

function M.fileInfos(ft)
  local file = {}

  if ft == "tex" then
    main_folder = nvls_options.latex.options.main_folder
    main_file = nvls_options.latex.options.main_file
  elseif ft == "lilypond" then
    main_folder = nvls_options.lilypond.options.main_folder
    main_file = nvls_options.lilypond.options.main_file
  end

  local main = Utils.shellescape(vim.fn.expand('%:p'))
  local main_path = Utils.joinpath(vim.fn.expand(main_folder), main_file)

  if Utils.exists(main_path) then
    main = Utils.shellescape(main_path)
  end

  local name = main:gsub("%.(i?ly)$", ""):gsub("%.tex$", "")
  if os == "Windows" then
    file.name = name:match('.*\\([^\\]+)$')
  else
    file.name = name:match('.*/([^/]+)$'):gsub([[\]], "")
  end

  if os == "Windows" or midi_synth == "timidity" then
    audio_format = "wav"
  end

  file.pdf    = Utils.change_extension(main, "pdf")
  file.audio  = Utils.change_extension(main, audio_format)
  file.midi   = Utils.change_extension(main, "midi")
  file.main   = main
  file.folder = Utils.shellescape(vim.fn.expand(main_folder))
  file.tmp    = Utils.joinpath(vim.fn.stdpath('cache'), 'nvls')
  vim.fn.mkdir(file.tmp, 'p')

  return file
end

return M
