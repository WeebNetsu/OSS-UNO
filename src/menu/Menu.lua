local love = require "love"
local utils = require "utils"

function Menu()
    local menu = {}

    local textButtons = {
        play = {
            src = utils:chooseButtonImage("play"),
            hoverSrc = utils:chooseButtonImage("play", false, true),
            hovering = false,
            icon = false,
            x = 0,
            y = 0,
        },
        -- settings = {
        --     src = utils:chooseButtonImage("settings"),
        --     hoverSrc = utils:chooseButtonImage("settings", true, true),
        --     hovering = false,
        --     icon = false,
        --     x = 0,
        --     y = 0,
        -- },
    }

    menu.update = function (self)
        for _, button in pairs(textButtons) do
            local width, height = utils.textButtonWidth, utils.textButtonHeight

            if button.icon then
                width, height = utils.iconButtonWidth, utils.iconButtonHeight
            end

            button.hovering = utils:getMouseBetween(button.x, button.y, width, height)
        end
    end

    menu.draw = function (self)
        for _, button in pairs(textButtons) do
            if button.hovering then
                love.graphics.draw(button.hoverSrc, button.x, button.y)
            else
                love.graphics.draw(button.src, button.x, button.y)
            end
        end
    end

    return menu
end

return Menu
