local love = require "love"
require "src.utils.sfx"

local function SFX(): SFXType
    local effects: EffectsType = {
        button_hover = love.audio.newSource("assets/ui-sounds/button_hover.wav", "static"),
        card_draw = love.audio.newSource("assets/ui-sounds/card_draw.mp3", "static"),
        card_shuffle = love.audio.newSource("assets/ui-sounds/card_shuffle.wav", "static"),
        card_play = love.audio.newSource("assets/ui-sounds/card_play.wav", "static"),
        said_uno_male = love.audio.newSource("assets/ui-sounds/said_uno_male.wav", "static"),
        said_uno_female = love.audio.newSource("assets/ui-sounds/said_uno_female.wav", "static"),
    }

    return {
        fx_played = false,

        setFXPlayed = function (self: SFXType, has_played: boolean)
            self.fx_played = has_played
        end,

        stopFX = function (_self: SFXType, effect: EffectsType.AvailableEffects)
            if effects[effect]:isPlaying() then
                effects[effect]:stop()
            end
        end,

        playFX = function (self: SFXType, effect: EffectsType.AvailableEffects, mode: SFXType.AvailableModes)
            -- single - does not play the sound again if it's already busy playing
            -- will also only play it if it has not been played yet (fx_played)
            if mode == "single" then
                if not self.fx_played then
                    self:setFXPlayed(true)

                    if not effects[effect]:isPlaying() then
                        effects[effect]:play()
                    end
                end
            -- slow - same as single, but will still play it if it has already been played
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