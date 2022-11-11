local love = require "love"

global record EffectsType
    enum AvailableEffects
        "button_hover"
        "card_draw"
        "card_shuffle"
        "card_play"
        "said_uno_male"
        "said_uno_female"
    end

    button_hover: love.audio.Source
    card_draw: love.audio.Source
    card_shuffle: love.audio.Source
    card_play: love.audio.Source
    said_uno_male: love.audio.Source
    said_uno_female: love.audio.Source
end

global record SFXType
    enum AvailableModes 
        "single"
        "slow"
        "other"
    end
    
    fx_played: boolean
    setFXPlayed: function (SFXType, boolean)
    stopFX: function (SFXType, EffectsType.AvailableEffects)
    playFX: function (SFXType, EffectsType.AvailableEffects, AvailableModes)
end

global SfxFunc: function(): SFXType

return SfxFunc