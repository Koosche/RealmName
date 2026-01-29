-- Hook the original SendChatMessage function to intercept messages
local originalSendChatMessage = SendChatMessage

-- This is our new function that will run instead
function SendChatMessage(msg, chatType, language, channel)
    -- Check if the current chatType is enabled in our settings
    local shouldModify = UnifiedNameDB and UnifiedNameDB.channels and UnifiedNameDB.channels[chatType]

    -- Make sure our settings have been loaded and there's a custom name to use
    if shouldModify and UnifiedNameDB.customName and UnifiedNameDB.customName ~= "" then
        local playerName = UnitName("player")
        local customName = UnifiedNameDB.customName

        -- Check the setting to see if we should hide the name when it's identical
        local hideBecauseSame = UnifiedNameDB.hideIfSame and (playerName:lower() == customName:lower())

        if not hideBecauseSame then
            -- If we are not hiding it, build the new message
            local prefix = "(" .. customName .. "): "
            local newMsg = prefix .. msg
            originalSendChatMessage(newMsg, chatType, language, channel)
        else
            originalSendChatMessage(msg, chatType, language, channel)
        end
    else
        -- If it's not a message we should modify, just call the original function
        originalSendChatMessage(msg, chatType, language, channel)
    end
end

-- Create a frame to listen for the PLAYER_LOGIN event
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    -- When the player logs in, initialize the saved settings if they don't exist
    UnifiedNameDB = UnifiedNameDB or {}
    UnifiedNameDB.customName = UnifiedNameDB.customName or ""
    if UnifiedNameDB.hideIfSame == nil then
      UnifiedNameDB.hideIfSame = true
    end

    -- Initialize the channels table if it doesn't exist
    UnifiedNameDB.channels = UnifiedNameDB.channels or {}
    -- Set default values for channels if they haven't been set before
    if UnifiedNameDB.channels["SAY"] == nil then UnifiedNameDB.channels["SAY"] = false end
    if UnifiedNameDB.channels["YELL"] == nil then UnifiedNameDB.channels["YELL"] = false end
    if UnifiedNameDB.channels["PARTY"] == nil then UnifiedNameDB.channels["PARTY"] = false end
    if UnifiedNameDB.channels["RAID"] == nil then UnifiedNameDB.channels["RAID"] = false end
    if UnifiedNameDB.channels["GUILD"] == nil then UnifiedNameDB.channels["GUILD"] = true end
end)