local DEBUG_ACTIONS = {
    {
        script="Debug_SetHeading()",
        name="Set heading for selected units",
        desc="Set the orientation of the selected units from 0-360 degrees."
    },
    {
        script="Debug_SetSpeed()",
        name="Set speed for selected units",
        desc="Set the speed in knots of the selected units."
    },
    { 
        script="Debug_MarkLatLon()", 
        name="Mark coordinate by latitude/longitude", 
        desc="Mark a geographic coordinate with a reference point. Supports various coordinate formats including Decimal Degree, Degree Minutes, and Degrees Minutes Seconds."
    },
    { 
        script="Debug_MarkLatLon(true)", 
        name="Label coordinate by latitude/longitude", 
        desc="Add a custom label to a geographic coordinate with a reference point. Supports various coordinate formats including Decimal Degree, Degree Minutes, and Degrees Minutes Seconds."
    },
    {
        script="Debug_DisableAISelected()",
        name="Disable AI for selected units",
        desc="Sets .AI_EvaluateTargets_enabled and .AI_DeterminePrimaryTarget_enabled to false for all selected units to improve performance."
    },
    {
        script="Debug_SetFuelPercentSelected()",
        name="Set fuel percentage for selected units",
        desc="Sets fuel carried by the selected units to a percentage of the maximum fuel capacity."
    },
    {
        script="Debug_RemoveDebugFramework()",
        name="[REMOVE DEBUG FRAMEWORK]",
        desc="Remove the DEBUG framework. Do this prior to releasing the scenario."
    }
}

function Debug_DisableAISelected()
    local sel_units = GetSelectedUnits()
    ForEachDo(sel_units, function(unit)
        unit.AI_EvaluateTargets_enabled = false
        unit.AI_DeterminePrimaryTarget_enabled = false
    end)
    Input_OK("AI disabled for "..#sel_units.." unit(s).")
end

function Debug_MarkLatLon(will_label)
    will_label = will_label or false
    local msg = "Enter latitude and longitude:\n\n(valid formats include Decimal Degrees, Degrees Minutes, and Degrees Minutes Seconds)"
    local val = RStrip(Input_String(msg))
    if val == "" then return end

    local lat, lon = Geo_ParseLatLon(val)
    if lat ~= nil and lon ~= nil then
        local label = val
        msg = " added at\n("..lat..", "..lon..")"
        if will_label then
            label = RStrip(Input_String("Label the point at\n("..lat..", "..lon.."):"))
            if label == "" then
                label = val
                msg = "New reference point"..msg
            else
                msg = label..msg
            end
        else
            msg = "New reference point"..msg
        end

        local playerside = ScenEdit_GetSideOptions({side="playerside"})
        local sidename = playerside.side
        ScenEdit_AddReferencePoint({side=sidename, name=label, lat=lat, lon=lon, highlighted=true})
        Input_OK(msg)
    else
        Input_OK("Couldn't parse a valid latitude/longitude from\n"..val)
    end
end

function Debug_SetFuelPercentSelected()
    local selected = GetSelectedUnits()
    if #selected == 0 then
        Input_OK("You must select at least 1 unit!")
        return
    end

    local msg = "Which type of fuel to set?\n\nValid types include Aviation, Diesel, Oil, Gas, Battery, AirIndep, Rocket, Torpedo, and Coast."
    local val = Input_String(msg)
    fuel = string.upper(RStrip(val))
    fuel_num = FUELTYPES[fuel]
    if fuel_num == nil then
        Input_OK("Didn't recognize "..val.." as a valid fuel!")
        return
    end
    local percent = Input_Number("Set percentage of maximum fuel capacity (0-100):")
    percent = math.max(0, math.min(percent, 100))
    pct = percent / 100
    ForEachDo(selected, function(unit)
        Unit_SetFuelPercent(unit, fuel_num, pct)
    end)
    Input_OK(fuel.." fuel set to "..percent.."% for "..#selected.." unit(s).")
end

function Debug_SetHeading()
    local selected = GetSelectedUnits()
    if #selected == 0 then
        Input_OK("You must select at least 1 unit!")
        return
    end

    local hdg = Input_Number("Set heading for selected units (0-360):")
    hdg = math.max(0, math.min(360, hdg))
    ForEachDo(selected, function(unit)
        ScenEdit_SetUnit({guid=unit.guid, heading=hdg})
    end)
    Input_OK("Heading set to "..hdg.."° for "..#selected.." unit(s).")
end

function Debug_SetSpeed()
    local selected = GetSelectedUnits()
    if #selected == 0 then
        Input_OK("You must select at least 1 unit!")
        return
    end

    local spd = Input_Number("Set speed in knots for selected units:")
    spd = math.max(0, spd)
    ForEachDo(selected, function(unit)
        ScenEdit_SetUnit({guid=unit.guid, speed=spd})
    end)
    Input_OK("Speed set to "..spd.."kts for "..#selected.." unit(s).")
end

function Debug_RemoveDebugFramework()
    if Input_YesNo("This will remove the DEBUG framework. Are you sure?") then
        RemoveDebugActions()

        if Event_Exists("DEBUG: Scenario Loaded") then
            Event_Delete("DEBUG: Scenario Loaded", true)
        end

        Input_OK("DEBUG framework removed.")
    end
end

function RemoveDebugActions()
    local cur_actions = ScenEdit_GetSpecialAction({
        ActionNameOrID="", 
        Mode="list"
    })
    ForEachDo(cur_actions, function(cur_action)
        if string.find(cur_action.name, "^DEBUG:") then
            ScenEdit_SetSpecialAction({
                ActionNameOrID=cur_action.guid,
                Mode="remove"
            })
        end
    end)
end

function AddDebugActions()
    -- remove conflicting/old debug actions
    RemoveDebugActions()

    -- add debug actions to each side
    ForEachDo(VP_GetSides(), function(side)
        ForEachDo(DEBUG_ACTIONS, function(action)
                ScenEdit_AddSpecialAction({
                    ActionNameOrID="DEBUG: "..action.name,
                    Description=action.desc,
                    Side=side.name,
                    IsActive=true, 
                    IsRepeatable=true,
                    ScriptText=action.script
                })
        end)
    end)
end
