function AbilityLevelUpThink()

	local npcBot = GetBot();

	malefice = "enigma_malefice";
	conversion = "enigma_demonic_conversion";
	midnight = "enigma_midnight_pulse";
	blackhole = "enigma_black_hole";

	abilityLevels = {
		conversion,
		malefice,
		conversion,
		malefice,
		conversion,
		blackhole,
		conversion,
		malefice,
		malefice,
		"special_bonus_movement_speed_20",
		midnight,
		blackhole,
		midnight,
		midnight,
		"special_bonus_cooldown_reduction_15",
		midnight,
		"",
		blackhole,
		"",
		"special_bonus_hp_300",
		"",
		"",
		"",
		"",
		"special_bonus_unique_enigma",
	};


	if npcBot:GetAbilityPoints() > 0 then

		print("enigma has an ability point to spend")
		local level = GetHeroLevel(npcBot:GetPlayerID())
		print("level:", level)
		if abilityLevels[level] ~= "" then
			npcBot:ActionImmediate_LevelAbility(abilityLevels[GetHeroLevel(npcBot:GetPlayerID())])
		end
	end
end
