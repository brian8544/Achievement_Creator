function BrianAchievementCreator_Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
end

function BrianAchievementCreator_Error(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
end

function BrianAchievementCreator_GetLink(name, id, guid, day, month, year)
	id = tonumber(id, 10)
	day = tonumber(day, 10)
	month = tonumber(month, 10)
	year = tonumber(year, 10) % 100

	return "|cffffff00|Hachievement:"..id..":"..guid..":1:"..month..":"..day..":"..year..":4294967295:4294967295:4294967295:4294967295|h["..name.."]|h|r"
end

function BrianAchievementCreator_ExtractAchievement(link)
	local id, name
	local regexp = "|cffffff00|Hachievement:([0-9]+):(.+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+)|h%[([^]]+)%]|h|r"
	for id, _, _, _, _, _, _, _, _, _, name in string.gmatch(link, regexp) do
		return id, name
	end

	id = tonumber(link, 10)
	_, name = GetAchievementInfo(id)
	if name ~= nil then
		return id, name
	end

	return nil, nil
end

function BrianAchievementCreator_Help()
	BrianAchievementCreator_Print("How To:")
	BrianAchievementCreator_Print(" ")
	BrianAchievementCreator_Print("/Achievement_Create ID DATE")
	BrianAchievementCreator_Print("|cffff0000Example: /Achievement_Create 14690 10/05/2021|r")
	BrianAchievementCreator_Print(" ")
	BrianAchievementCreator_Print("Created by: |cff00ccff@brian8544|r, |cff00ccff(www.github.com/brian8544)|r")
end

SlashCmdList["BrianAchievementCreator"] = function(s)
	local success = pcall(function()
		local targetGuid = UnitGUID('target')
		local targetName = UnitName('target')

		if targetGuid == nil or targetGuid == "" then
			targetGuid = UnitGUID('player')
			targetName = UnitName('player')
		elseif not(UnitIsPlayer("target")) then
			BrianAchievementCreator_Error("The targeted unit |cFFFFFFFF" .. targetName .. "|r is not a player.")
			return
		end

		targetGuid = string.gsub(targetGuid, '0x', '')

		local day, month, year, link
		local a, b, c, d, e

		for a, b, c, d in string.gmatch(s, "(.+)%s+([0-9]+)/([0-9]+)/([0-9]+)") do
			link = a
			day   = b
			month = c
			year  = d
		end

		if not(link) or not(day) or not(month) or not(year) then
			BrianAchievementCreator_Help()
			return
		end

		local id, name = BrianAchievementCreator_ExtractAchievement(link)

		if not(id) then
			BrianAchievementCreator_Error("Invalid achievement ID or link.")
			return
		end

		local playerLink = "|cFFFFFFFF|Hplayer:" .. targetName .. "|h" .. targetName .. "|h|r"
		local achievementLink = BrianAchievementCreator_GetLink(name, id, targetGuid, day, month, year)
		BrianAchievementCreator_Print("Achievement for " .. playerLink .. ": " .. achievementLink)
	end)

	if not(success) then
		BrianAchievementCreator_Help()
	end
end

SLASH_BrianAchievementCreator1 = "/achievement_create"
SLASH_BrianAchievementCreator2 = "/achiev_create"
SLASH_BrianAchievementCreator3 = "/ach_create"