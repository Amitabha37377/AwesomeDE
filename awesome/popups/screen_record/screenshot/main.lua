local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")

local color = require("popups.color")
local titlebar = require("popups.screen_record.screenshot.titlebar")

local ss_buttons = require('popups.screen_record.screenshot.buttons')
local timer_button = ss_buttons.timed
local fullscreen = ss_buttons.full
local selection = ss_buttons.selection

local Separator = wibox.widget.textbox("    ")
Separator.forced_height = 330
Separator.forced_width = 540

----------------------------------------------
--Text Boxes----------------------------------
----------------------------------------------


--Delay time----------------------------------

local delay_time = 3

local function timer_value(num)
	if (num > 0) then
		Value = num;
	else
		Value = 0;
	end
	return Value
end

local delay_text = wibox.widget {
	-- text = user.name,
	markup = '<span color="' ..
		color.white .. '" font="Ubuntu Nerd Font 15">' .. "Delay in seconds" .. '</span>',
	font = "Ubuntu Nerd Font Bold 14",
	widget = wibox.widget.textbox,
	fg = color.white
}

local timer = wibox.widget {
	markup = '<span color="' ..
		color.blue .. '" font="Ubuntu Nerd Font bold 15">' .. "󱎫 " .. timer_value(delay_time) .. " " .. '</span>',
	font = "Ubuntu Nerd Font Bold 14",
	widget = wibox.widget.textbox,
	fg = color.white

}

local increase_timer = wibox.widget {
	markup = '<span color="' ..
		color.yellow .. '" font="Ubuntu Nerd Font bold 15">' .. "    " .. '</span>',
	font = "Ubuntu Nerd Font Bold 14",
	widget = wibox.widget.textbox,
	fg = color.white

}

increase_timer:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		delay_time = delay_time + 1
		timer:set_markup_silently('<span color="' ..
			color.blue .. '" font="Ubuntu Nerd Font bold 15">' .. "󱎫 " .. timer_value(delay_time) .. " " .. '</span>')
	end
end)


local decrease_timer = wibox.widget {
	markup = '<span color="' ..
		color.red .. '" font="Ubuntu Nerd Font bold 15">' .. "    " .. '</span>',
	font = "Ubuntu Nerd Font Bold 14",
	widget = wibox.widget.textbox,
	fg = color.white

}

decrease_timer:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		if delay_time > 0 then
			delay_time = delay_time - 1
		else
			delay_time = delay_time
		end
		timer:set_markup_silently('<span color="' ..
			color.blue .. '" font="Ubuntu Nerd Font bold 15">' .. "󱎫 " .. timer_value(delay_time) .. " " .. '</span>')
	end
end)

local vertical_separator = wibox.widget {
	orientation = 'vertical',
	forced_height = dpi(1.5),
	forced_width = dpi(1.5),
	span_ratio = 0.75,
	widget = wibox.widget.separator,
	color = "#a9b1d6",
	border_color = "#a9b1d6",
	opacity = 0.75
}

local delay_control = wibox.widget {
	{
		{
			increase_timer,
			vertical_separator,
			decrease_timer,
			layout = wibox.layout.fixed.horizontal
		},
		widget = wibox.container.margin,
		left = dpi(4),
		right = dpi(4)
	},
	widget = wibox.container.background,
	bg = color.background_lighter2,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 5)
	end,
}

local delay = wibox.widget {
	{
		{
			delay_text,
			widget = wibox.container.margin,
			left = dpi(15),
			top = dpi(12),
			bottom = dpi(12),
			right = dpi(155),
		},
		{
			timer,
			widget = wibox.container.margin,
			left = dpi(10),
			top = dpi(12),
			bottom = dpi(12),
			right = dpi(10),
		},
		{
			delay_control,
			widget = wibox.container.margin,
			left = dpi(0),
			top = dpi(7),
			bottom = dpi(7),
			-- right = dpi(5),
		},
		layout = wibox.layout.fixed.horizontal,
		forced_width = dpi(490)

	},
	widget = wibox.container.background,
	bg = color.background_lighter,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 5)
	end,

}

--Toggle Mouse cursor-------------------------

local pointer_visible = true

local pointer_text = wibox.widget {
	-- text = user.name,
	markup = '<span color="' ..
		color.white .. '" font="Ubuntu Nerd Font 15">' .. "Show mouse cursor" .. '</span>',
	font = "Ubuntu Nerd Font Bold 14",
	widget = wibox.widget.textbox,
	fg = color.white
}

local toggle_button = wibox.widget {
	-- text = user.name,
	markup = '<span color="' ..
		color.blue .. '" font="Ubuntu Nerd Font bold 23">' .. "   " .. '</span>',
	font = "Ubuntu Nerd Font Bold 14",
	widget = wibox.widget.textbox,
	fg = color.white
}

local toggle_cursor = wibox.widget {
	{
		{
			pointer_text,
			widget = wibox.container.margin,
			left = dpi(15),
			top = dpi(12),
			bottom = dpi(12),
			right = dpi(220),
		},
		{
			toggle_button,
			widget = wibox.container.margin,
			left = dpi(15),
			top = dpi(0),
			bottom = dpi(0),
			right = dpi(5),
		},
		layout = wibox.layout.fixed.horizontal,
		forced_width = dpi(490)

	},
	widget = wibox.container.background,
	bg = color.background_lighter,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 5)
	end,

}

toggle_button:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		pointer_visible = not pointer_visible
		if pointer_visible then
			toggle_button:set_markup_silently('<span color="' ..
				color.blue .. '" font="Ubuntu Nerd Font bold 23">' .. "   " .. '</span>')
		else
			toggle_button:set_markup_silently('<span color="' ..
				color.blue .. '" font="Ubuntu Nerd Font bold 23">' .. "   " .. '</span>')
		end
	end
end)



----------------------------------------------
--Main Popup----------------------------------
----------------------------------------------
local ss_tool = awful.popup {
	screen = s,
	widget = wibox.container.background,
	ontop = true,
	bg = "#00000000",
	visible = false,
	-- maximum_width = 200,
	placement = function(c)
		awful.placement.centered(c,
			{ margins = { top = dpi(0), bottom = dpi(0), left = dpi(0), right = dpi(0) } })
	end,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 0)
	end,
	opacity = 1,
	forced_height = dpi(330),
	forced_width = dpi(540),
	border_color = color.blue,
	border_width = dpi(2)
}

ss_tool:setup {
	titlebar,
	{
		{
			Separator,
			widget = wibox.container.background,
			bg = color.background_dark
		},
		{
			{
				{
					{
						fullscreen,
						widget = wibox.container.margin,
						left = dpi(10),
						right = dpi(10)
					},
					{
						selection,
						widget = wibox.container.margin,
						left = dpi(10),
						right = dpi(10)
					},
					{
						timer_button,
						widget = wibox.container.margin,
						left = dpi(10),
						right = dpi(10)
					},
					layout = wibox.layout.fixed.horizontal
				},
				widget = wibox.container.margin,
				top = dpi(20),
				bottom = dpi(20),
				left = dpi(15),
				right = dpi(15),
			},
			{
				delay,
				widget = wibox.container.margin,
				top = dpi(10),
				bottom = dpi(0),
				left = dpi(25),
				right = dpi(25)
			},
			{
				toggle_cursor,
				widget = wibox.container.margin,
				top = dpi(15),
				bottom = dpi(28),
				left = dpi(25),
				right = dpi(25)
			},

			layout = wibox.layout.fixed.vertical
		},
		layout = wibox.layout.stack
	},

	layout = wibox.layout.fixed.vertical
}

awesome.connect_signal("widget::screenshot", function()
	ss_tool.visible = false
end)

--Screenshot Functionalities-----------------
---------------------------------------------

local ss_index = tonumber(io.popen("cat ~/.config/awesome/ss_index.txt"):read("*all"))

local open_pictures = naughty.action {
	name = 'Pictures',
	icon_only = false,
}

local delete_ss = naughty.action {
	name = 'Delete',
	icon_only = false,
}

local open_image = naughty.action {
	name = 'Open',
	icon_only = false,
}

open_pictures:connect_signal(
	'invoked',
	function()
		awful.spawn('thunar ' .. 'Pictures', false)
	end
)

delete_ss:connect_signal(
	'invoked',
	function()
		awful.spawn.with_shell('rm ' .. 'Pictures/' .. ss_index - 1 .. '.png', false)
	end
)

open_image:connect_signal(
	'invoked',
	function()
		awful.spawn.with_shell('feh Pictures/' .. ss_index - 1 .. '.png --scale-down', false)
	end
)

fullscreen:connect_signal("button::release", function(_, _, _, button)
	if button == 1 then
		ss_tool.visible = false
		awful.spawn.easy_async_with_shell('sleep 0.3 && maim ~/Pictures/' .. ss_index .. '.png',
			function()
				naughty.notify
				(
					{
						title = '<span color="' ..
							color.white .. '" font="Ubuntu Nerd Font Bold 14">  Screenshot Tool</span>',
						text = '<span color="' .. color.white .. '"> Screenshot Captured!</span>',
						timeout = 5,
						icon = os.getenv("HOME") .. "/Pictures/" .. ss_index .. ".png",
						actions = { open_image, open_pictures, delete_ss }
					}
				)
				ss_index = ss_index + 1
				awful.spawn.with_shell('echo ' .. ss_index + 1 .. ' > ~/.config/awesome/ss_index.txt')
			end)
	end
end)

timer_button:connect_signal("button::release", function(_, _, _, button)
	if button == 1 then
		ss_tool.visible = false
		awful.spawn.easy_async_with_shell('sleep 0.3 && maim -d ' .. delay_time .. ' ~/Pictures/' .. ss_index .. '.png',
			function()
				naughty.notify
				(
					{
						title = '<span color="' ..
							color.white .. '" font="Ubuntu Nerd Font Bold 14">  Screenshot Tool</span>',
						text = '<span color="' .. color.white .. '"> Screenshot Captured!</span>',

						timeout = 5,
						icon = os.getenv("HOME") .. "/Pictures/" .. ss_index .. ".png",
						actions = { open_image, open_pictures, delete_ss }
					}
				)
				ss_index = ss_index + 1
				awful.spawn.with_shell('echo ' .. ss_index + 1 .. ' > ~/.config/awesome/ss_index.txt')
			end)
	end
end)

selection:connect_signal("button::release", function(_, _, _, button)
	if button == 1 then
		ss_tool.visible = false
		awful.spawn.easy_async_with_shell('sleep 0.3 && maim -s ' .. '~/Pictures/' .. ss_index .. '.png',
			function()
				naughty.notify
				(
					{
						title = '<span color="' ..
							color.white .. '" font="Ubuntu Nerd Font Bold 14">  Screenshot Tool</span>',
						text = '<span color="' .. color.white .. '"> Screenshot Captured!</span>',
						-- title = '<span font="Ubuntu Nerd Font Bold 14">  Screenshot Tool</span>',
						-- text = "Screen Captured!",
						timeout = 5,
						icon = os.getenv("HOME") .. "/Pictures/" .. ss_index .. ".png",
						actions = { open_image, open_pictures, delete_ss }
					}
				)
				ss_index = ss_index + 1
				awful.spawn.with_shell('echo ' .. ss_index + 1 .. ' > ~/.config/awesome/ss_index.txt')
			end)
	end
end)


return ss_tool
