local RESET, SIMULTAN = 4, 0.5
local current, timer, db, simultaneous
local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("MineJumper", {
	type = "data source",
	text = "0 mines",
	value = "0",
	icon = "Interface\\Icons\\INV_Shield_08",
	suffix = "mines",
})

local frame = CreateFrame"Frame"
frame:SetScript("OnEvent", function(self, event, _, _, _, _, _, destGUID, _, _, id)
	if(event == "VARIABLES_LOADED") then
		MineJumper = MineJumper or {total = 0, maximum = 0, simultaneous = 0}
		db = MineJumper
	end
	if(id ~= 54355 or destGUID ~= UnitGUID("player") or not db) then return end
	current = (current or 0)+1
	simultaneous = (simultaneous or 0)+1
	db.total = db.total + 1
	db.maximum = max(db.maximum, current)
	db.simultaneous = max(db.simultaneous, simultaneous)
	timer = 0
	dataobj.value = current
	dataobj.text = dataobj.value.." "..dataobj.suffix
	self:Show()
end)
frame:SetScript("OnUpdate", function(self, elapsed)
	timer = timer + elapsed
	if(timer > RESET) then
		self:Hide()
		current = 0
		dataobj.value = current
		dataobj.text = dataobj.value.." "..dataobj.suffix
	end
	if(timer > SIMULTAN) then
		simultaneous = 0
	end
end)
frame:Hide()
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:RegisterEvent("VARIABLES_LOADED")

function dataobj.OnTooltipShow(tooltip)
	tooltip:AddLine("MineJumper")
	tooltip:AddDoubleLine("Current:", current or "0")
	tooltip:AddDoubleLine("Maximum:", db.maximum)
	tooltip:AddDoubleLine("Total:", db.total)
	tooltip:AddDoubleLine("Simultaneous:", db.simultaneous)
end