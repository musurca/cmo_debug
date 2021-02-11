--iterates through table, calling func(e) on each e in table
function ForEachDo(table, func)
    for i=1,#table do
        func(table[i])
    end
end

function ForEachDo_Break(table, func)
    for i=1,#table do
        if not func(table[i]) then
            return
        end
    end
end

function IsIn(value, t)
    for _, v in pairs(t) do
        if value == v then
            return true
        end
    end
    return false
end

-- Strip leading and trailing whitespace
function RStrip(str)
    str = string.gsub(str, "^%s*", "")
    return string.gsub(str, "%s*$", "")
end

function Input_OK(question)
    ScenEdit_MsgBox(question, 0)
end

function Input_YesNo(question)
    local answer_table = {['Yes']=true, ['No']=false}
    while true do
        local ans = ScenEdit_MsgBox(question, 4)
        if ans ~= 'Cancel' then
            return answer_table[ans]
        end
    end
    return false
end

function Input_Number(question)
    while true do
        local val = ScenEdit_InputBox(question)
        if val then
            val = tonumber(val)
            if val then
                return val
            end
        else
            return nil
        end
    end
end

function Input_String(question)
    local val = ScenEdit_InputBox(question)
    if val then
        return tostring(val)
    end
    return ""
end

function Util_DumpFields(obj)
    for k,v in pairs(obj.fields) do
        if string.find(k,'property_') ~= nil then
            local t = string.find(v," , ") -- location of first ,
            print("\r\n[object] = " .. string.sub(v,2,t-1) ) -- property name
            print( obj[string.sub(v,2,t-1)] ) -- value of property
        end
    end
end

