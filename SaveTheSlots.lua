-- Globals (saved)
STS_ENABLED = true

-- Globals
SLASH_STS1 = "/sts"
SLASH_STS2 = "/savetheslots"
STS_LOADED = false

-- Spells to react to
STS_BAD_SPELLS = {
	"Rend",
	"Mortal Strike",
	"Garrote",
	"Rupture",
	"Hemorrhage",
	"Devouring Plague",
	"Vampiric Embrace",
	"Serpent Sting"
}

-- Messages to use
STS_MESSAGES = {
	"%s just used %s, why are you being a pleb?",
	"%s has used %s during raid, do you know this is classic WoW?",
	"Thoughtless %s has just used %s, why don't you care for the slots?!",
	"OMG, %s has used %s, what are you doing...",
	"%s just used %s, look at that noob.",
	"%s used %s and likely removed a useful debuff, what do we do?!",
	"Oh no, %s casted %s, a useful debuff cries somewhere in the corner..."
}

-- Frame to register events
local frame = CreateFrame("Frame")

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

function frame:OnEvent(event, ...)
	if (event == "ADDON_LOADED") then
		local addOnName = ...
		
		if (addOnName == "SaveTheSlots") then
			STS_LOADED = true

			print("SaveTheSlots has been loaded (enabled: " .. tostring(STS_ENABLED) .. ")")
		end
	end

	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		if (STS_ENABLED) then
			local eventInfo = { CombatLogGetCurrentEventInfo() }
			local _, subevent, _, _, sourceName = unpack(eventInfo)

			if (IsInRaid() and UnitInRaid(sourceName) ~= nil) then
				if (subevent == "SPELL_AURA_APPLIED") then
					local spellName = select(13, unpack(eventInfo))
					local badSpellFound = false

					for i, v in ipairs(STS_BAD_SPELLS) do
						if (v == spellName) then
							badSpellFound = true

							break
						end
					end

					if (badSpellFound) then
						SendChatMessage("#SaveTheSlots: " .. string.format(STS_MESSAGES[math.random(table.getn(STS_MESSAGES)) - 1], sourceName, spellName), "RAID")
					end
				end
			end
		end
	end
end

frame:SetScript("OnEvent", frame.OnEvent)

function SlashCmdList.STS(msg)
	if (STS_LOADED) then
		if (msg == "enable") then
			STS_ENABLED = true

			print("SaveTheSlots is now enabled.")
		end

		if (msg == "disable") then
			STS_ENABLED = false

			print("SaveTheSlots is now disabled.")
		end

		if (msg == "") then
			print("SaveTheSlots usage: enable|disable")
		end
	end
end
