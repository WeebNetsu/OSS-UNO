require "src.utils.sfx"
require "src.utils.message"

global record GameType
    load: function (GameType)
    update: function (GameType, dt: number, clickedMouse: boolean)
    draw: function (GameType)
end

global GameFunc: function(sfx: SFXType, message: MessageType): GameType

return GameFunc