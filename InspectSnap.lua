local InspectSnap = {}

InspectSnapDB = InspectSnapDB or {enabled = true}

local f = CreateFrame("Frame")
f:RegisterEvent("INSPECT_READY")
f:SetScript("OnEvent", function(self, event, guid)
    if event == "INSPECT_READY" and InspectSnapDB.enabled then
        local gear = {}
        for i = 1, 19 do
            gear[i] = GetInventoryItemLink("target", i) or "Empty"
        end
        InspectSnap:ShowInspectFrame(gear)
    end
end)

-- Hook the default InspectFrame to attempt preventing auto-close
if InspectFrame then
    InspectFrame:HookScript("OnHide", function()
        if InspectSnapDB.enabled and UnitExists("target") and CheckInteractDistance("target", 1) then
            InspectFrame:Show()
        end
    end)
end

function InspectSnap:ShowInspectFrame(gear)
    if not self.inspectFrame then
        self.inspectFrame = CreateFrame("Frame", "InspectSnapFrame", UIParent)
        self.inspectFrame:SetSize(300, 400)
        self.inspectFrame:SetPoint("CENTER")
        self.inspectFrame:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true, tileSize = 32, edgeSize = 32,
            insets = {left = 11, right = 12, top = 12, bottom = 11}
        })
        self.inspectFrame:SetMovable(true)
        self.inspectFrame:EnableMouse(true)
        self.inspectFrame:RegisterForDrag("LeftButton")
        self.inspectFrame:SetScript("OnDragStart", self.inspectFrame.StartMoving)
        self.inspectFrame:SetScript("OnDragStop", self.inspectFrame.StopMovingOrSizing)

        local closeButton = CreateFrame("Button", nil, self.inspectFrame, "UIPanelCloseButton")
        closeButton:SetPoint("TOPRIGHT", -5, -5)

        local title = self.inspectFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        title:SetPoint("TOP", 0, -10)
        title:SetText("InspectSnap")

        self.gearTexts = {}
        for i = 1, 19 do
            local text = self.inspectFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            text:SetPoint("TOPLEFT", 10, -30 - (i-1)*15)
            text:SetText("Slot " .. i .. ": ")
            self.gearTexts[i] = text
        end
    end

    for i = 1, 19 do
        self.gearTexts[i]:SetText("Slot " .. i .. ": " .. gear[i])
    end

    self.inspectFrame:Show()
end

SLASH_INSPECTSNAP1 = "/inspectsnap"
SlashCmdList["INSPECTSNAP"] = function(msg)
    if msg == "toggle" then
        InspectSnapDB.enabled = not InspectSnapDB.enabled
        DEFAULT_CHAT_FRAME:AddMessage("InspectSnap " .. (InspectSnapDB.enabled and "enabled" or "disabled"))
    end
end