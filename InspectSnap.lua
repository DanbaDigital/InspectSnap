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

function InspectSnap:ShowInspectFrame(gear)
    if not self.inspectFrame then
        self.inspectFrame = CreateFrame("Frame", "InspectSnapFrame", UIParent)
        self.inspectFrame:SetSize(400, 300)
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

        self.gearButtons = {}
        local slotNames = {
            [1] = "Head", [2] = "Neck", [3] = "Shoulder", [4] = "Shirt", [5] = "Chest", [6] = "Waist", [7] = "Legs", [8] = "Feet", [9] = "Wrist", [10] = "Hands", [11] = "Finger0", [12] = "Finger1", [13] = "Trinket0", [14] = "Trinket1", [15] = "Back", [16] = "MainHand", [17] = "SecondaryHand", [18] = "Ranged", [19] = "Tabard"
        }
        for i = 1, 19 do
            local button = CreateFrame("Button", nil, self.inspectFrame)
            button:SetSize(32, 32)
            button:SetPoint("TOPLEFT", 20 + ((i-1) % 5) * 70, -40 - math.floor((i-1) / 5) * 40)
            button:SetNormalTexture("Interface\\PaperDoll\\UI-PaperDoll-Slot-Generic")
            button:SetScript("OnEnter", function()
                if gear[i] and gear[i] ~= "Empty" then
                    GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
                    GameTooltip:SetHyperlink(gear[i])
                    GameTooltip:Show()
                end
            end)
            button:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)
            button:SetScript("OnClick", function()
                if gear[i] and gear[i] ~= "Empty" then
                    if IsShiftKeyDown() then
                        ChatEdit_InsertLink(gear[i])
                    end
                end
            end)
            local text = self.inspectFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            text:SetPoint("BOTTOM", button, "TOP", 0, 2)
            text:SetText(slotNames[i])
            self.gearButtons[i] = button
        end
    end

    for i = 1, 19 do
        local button = self.gearButtons[i]
        local link = gear[i]
        if link and link ~= "Empty" then
            local _, _, _, _, _, _, _, _, _, texture = GetItemInfo(link)
            if texture then
                button:SetNormalTexture(texture)
            else
                button:SetNormalTexture("Interface\\PaperDoll\\UI-PaperDoll-Slot-Generic")
            end
        else
            button:SetNormalTexture("Interface\\PaperDoll\\UI-PaperDoll-Slot-Generic")
        end
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