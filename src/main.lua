function Debug_Init()
    -- clear out the old debug framework if exists
    if Event_Exists("DEBUG: Scenario Loaded") then
        Event_Delete("DEBUG: Scenario Loaded", true)
    end

    -- initialize on load by injecting its own code into the VM
    local load_evt = Event_Create("DEBUG: Scenario Loaded", {
        IsRepeatable=true, 
        IsShown=false
    })

    local load_trig = Trigger_Create("DEBUG_Scenario_Loaded", {
        type="ScenLoaded"
    })

    local load_act = Action_Create("DEBUG: Turn Starts", {
        type='LuaScript', 
        ScriptText=DEBUG_LOADER
    })

    Event_AddTrigger(load_evt, load_trig)
    Event_AddAction(load_evt, load_act)

    AddDebugActions()

    Input_OK("Success! The DEBUG framework has been added!\n\n(NOTE: If you add any more sides, you should save and reload the scenario to update the special actions menu.)")
end

