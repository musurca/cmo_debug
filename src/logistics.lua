FUELTYPE_NONE = 1001
FUELTYPE_AVIATION = 2001
FUELTYPE_DIESEL = 3001
FUELTYPE_OIL = 3002
FUELTYPE_GAS = 3003
FUELTYPE_BATTERY = 4001
FUELTYPE_AIRINDEP = 4002
FUELTYPE_ROCKET = 5001
FUELTYPE_TORPEDO = 5002
FUELTYPE_COAST = 5003

FUELTYPES = {
    ["NONE"]        = FUELTYPE_NONE,
    ["AVIATION"]    = FUELTYPE_AVIATION,
    ["DIESEL"]      = FUELTYPE_DIESEL,
    ["OIL"]         = FUELTYPE_OIL,
    ["GAS"]         = FUELTYPE_GAS,
    ["BATTERY"]     = FUELTYPE_BATTERY,
    ["AIRINDEP"]    = FUELTYPE_AIRINDEP,
    ["ROCKET"]      = FUELTYPE_ROCKET,
    ["TORPEDO"]     = FUELTYPE_TORPEDO,
    ["COAST"]       = FUELTYPE_COAST
}

function Unit_GetFuelPercent(unit, fuel_type)
    local fuel_type_struct = unit.fuel[fuel_type]
    return fuel_type_struct.current / fuel_type_struct.max
end

function Unit_SetFuelPercent(unit, fuel_type, pct)
    local fuel_struct = unit.fuel
    fuel_struct[fuel_type].current = pct*fuel_struct[fuel_type].max
    unit.fuel = fuel_struct
end

function Unit_GetFuelCapacity(unit, fuel_type)
    return unit.fuel[fuel_type].max
end

function Unit_GetFuelAmount(unit, fuel_type)
    return unit.fuel[fuel_type].current
end

function Unit_SetFuelAmount(unit, fuel_type, amt)
    local fuel_struct = unit.fuel
    fuel_struct[fuel_type].current = amt
    unit.fuel = fuel_struct
end

function Unit_OrderUNREP(unit, tanker)
    tanker = tanker or nil
    local args={guid=unit.guid}
    if tanker ~= nil then
        args.tanker = tanker.guid
    end
    ScenEdit_RefuelUnit(args)
end

function Unit_SetComms(unit, commsState)
    ScenEdit_SetUnit({guid=unit.guid, OUTOFCOMMS=commsState})
end

function Unit_InComms(unit)
    return unit.outOfComms
end

