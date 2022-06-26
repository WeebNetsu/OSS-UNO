local love = require "love"
local utils= require "utils"

function Settings(switchState)
    local settings = {}

    -- create a mini object to generate tables for us
    local function SettingsOptions(title, valueIndex, availableValues, index)
        valueIndex = valueIndex or 1

        return {
            title = title,
            value = availableValues[valueIndex],
            availableValues = availableValues,
            displayIndex = index,
            hovering = false,

            onClick = function (self)
                local selectedIndex

                for index, value in pairs(self.availableValues) do
                    if value == self.value then
                        selectedIndex = index
                    end
                end

                if not selectedIndex or selectedIndex == #self.availableValues then
                    self.value = self.availableValues[1]
                    return
                end

                self.value = self.availableValues[selectedIndex + 1]
            end,
        }
    end
    
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
                print("Save not implemented")
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

    local settingOptions = {
        difficulty = SettingsOptions("Difficulty", 2, {"Easy", "Normal", "Hard"}, 1),
        windowSize = SettingsOptions("Window", 1, {"1280x720", "1920x1080"}, 2),
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

            love.graphics.printf(setting.value, settingsValueXPos, settingsValueYPos * setting.displayIndex, settingsXPos, "left" )

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
