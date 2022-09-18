local love = require "love"

local function SFX()
    local effects = {
        button_hover = love.audio.newSource("assets/ui-sounds/button_hover.wav", "static"),
        card_draw = love.audio.newSource("assets/ui-sounds/card_draw.mp3", "static"),
        card_shuffle = love.audio.newSource("assets/ui-sounds/card_shuffle.wav", "static"),
    }

    return {
        fx_played = false,

        setFXPlayed = function (self, has_played)
            self.fx_played = has_played
        end,

        stopFX = function (self, effect)
            if effects[effect]:isPlaying() then
                effects[effect]:stop()
            end
        end,

        playFX = function (self, effect, mode)
            if mode == "single" then
                if not self.fx_played then
                    self:setFXPlayed(true)

                    if not effects[effect]:isPlaying() then
                        effects[effect]:play()
                    end
                end
            elseif mode == "slow" then
                if not effects[effect]:isPlaying() then
                    effects[effect]:play()
                end
            else
                self:stopFX(effect)
                effects[effect]:play()
            end
        end,
    }
end

return SFX