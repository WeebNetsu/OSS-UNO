require "src.utils.sfx"
require "src.menu.menu"
require "src.game.game"

local love = require "love"
local utils = require "src.utils.utils"
local Settings = require "src.menu.settings"

local function Menu(game: GameType, sfx: SFXType): MenuType
    local menu: MenuType = {}
    local textButtonScale, iconButtonScale = 0.7, 0.5
    local settings: SettingsType

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

    local backgroundImage = love.graphics.newImage("assets/backgrounds/bg2.png")

    local textButtons: {string: SettingButtonType} = {
        play = {
            src = utils.chooseButtonImage("play"),
            hoverSrc = utils.chooseButtonImage("play", false, true),
            hovering = false,
            x = scale.textButton.windowWidth / 2 - utils.textButtonWidth / 2,
            y = scale.textButton.windowHeight / 2 - scale.textButton.height,

            onClick = function (_self: SettingButtonType)
                game:load()
                utils:changeGameState("game")
            end
        }
    }

    local iconButtons: {string: SettingButtonType} = {
        settings = {
            src = utils.chooseButtonImage("settings", true),
            hoverSrc = utils.chooseButtonImage("settings", true, true),
            hovering = false,
            -- don't know why we don't need a scaled button width/height, but it works lol
            x = scale.iconButton.windowWidth - utils.iconButtonWidth - 100,
            y = scale.iconButton.windowHeight - utils.iconButtonHeight - 100,

            onClick = function (_self: SettingButtonType)
                utils:changeGameState("settings")
            end
        },
        quit = {
            src = utils.chooseButtonImage("quit", true),
            hoverSrc = utils.chooseButtonImage("quit", true, true),
            hovering = false,
            -- don't know why we don't need a scaled button width/height, but it works lol
            x = 100,
            y = scale.iconButton.windowHeight - utils.iconButtonHeight - 100,

            onClick = function (_self: SettingButtonType)
                love.event.quit()
            end
        },
    }

    --[[
        This function will run button checks that needs to be ran on each
        game update loop

        @param clickedMouse: boolean -- if mouse has been clicked
        @param iconBtns: boolean -- if loop is for icon buttons
     ]]
    local function runButtonChecks(clickedMouse: boolean, iconBtns: boolean)
        -- if the cursor is hovering over the text or image buttons
        local hoveringText = utils.checkButtonsHovering(textButtons)
        local hoveringIcon = utils.checkButtonsHovering(iconButtons)

        local buttons = textButtons
        local currentScale = textButtonScale
        local selectedScale = scale.textButton

        if iconBtns then
            buttons = iconButtons
            currentScale = iconButtonScale
            selectedScale = scale.iconButton
        end

        for _, button in pairs(buttons) do
            button.hovering = utils.getMouseBetween(button.x * currentScale, button.y * currentScale, selectedScale.width, selectedScale.height)

            if button.hovering then
                sfx:playFX("button_hover", "single")

                if clickedMouse then
                    button:onClick()
                end
            else
                -- if not hovering over icon buttons
                if not (hoveringText or hoveringIcon) then
                    sfx:setFXPlayed(false)
                end
            end
        end
    end

    menu.load = function (_self: MenuType)
        utils.changeGameState()

        settings = Settings(sfx)
    end

    menu.update = function (_self: MenuType, clickedMouse: boolean)
        if utils.state.menu then
            runButtonChecks(clickedMouse, false)
            runButtonChecks(clickedMouse, true)
        elseif utils.state.settings then
            settings:update(clickedMouse)
        end
    end

    menu.draw = function (_self: MenuType)
        if utils.state.menu then
            love.graphics.draw(backgroundImage, 0, 0)

            -- draw text buttons
            love.graphics.push()
            love.graphics.scale(textButtonScale) -- the sprite was a bit large, so I scaled it to a resonable size
    
            for _, button in pairs(textButtons) do
                if button.hovering then
                    love.graphics.draw(button.hoverSrc, button.x, button.y)
                else
                    love.graphics.draw(button.src, button.x, button.y)
                end
            end
    
            love.graphics.pop()
    
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
        elseif utils.state.settings then
            settings:draw()
        end
    end

    return menu
end

return Menu
