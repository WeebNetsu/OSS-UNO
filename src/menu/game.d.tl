global record GameType
    load: function (GameType)
    update: function (GameType, dt: number, clickedMouse: boolean)
    draw: function (GameType)
end

global GameFunc: function(): GameType

return GameFunc