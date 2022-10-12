local love = require "love"

global record EffectsType
    enum AvailableEffects
        "button_hover"
        "card_draw"
        "card_shuffle"
    end

    button_hover: love.audio.Source
    card_draw: love.audio.Source
    card_shuffle: love.audio.Source
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

return SFXType