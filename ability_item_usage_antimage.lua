
function AbilityLevelUpThink() 

	local npcBot = GetBot();

	manabreak = "antimage_mana_break";
	blink = "antimage_blink";
	spellshield = "antimage_spell_shield";
	manavoid = "antimage_mana_void";

	abilityLevels = {
		blink,
		manabreak,
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
end

function AbilityUsageThink()

	local npcBot = GetBot();

	-- Check if we're already using an ability
	if ( npcBot:IsUsingAbility() ) then return end;

	abilityBlink = npcBot:GetAbilityByName( "antimage_blink" );
	abilityUlti = npcBot:GetAbilityByName( "antimage_mana_void" );

	-- Consider using each ability
	castBlinkDesire, castBlinkLocation = ConsiderBlink();
	castUltiDesire, castUltiTarget = ConsiderUlti();

	if ( castUltiDesire > castBlinkDesire ) 
	then
		npcBot:Action_UseAbilityOnEntity( abilityUlti, castUltiTarget );
		return;
	end

	if ( castBlinkDesire > 0 ) 
	then
		npcBot:Action_UseAbilityOnLocation( abilityBlink, castBlinkLocation );
		return;
	end

end

function ConsiderBlink()

	local npcBot = GetBot();

	if (abilityBlink:IsFullyCastable() ) then


		local tableClosestHeroes = npcBot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE) --store a list of nearby enemy heroes
		local hpPer = npcBot:GetMaxHealth() / npcBot:GetHealth()

		--ESCAPE LOGIC
		if hpPer > 2 then --our health is less than 50%
			if (#tableClosestHeroes < 1) then --if there are no enemies nearby (there is no threat, don't blink)
				--print("not blinking because no enemies are in 1600 range")
				return BOT_ACTION_DESIRE_NONE, 0;
			end
			if (#tableClosestHeroes > 0) then
				local l1 = tableClosestHeroes[1]:GetLocation() --closest enemy hero location
				local l2 = npcBot:GetLocation() --our location
				local l3 = l1 - l2
				--print("l1(closest enemy) =",l1," l2(our location) =",l2, " target location =", l2 - l3)
				local targetLocation = GetBlinkLocation(tableClosestHeroes[1], npcBot:GetLocation(), true)
				return BOT_ACTION_DESIRE_VERYHIGH, targetLocation
				--return BOT_ACTION_DESIRE_VERYHIGH, (l2 - l3);
			end
		end
		--CHASE LOGIC
		local furthestEnemy = nil
		for _,npcEnemy in pairs( tableClosestHeroes ) do
			local enemyHpPer = npcBot:GetMaxHealth() / npcBot:GetHealth()
			if enemyHpPer > 10 then --enemy health is less than 10%
				furthestEnemy = npcEnemy --the furthest enemy on less than 10% hp
			end
		end
		if furthestEnemy ~= nil then
			getBlinkLocation(furthestEnemy:GetLocation(), npcBot:GetLocation(), false)
		end
	else
		--print("blink on cooldown")
	end
	return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderUlti()
	local npcBot = GetBot();

	return BOT_ACTION_DESIRE_NONE, 0;
end

function GetBlinkLocation(enemy, ourLocation, bEscape)
	local targetLocation = nil
	if bEscape == true then
		local enemyLocation = enemy:GetLocation()
		print("Enemy location:", enemyLocation)
		local threatAngle = math.atan(enemyLocation.y - ourLocation.y, enemyLocation.x - ourLocation.x)
		print("Angle from threat to X (in degrees):", threatAngle * 180/math.pi)
		local blinkDistance = 900
		--calculate opposite direction to enemy with vector magnitude of blinkDistance
		targetLocation = Vector(blinkDistance*math.cos(threatAngle + math.pi) + ourLocation.x, blinkDistance*math.sin(threatAngle + math.pi) + ourLocation.y, 256) --z location is irrelevant I think
	else
		targetLocation = enemy:GetExtrapolatedLocation(0.6)
	end

	print("Target location that we blinked to: ",targetLocation)

	return targetLocation

end

--[[

{ hUnit, ... } GetNearbyHeroes( nRadius, bEnemies, nMode)
Returns a table of heroes, sorted closest-to-furthest, that are in the specified mode. If nMode is BOT_MODE_NONE,
searches for all heroes. If bEnemies is true, nMode must be BOT_MODE_NONE. nRadius must be less than 1600.

int GetAbilityPoints() Get the number of ability points available to this bot.

GetBot() Returns a handle to the bot on which the script is currently being run

int GetPlayerID() Gets the Player ID of the unit, used in functions that refer to a player rather than a specific unit.

ActionImmediate_LevelAbility ( sAbilityName ) Command a bot to level an ability or a talent.

GetHeroLevel( nPlayerID ) Returns the specified PlayerID's hero's level.
]]