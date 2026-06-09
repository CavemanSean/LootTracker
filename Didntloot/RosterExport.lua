-------------- Raid Roster Export --------------
-- Exports all raid member names to a text file
-- one name per line, ready to paste into
-- Leviathan Loot Tracker roster box.
-- Based on buff-check addon by Strawberry
-- File output pattern from GuildPrestige addon
------------------------------------------------

if API_TYPE == nil then
	ADDON:ImportAPI(8)
	X2Chat:DispatchChatMessage(
		CMF_SYSTEM,
		"Globals folder not found. Please install it at https://github.com/Schiz-n/ArcheRage-addons/tree/master/globals"
	)
	return
end

ADDON:ImportObject(OBJECT_TYPE.TEXT_STYLE)
ADDON:ImportObject(OBJECT_TYPE.BUTTON)
ADDON:ImportObject(OBJECT_TYPE.DRAWABLE)
ADDON:ImportObject(OBJECT_TYPE.NINE_PART_DRAWABLE)
ADDON:ImportObject(OBJECT_TYPE.COLOR_DRAWABLE)
ADDON:ImportObject(OBJECT_TYPE.WINDOW)
ADDON:ImportObject(OBJECT_TYPE.LABEL)
ADDON:ImportObject(OBJECT_TYPE.ICON_DRAWABLE)
ADDON:ImportObject(OBJECT_TYPE.IMAGE_DRAWABLE)

ADDON:ImportAPI(API_TYPE.CHAT.id)
ADDON:ImportAPI(API_TYPE.UNIT.id)
ADDON:ImportAPI(API_TYPE.LOCALE.id)

local filepath = "C:/ArcheRage/Documents/Addon/" .. ADDON:GetName() .. "/roster.txt"

function exportRoster()
	local names = {}

	local hasCoRaid = false
	local amountOfRaids = 1

	if X2Unit:UnitName("team_1_1") == nil and X2Unit:UnitName("team1") == nil then
		X2Chat:DispatchChatMessage(CMF_SYSTEM, "[RosterExport] Not in a raid.")
		return
	end

	if X2Unit:UnitName("team_1_1") ~= nil then
		amountOfRaids = 2
		hasCoRaid = true
	end

	for team = 1, amountOfRaids do
		for member = 1, 50 do
			local teamId = ""
			if hasCoRaid then
				teamId = string.format("team_%d_%d", team, member)
			else
				teamId = string.format("team%d", member)
			end

			local playerName = X2Unit:UnitName(teamId)
			if playerName then
				table.insert(names, playerName)
			end
		end
	end

	if #names == 0 then
		X2Chat:DispatchChatMessage(CMF_SYSTEM, "[RosterExport] No members found.")
		return
	end

	local file = assert(io.open(filepath, "w"))
	for _, name in ipairs(names) do
		file:write(name, "\n")
	end
	file:close()

	X2Chat:DispatchChatMessage(
		CMF_SYSTEM,
		string.format("[RosterExport] %d names saved to: %s", #names, filepath)
	)
end

local exportButton = CreateSimpleButton("Export Roster", 700, -270)

function exportButton:OnClick()
	exportRoster()
end
exportButton:SetHandler("OnClick", exportButton.OnClick)
