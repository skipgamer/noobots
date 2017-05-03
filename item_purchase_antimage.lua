--https://github.com/insraq/dota2bots/blob/master/item_purchase_death_prophet.lua

-- Include this before require to fix Mac
local dir = GetScriptDirectory();
local function GetScriptDirectory()
  if string.sub(dir, 1, 6) == "/Users" then
    return string.match(dir, '.*/(.+)')
  end
  return dir;
end
-----------------------------------------

local Helper = require(GetScriptDirectory() .. "/helper");

local tableItemsToBuy = {
  "item_quelling_blade",
  "item_stout_shield",
  "item_boots",
  "item_slippers",
  "item_slippers",
  "item_ring_of_health",
  "item_void_stone",
  "item_broadsword",
  "item_claymore",
  "item_vladmir",
  "item_recipe_travel_boots",
  "item_yasha",
  "item_manta",
  "item_basher",
  "item_abyssal_blade",
  "item_heart",
  "item_black_king_bar"
};
----------------------------------------------------------------------------------------------------

function ItemPurchaseThink()

  local npcBot = GetBot();
  local buildTable = tableItemsToBuy;

  --Helper.PurchaseBootsAndTP(npcBot);
  PurchaseItems(npcBot, buildTable);

end

function PurchaseItems(npcBot, buildTable) --called from think

  if ( #buildTable == 0 ) then --if there are no items to buy in the build table
    npcBot:SetNextItemPurchaseValue(0); --Sets the value of the next item to purchase (to 0). Doesn't actually execute anything, just potentially useful for communicating a purchase target for modes like Farm.
    return;
  end

  local sNextItem = buildTable[1]; --sets variable to first item in table
  npcBot:SetNextItemPurchaseValue(GetItemCost(sNextItem)); --Sets the value of the next item to purchase (to next items gold value)

  local function PurchaseItem(who) --can be passed the bot of a courier
    who:ActionImmediate_PurchaseItem( sNextItem ); --Command a bot to purchase the specified item
    print(npcBot:GetUnitName() .. " purchased " .. sNextItem) --print it
    table.remove(buildTable, 1); --remove the first item (we just purchased) from the table
  end
  
  if (npcBot:GetGold() >= GetItemCost(sNextItem)) then --if we have enough gold to purchase next item
    if (IsItemPurchasedFromSecretShop(sNextItem)) then --if we have to get it from secret shop
      if GetCourier(GetNumCouriers() -1):DistanceFromSecretShop() < 300 then --check courier distance to secret shop, if less than 300 (purchase range)
        PurchaseItem(GetCourier(GetNumCouriers() -1)); --purchase item, pass the function the courier for it to purchase
        npcBot:ActionImmediate_Courier(GetCourier(GetNumCouriers() -1), COURIER_ACTION_TRANSFER_ITEMS); --command to get item from courier
      elseif IsCourierAvailable() then --if courier is available (but not in range of secret shop)
        npcBot:ActionImmediate_Courier(GetCourier(GetNumCouriers() -1), COURIER_ACTION_SECRET_SHOP); --send courier to secret shop
      end
    else --if we dont have to get item from secret shop
      PurchaseItem(npcBot); --just buy item ourselves? (dumb logic)
    end
  end
  
end