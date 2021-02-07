function GetReferencePoints(sidename, rps)
    return ScenEdit_GetReferencePoints({side=sidename, area=rps})
end

function DeleteReferencePoints(sidename, rp_table)
    for i=1,#rp_table do
        ScenEdit_DeleteReferencePoint({side=sidename, guid=rp_table[i].guid})
    end
end

function GetSelectedUnits()
    local utable = {}
    local units = ScenEdit_SelectedUnits().units
    for i=1,#units do
        local unit = ScenEdit_GetUnit({guid=units[i].guid})
        table.insert(utable, unit)
    end
    return utable
end

--[[
Print a Lua table to the console containing the GUIDs
of the selected units
]]--
function PrintSelectedGUIDS()
    local guids = {}
    local units = GetSelectedUnits()
    ForEachDo(units, function(unit)
        table.insert(guids, unit.guid)
    end)

    print("--[[ group containing:")
    ForEachDo(units, function(unit)
        print("\t"..unit.name)
    end)
    print("]]--")
    local tab = "local grp = {\r\n"
    for k, v in ipairs(guids) do
        tab = tab.."\t\""..v.."\""
        if k < #guids then
            tab = tab..",\r\n"
        end
    end
    tab = tab.."\r\n}"
    print(tab)
end

function Event_Exists(evt_name)
    local events = ScenEdit_GetEvents()
    for i=1,#events do
        local event = events[i]
        if event.details.description == evt_name then
            return true
        end
    end

    return false
end

function Event_Delete(evt_name, recurse)
    recurse = recurse or false
    if recurse then
        -- delete nested actions, conditions, and triggers
        ForEachDo_Break(ScenEdit_GetEvents(), function(event)
            if event.details.description == evt_name then
                ForEachDo(event.details.triggers, function(e)
                    for key, val in pairs(e) do
                        if val.Description ~= nil then
                            Event_RemoveTrigger(evt_name, val.Description)
                            Trigger_Delete(val.Description)
                        end
                    end
                end)
                ForEachDo(event.details.conditions, function(e)
                    for key, val in pairs(e) do
                        if val.Description ~= nil then
                            Event_RemoveCondition(evt_name, val.Description)
                            Condition_Delete(val.Description)
                        end
                    end
                end)
                ForEachDo(event.details.actions, function(e)
                    for key, val in pairs(e) do
                        if val.Description ~= nil then
                            Event_RemoveAction(evt_name, val.Description)
                            Action_Delete(val.Description)
                        end
                    end
                end)

                return false
            end
            return true
        end)
    end

    -- remove the event
    ScenEdit_SetEvent(evt_name, {mode="remove"})
end

function Event_Create(evt_name, args)
    -- clear any existing events with that name
    ForEachDo(ScenEdit_GetEvents(), function(event)
        if event.details.description == evt_name then
            ScenEdit_SetEvent(evt_name, {mode="remove"})
        end
    end)

    -- add our event
    args.mode="add"
    ScenEdit_SetEvent(evt_name, args)
    return evt_name
end

function Event_AddTrigger(evt, trig)
    ScenEdit_SetEventTrigger(evt, {mode='add', name=trig})
end

function Event_RemoveTrigger(evt, trig)
    ScenEdit_SetEventTrigger(evt, {mode='remove', name=trig})
end

function Event_AddCondition(evt, cond)
    ScenEdit_SetEventCondition(evt, {mode='add', name=cond})
end

function Event_RemoveCondition(evt, cond)
    ScenEdit_SetEventCondition(evt, {mode='remove', name=cond})
end

function Event_AddAction(evt, action)
    ScenEdit_SetEventAction(evt, {mode='add', name=action})
end

function Event_RemoveAction(evt, action)
    ScenEdit_SetEventAction(evt, {mode='remove', name=action})
end

function Trigger_Create(trig_name, args)
    args.name=trig_name
    args.mode="add"
    ScenEdit_SetTrigger(args)
    return trig_name
end

function Trigger_Delete(trig_name)
    ScenEdit_SetTrigger({name=trig_name, mode="remove"})
end

function Condition_Create(cond_name, args)
    args.name=cond_name
    args.mode="add"
    ScenEdit_SetCondition(args)
    return cond_name
end

function Condition_Delete(cond_name)
    ScenEdit_SetCondition({name=cond_name, mode="remove"})
end

function Action_Create(action_name, args)
    args.name=action_name
    args.mode="add"
    ScenEdit_SetAction(args)
    return action_name
end

function Action_Delete(action_name)
    ScenEdit_SetAction({name=action_name, mode="remove"})
end

