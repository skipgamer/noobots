----------------------------------------------------------------------------------------------------

local MyBots = {
  "npc_dota_hero_tidehunter",
  "npc_dota_hero_zuus",
  "npc_dota_hero_enigma",
  "npc_dota_hero_antimage",
  "npc_dota_hero_crystal_maiden",
};

function Think()
print("thinking about bot picking")
  local IDs = GetTeamPlayers(GetTeam());
  for i,id in pairs(IDs) do
    if IsPlayerBot(id) then
      SelectHero(id, MyBots[i]);
    end
  end
end

----------------------------------------------------------------------------------------------------

function UpdateLaneAssignments()
  --print("Updating lane assignments")

  if ( GetTeam() == TEAM_RADIANT ) then
    return {
      [1] = LANE_TOP,
      [2] = LANE_MID,
      [3] = LANE_BOT,
      [4] = LANE_BOT,
      [5] = LANE_BOT,
    };
  elseif ( GetTeam() == TEAM_DIRE ) then
    return {
      [1] = LANE_BOT,
      [2] = LANE_MID,
      [3] = LANE_TOP,
      [4] = LANE_TOP,
      [5] = LANE_TOP,
    };
  end
end