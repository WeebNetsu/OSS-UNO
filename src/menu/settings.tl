require "src.utils.sfx"
require "src.menu.settings"
require "src.utils.cursor"

local love = require "love"
local utils = require "src.utils.utils"

-- settings counter that will generate an index for us automatically
local function SettingsCounter(): function(title: string, valueIndex: integer, availableValues: {string}): SettingsType.CounterType
    local i = 0

    return function(title: string, valueIndex: integer, availableValues: {string}): SettingsType.CounterType -- Anonymous function
        i = i + 1

        return {
            title = title,
            value = valueIndex or 1,
            availableValues = availableValues,
            displayIndex = i,
            hovering = false,

            onClick = function (self: SettingsType.CounterType)
                if not self.value or self.value == #self.availableValues then
                    self.value = 1
                    return
                end

                self.value = self.value + 1
            end,
        }
    end
end

local function Settings(sfx: SFXType, cursor: CursorType): SettingsType
    local settings: SettingsType = {}
    local newSettings: SavedSettingsType = utils.readJSON("settings")

    -- create a mini object to generate tables for us
    local SettingsOptions = SettingsCounter()
    local winSize = 1

    if (newSettings.windowSize) then
        local wSize: SavedSettingsType.WindowSizeType = newSettings.windowSize
        local winSizes = {"1280x720", "1920x1080"}
        local winWH = tostring(wSize.width) .. "x" .. tostring(wSize.height)

        for i = 0, #winSizes do
            if winSizes[i] == winWH then
                winSize = i
                break
            end
        end
    end

    settings.updated = false

    local settingOptions = {
        difficulty = SettingsOptions("Difficulty", newSettings.difficulty, {"Easy", "Normal", "Hard"}),
        windowSize = SettingsOptions("Window", winSize, {"1280x720", "1920x1080"}),
        controller = SettingsOptions("Controller", winSize, {"Controller", "Keyboard"}),
    }

    local textButtonScale, iconButtonScale = 0.7, 0.4
    local settingsXPos, settingsYPos = love.graphics.getWidth() / 4, 50
    local settingsValueXPos, settingsValueYPos = settingsXPos * 2 + 100, settingsYPos + utils.fonts.h4 + 50
    local isHoveringOverButton = false

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

    local iconButtons: {string: SettingButtonType} = {
        back = {
            src = utils.chooseButtonImage("back", true),
            hoverSrc = utils.chooseButtonImage("back", true, true),
            hovering = false,
            -- don't know why we don't need a scaled button width/height, but it works lol
            x = 80,
            y = 80,

            onClick = function (_self: SettingButtonType)
                utils:changeGameState("menu")
            end
        },
        save = {
            src = utils.chooseButtonImage("v", true),
            hoverSrc = utils.chooseButtonImage("v", true, true),
            hovering = false,
            -- don't know why we don't need a scaled button width/height, but it works lol
            x = 80,
            y = 330,

            onClick = function (_self: SettingButtonType)
                local width, height = string.match(settingOptions.windowSize.availableValues[settingOptions.windowSize.value], "(.*)x(.*)")

                -- by default it will be keyboard controlled unless changed
                local ctrl: SavedSettingsType.ControllerType

                if settingOptions.controller.availableValues[settingOptions.controller.value] == "Controller" then
                    ctrl = "controller"
                else
                    ctrl = "keyboard"
                end
                
                local saveSettings: SavedSettingsType = {
                    difficulty = settingOptions.difficulty.value,
                    windowSize = {
                        width = tonumber(width),
                        height = tonumber(height)
                    },
                    controller = ctrl
                }

                utils.writeJSON("settings", saveSettings)

                if love.graphics.getWidth() ~= tonumber(width) or love.graphics.getHeight() ~= tonumber(height) then
                    love.window.setMode(tonumber(width), tonumber(height))
                end
            end
        },
        undo = {
            src = utils.chooseButtonImage("return", true),
            hoverSrc = utils.chooseButtonImage("return", true, true),
            hovering = false,
            -- don't know why we don't need a scaled button width/height, but it works lol
            x = 80,
            y = 580,

            onClick = function (_self: SettingButtonType)
                print("Reset not implemented")
            end
        },
    }

    settings.update = function (self: SettingsType)
        -- this will decide when isHoveringOverButton will be set to true/false
        local isHovering = false
        
        for _, button in pairs(iconButtons) do
            button.hovering = utils.getMouseBetween(button.x * iconButtonScale, button.y * iconButtonScale, scale.iconButton.width, scale.iconButton.height, cursor.pos.x, cursor.pos.y)

            -- if isHovering is not already set to true (will always be false on the first loop, but
            -- might be true on any of the following loops) and the current button is being hovered over
            if not isHovering and button.hovering then
                isHovering = true
                isHoveringOverButton = true
            end

            -- if the isHoveringOverButton is true, play the sfx 
            if isHoveringOverButton then
                sfx:playFX("button_hover", "single")
                
                if cursor.clicked then
                    -- we need to set everything to false again here, otherwise all the buttons will
                    -- be executed
                    isHoveringOverButton = false
                    button.hovering = false
                    self.updated = true
                    button:onClick()
                end
            else
                sfx:setFXPlayed(false)
            end
        end

        -- If after the loop no buttons triggered isHovering to be true 
        if not isHovering then
            isHoveringOverButton = false
        end

        for _, setting in pairs(settingOptions as {string: SettingsType.CounterType}) do
            setting.hovering = utils.getMouseBetween(settingsValueXPos, settingsValueYPos * setting.displayIndex, settingsXPos, utils.fonts.h4, cursor.pos.x, cursor.pos.y)
            
            if cursor.clicked then
                if setting.hovering then
                    sfx:playFX("button_hover", "slow")
                    setting:onClick()
                end
            end
        end
    end

    settings.draw = function (_self: SettingsType)
        love.graphics.setFont(love.graphics.newFont(utils.fonts.h1))
        love.graphics.printf("Settings", 0, 20, love.graphics.getWidth(), "center" )

        love.graphics.setFont(love.graphics.newFont(utils.fonts.h4))

        for _, setting in pairs(settingOptions as {string: SettingsType.CounterType}) do
            if utils.debugging then
                love.graphics.rectangle("line", settingsXPos, settingsValueYPos * setting.displayIndex, settingsXPos, utils.fonts.h4)
                love.graphics.rectangle("line", settingsValueXPos, settingsValueYPos * setting.displayIndex, settingsXPos, utils.fonts.h4)
            end

            love.graphics.printf(setting.title, settingsXPos, settingsValueYPos * setting.displayIndex, settingsXPos, "left")

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
