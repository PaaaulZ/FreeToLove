RegisterKeyBind(Key.F12, function()
    ExecuteInGameThread(function()
        FixRomancePreferences()
    end)
end)

function FixRomancePreferences()

    local EB1GenderIdentityEnum = {"Invalid", "Male", "Female", "NonBinary"}
     
    local B2BioComponentClass = FindObject(nil, "B2BioComponent", nil, EObjectFlags.RF_ClassDefaultObject | EObjectFlags.RF_ArchetypeObject)
    if not B2BioComponentClass:IsValid() then
        print("[FreeToLove] ERROR: Unrecognized class or object B2BioComponent")
    end

    local zois = FindAllOf("B2BioComponent")
    for _, zoi in pairs(zois) do
        local TextToImport = nil
        if zoi.GenderIdentitySetting.bRomanticOrientation then
            TextToImport = "(GenderIdentity=" .. EB1GenderIdentityEnum[zoi.GenderIdentitySetting.GenderIdentity+1] .. ",bRomanticOrientation=True,RomanceTargetList=(Male,Female,NonBinary))"
        else
            TextToImport = "(GenderIdentity=" .. EB1GenderIdentityEnum[zoi.GenderIdentitySetting.GenderIdentity+1] .. ",bRomanticOrientation=False,RomanceTargetList=(Male,Female,NonBinary))"
        end
        _SetPropertyValue(zoi, B2BioComponentClass, TextToImport)
    end

    if #zois == 0 then
        print("[FreeToLove] ERROR: No objects found with class B2BioComponent")
    end
end

function _SetPropertyValue(zoi, B2BioComponentClass, NewValue)
    local GenderIdentitySettingProp = B2BioComponentClass:Reflection():GetProperty("GenderIdentitySetting")
    if GenderIdentitySettingProp:IsValid() then
        GenderIdentitySettingProp:ImportText(NewValue, GenderIdentitySettingProp:ContainerPtrToValuePtr(zoi), 0, zoi)
    else
        print("[FreeToLove] ERROR: Unrecognized property GenderIdentitySetting on class B2BioComponent")
    end
end

print("[FreeToLove] Loaded!")