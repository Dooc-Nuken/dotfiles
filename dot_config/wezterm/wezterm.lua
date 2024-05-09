-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = {}
-- Config builder for better error handling
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Settings
config.color_scheme = "AdventureTime"
config.font = wezterm.font("JetBrains Mono")
config.font_size = 13.0
config.enable_tab_bar = false
config.window_background_opacity = 0.9
config.automatically_reload_config = true
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = "NeverPrompt"
config.disable_default_key_bindings = true
config.use_dead_keys = true
return config
