local InspectSnap = {}

InspectSnapDB = InspectSnapDB or { enabled = true }

local f = CreateFrame("Frame")
f:RegisterEvent("INSPECT_READY")
f:SetScript("OnEvent", function(self, event, guid)
    if event == "INSPECT_READY" and InspectSnapDB.enabled then
        InspectSnap.storedGear = {}
        for i = 1, 19 do
            InspectSnap.storedGear[i] = GetInventoryItemLink("target", i)
        end
        if not InspectFrame:IsShown() then
            InspectUnit("target")
        end
    end
end)

-- Hook InspectFrame OnHide to prevent auto-close when stored gear exists
local originalInspectOnHide = InspectFrame:GetScript("OnHide")
InspectFrame:SetScript("OnHide", function(self)
    if InspectSnap.storedGear then
        self:Show()
    else
        if originalInspectOnHide then
            originalInspectOnHide(self)
        end
    end
end)

-- Slot names and mapping to inventory indices
local slotNames = {
    "InspectHeadSlot",
    "InspectNeckSlot",
    "InspectShoulderSlot",
    "InspectShirtSlot",
    "InspectChestSlot",
    "InspectWaistSlot",
    "InspectLegsSlot",
    "InspectFeetSlot",
    "InspectWristSlot",
    "InspectHandsSlot",
    "InspectFinger0Slot",
    "InspectFinger1Slot",
    "InspectTrinket0Slot",
    "InspectTrinket1Slot",
    "InspectBackSlot",
    "InspectMainHandSlot",
    "InspectSecondaryHandSlot",
    "InspectRangedSlot",
    "InspectTabardSlot"
}

local slotMap = {}
for i, name in ipairs(slotNames) do
    slotMap[name] = i
end

-- Hook each slot's OnEnter to show stored tooltip if available
for name, index in pairs(slotMap) do
    local button = getglobal(name)
    if button then
        local originalOnEnter = button:GetScript("OnEnter")
        button:SetScript("OnEnter", function(self)
            if InspectSnap.storedGear and InspectSnap.storedGear[index] then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetHyperlink(InspectSnap.storedGear[index])
                GameTooltip:Show()
            else
                if originalOnEnter then
                    originalOnEnter(self)
                end
            end
        end)
    end
end

-- Slash command for toggle
SLASH_INSPECTSNAP1 = "/inspectsnap"
SlashCmdList["INSPECTSNAP"] = function(msg)
    if msg == "toggle" then
        InspectSnapDB.enabled = not InspectSnapDB.enabled
        DEFAULT_CHAT_FRAME:AddMessage("InspectSnap " .. (InspectSnapDB.enabled and "enabled" or "disabled"))
    end
end