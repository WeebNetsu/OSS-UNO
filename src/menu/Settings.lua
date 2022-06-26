local love = require "love"
local utils= require "utils"

-- settings counter that will generate an index for us automatically
local function SettingsCounter()
    local i = 0

    return function(title, valueIndex, availableValues) -- anonimous function
        i = i + 1

        return {
            title = title,
            value = valueIndex or 1,
            availableValues = availableValues,
            displayIndex = i,
            hovering = false,

            onClick = function (self)
                if not self.value or self.value == #self.availableValues then
                    self.value = 1
                    return
                end

                self.value = self.value + 1
            end,
        }
    end
end

function Settings(switchState)
    local settings = {}
    local newSettings = utils:readJSON("settings")

    -- create a mini object to generate tables for us
    local SettingsOptions = SettingsCounter()
    local winSize = 1

    if (newSettings.windowSize) then
        local winSizes = {"1280x720", "1920x1080"}
        local winWH = tostring(newSettings.windowSize.width) .. "x" .. tostring(newSettings.windowSize.height)

        for i = 0, #winSizes do
            if winSizes[i] == winWH then
                winSize = i
                break
            end
        end
    end

    local settingOptions = {
        difficulty = SettingsOptions("Difficulty", newSettings.difficulty, {"Easy", "Normal", "Hard"}),
        windowSize = SettingsOptions("Window", winSize, {"1280x720", "1920x1080"}),
    }

    local textButtonScale, iconButtonScale = 0.7, 0.4
    local settingsXPos, settingsYPos = love.graphics.getWidth() / 4, 50
    local settingsValueXPos, settingsValueYPos = settingsXPos * 2 + 100, settingsYPos + utils.fonts.h4 + 50

    local scale = {
        textButton = {
            windowWidth = love.graphics.getWidth() / textButtonScale,
            windowHeight = love.graphics.getHeight() / textButtonScale,

            width = utils.textButtonWidth * textButtonScale,
            height = utils.textButtonHeight * textButtonScale,
        },
        iconButton = {
            windowWidth = love.graphics.getWidth() / iconButtonScale,
            windowHeight = love.graphics.getHeight() / iconButtonScale,

            width = utils.iconButtonWidth * iconButtonScale,
            height = utils.iconButtonHeight * iconButtonScale,
        }
    }

    local iconButtons = {
        back = {
            src = utils:chooseButtonImage("back", true),
            hoverSrc = utils:chooseButtonImage("back", true, true),
            hovering = false,
            -- don't know why we don't need a scaled button width/height, but it works lol
            x = 80,
            y = 80,

            onClick = function (self)
                switchState("menu")
            end
        },
        save = {
            src = utils:chooseButtonImage("v", true),
            hoverSrc = utils:chooseButtonImage("v", true, true),
            hovering = false,
            -- don't know why we don't need a scaled button width/height, but it works lol
            x = 80,
            y = 330,

            onClick = function (self)
                local width, height = string.match(settingOptions.windowSize.availableValues[settingOptions.windowSize.value], "(.*)x(.*)")
                local saveSettings = {
                    difficulty = settingOptions.difficulty.value,
                    windowSize = {
                        width = tonumber(width),
                        height = tonumber(height)
                    }
                }

                utils:writeJSON("settings", saveSettings)

                love.window.setMode(tonumber(width), tonumber(height))
            end
        },
        undo = {
            src = utils:chooseButtonImage("return", true),
            hoverSrc = utils:chooseButtonImage("return", true, true),
            hovering = false,
            -- don't know why we don't need a scaled button width/height, but it works lol
            x = 80,
            y = 580,

            onClick = function (self)
                print("Reset not implemented")
            end
        },
    }

    settings.update = function (self, clickedMouse)
        for _, button in pairs(iconButtons) do
            button.hovering = utils:getMouseBetween(button.x * iconButtonScale, button.y * iconButtonScale, scale.iconButton.width, scale.iconButton.height)

            if clickedMouse then
                if button.hovering then
                    button:onClick()
                end
            end
        end

        for _, setting in pairs(settingOptions) do
            setting.hovering = utils:getMouseBetween(settingsValueXPos, settingsValueYPos * setting.displayIndex, settingsXPos, utils.fonts.h4)

            if clickedMouse then
                if setting.hovering then
                    setting:onClick()
                end
            end
        end
    end

    settings.draw = function (self)
        love.graphics.setFont(love.graphics.newFont(utils.fonts.h1))
        love.graphics.printf("Settings", 0, 20, love.graphics.getWidth(), "center" )

        love.graphics.setFont(love.graphics.newFont(utils.fonts.h4))

        for _, setting in pairs(settingOptions) do
            if utils.debugging then
                love.graphics.rectangle("line", settingsXPos, settingsValueYPos * setting.displayIndex, settingsXPos, utils.fonts.h4)
                love.graphics.rectangle("line", settingsValueXPos, settingsValueYPos * setting.displayIndex, settingsXPos, utils.fonts.h4)
            end

            love.graphics.printf(setting.title, settingsXPos, settingsValueYPos * setting.displayIndex, settingsXPos, "left" )

            if setting.hovering then
                love.graphics.setColor(utils.colors.red.r, utils.colors.red.g, utils.colors.red.b)
            end

            love.graphics.printf(setting.availableValues[setting.value], settingsValueXPos, settingsValueYPos * setting.displayIndex, settingsXPos, "left" )

            love.graphics.setColor(1,1,1)
        end

        love.graphics.setFont(love.graphics.newFont(utils.fonts.p))

        -- draw icon buttons
        love.graphics.push()
        love.graphics.scale(iconButtonScale)

        for _, button in pairs(iconButtons) do
            if button.hovering then
                love.graphics.draw(button.hoverSrc, button.x, button.y)
            else
                love.graphics.draw(button.src, button.x, button.y)
            end
        end

        love.graphics.pop()
    end

    return settings
end

return Settings
