function Geo_ParseLatLon(str)
    local LAT_DIR_REGEX = "[N|S]"
    local LON_DIR_REGEX = "[E|W]"
    local DIR_SIGNS = {
        ["N"] = 1,
        ["S"] = -1,
        ["E"] = 1,
        ["W"] = -1
    }

    -- Convert any directional letters to correct format
    str = string.upper(str)

    -- Pull out numbers in order
    local NUMBER_REGEX = "([+-]?%d+[.]?%d*)"
    local values = {}
    string.gsub(str, NUMBER_REGEX, function (n)
        table.insert(values, tonumber(n))
    end)

    -- Find directional indication if any
    local lat_sign, lon_sign = 1, 1
    string.gsub(str, LAT_DIR_REGEX, function (dir)
        lat_sign = DIR_SIGNS[dir]
    end)
    string.gsub(str, LON_DIR_REGEX, function (dir)
        lon_sign = DIR_SIGNS[dir]
    end)

    if #values == 2 then
        latitude, longitude = values[1], values[2]
    elseif #values == 4 then
        latitude = math.floor(values[1]) + values[2] / 60
        longitude = math.floor(values[3]) + values[4] / 60
    elseif #values == 6 then
        latitude = math.floor(values[1]) + math.floor(values[2]) / 60 + values[3] / 3600
        longitude = math.floor(values[4]) + math.floor(values[5]) / 60 + values[6] / 3600
    else
        return nil, nil
    end
    
    return latitude*lat_sign, longitude*lon_sign
end

