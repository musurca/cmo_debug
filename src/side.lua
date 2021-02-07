function Side_GetSide(sidename)
    local sides = VP_GetSides()
    for i=1,#sides do
        local side = sides[i]
        if side.name == sidename then
            return side
        end
    end
    return nil
end

function Side_GetNoNavZones(side)
    local zones = {}
    if side == nil then
        return zones
    end

    local zone_headers = side.nonavzones
    ForEachDo(zone_headers, function(zh)
        local zone = side:getnonavzone(zh.guid)
        table.insert(zones, zone)
    end)
    return zones
end

