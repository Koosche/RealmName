-- Create the options panel
local panel = CreateFrame("Frame", "UnifiedNameOptionsPanel", InterfaceOptionsFrame)
panel.name = "Unified Name"
InterfaceOptions_AddCategory(panel)

-- Addon Title
local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("Unified Name Options")

-- Input box for the custom name
local nameLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
nameLabel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -20)
nameLabel:SetText("Custom Name:")

local nameInput = CreateFrame("EditBox", "UnifiedNameNameInput", panel, "InputBoxTemplate")
nameInput:SetPoint("LEFT", nameLabel, "RIGHT", 10, 0)
nameInput:SetSize(150, 20)
nameInput:SetAutoFocus(false)

nameInput:SetScript("OnShow", function(self)
    self:SetText(UnifiedNameDB.customName or "")
end)
nameInput:SetScript("OnTextChanged", function(self)
    UnifiedNameDB.customName = self:GetText()
end)
nameInput:SetScript("OnEnterPressed", function(self)
    self:ClearFocus()
end)

-- Checkbox for the "hide if same" feature
local hideCheckbox = CreateFrame("CheckButton", "UnifiedNameHideCheckbox", panel, "UICheckButtonTemplate")
hideCheckbox:SetPoint("TOPLEFT", nameLabel, "BOTTOMLEFT", 0, -20)
hideCheckbox.text = hideCheckbox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
hideCheckbox.text:SetPoint("LEFT", hideCheckbox, "RIGHT", 5, 0)
hideCheckbox.text:SetText("Hide name if same as character name.")

hideCheckbox:SetScript("OnShow", function(self)
    self:SetChecked(UnifiedNameDB.hideIfSame)
end)
hideCheckbox:SetScript("OnClick", function(self)
    UnifiedNameDB.hideIfSame = self:GetChecked()
end)

-------------------------------------------------------------
-- NEW SECTION: Channel Selection
-------------------------------------------------------------

-- Section Header
local channelsLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
channelsLabel:SetPoint("TOPLEFT", hideCheckbox, "BOTTOMLEFT", -18, -25) -- Positioned below the previous checkbox
channelsLabel:SetText("Enabled Channels:")

-- Function to create a channel checkbox to reduce code duplication
local function CreateChannelCheckbox(parent, channelName, anchor)
    local checkbox = CreateFrame("CheckButton", "UnifiedName" .. channelName .. "Checkbox", parent, "UICheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -10)
    checkbox.text = checkbox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    checkbox.text:SetPoint("LEFT", checkbox, "RIGHT", 5, 0)
    checkbox.text:SetText(channelName:sub(1,1):upper() .. channelName:sub(2):lower()) -- Capitalizes the name (e.g., SAY -> Say)

    checkbox:SetScript("OnShow", function(self)
        self:SetChecked(UnifiedNameDB.channels[channelName])
    end)
    checkbox:SetScript("OnClick", function(self)
        UnifiedNameDB.channels[channelName] = self:GetChecked()
    end)
    return checkbox
end

-- Create the checkboxes, anchoring each one to the one above it
local sayCheckbox = CreateChannelCheckbox(panel, "SAY", channelsLabel)
local yellCheckbox = CreateChannelCheckbox(panel, "YELL", sayCheckbox)
local partyCheckbox = CreateChannelCheckbox(panel, "PARTY", yellCheckbox)
local raidCheckbox = CreateChannelCheckbox(panel, "RAID", partyCheckbox)
local guildCheckbox = CreateChannelCheckbox(panel, "GUILD", raidCheckbox)