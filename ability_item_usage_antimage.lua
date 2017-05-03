function AbilityLevelUpThink()

	local npcBot = GetBot();

	manabreak = "antimage_mana_break";
	blink = "antimage_blink";
	spellshield = "antimage_spell_shield";
	manavoid = "antimage_mana_void";

	abilityLevels = {
		manabreak,
		blink,
		manabreak,
		spellshield,
		manabreak,
		manavoid,
		manabreak,
		blink,
		blink,
		"special_bonus_agility_25",
		blink,
		manavoid,
		spellshield,
		spellshield,
		"special_bonus_attack_speed_20",
		spellshield,
		"",
		manavoid,
		"",
		"special_bonus_all_stats_10",
		"",
		"",
		"",
		"",
		"special_bonus_attack_damage_20",
	};

	if npcBot:GetAbilityPoints() > 0 then

		print("antimage has an ability point to spend")
		local level = GetHeroLevel(npcBot:GetPlayerID())
		print("level:", level)
		if abilityLevels[level] ~= "" then
			npcBot:ActionImmediate_LevelAbility(abilityLevels[GetHeroLevel(npcBot:GetPlayerID())])
		end
	end



	--int GetAbilityPoints() Get the number of ability points available to this bot.
	--GetBot() Returns a handle to the bot on which the script is currently being run
	--int GetPlayerID() Gets the Player ID of the unit, used in functions that refer to a player rather than a specific unit.
	--ActionImmediate_LevelAbility ( sAbilityName ) Command a bot to level an ability or a talent.
	--GetHeroLevel( nPlayerID ) Returns the specified PlayerID's hero's level.


end
