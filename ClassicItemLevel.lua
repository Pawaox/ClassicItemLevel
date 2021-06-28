local level1 = 35; -- color1 used for >= this & < level2
local level2 = 50; -- color2 used for >= this & < level3
local level3 = 91; -- color3 used for >= this & < level4
local level4 = 115; -- color4 used for >= this & < level5
local level5 = 121; -- color5 used for the highest items (121+ in T4)

local color1 = "ffffff"; -- White
local color2 = "03E500"; -- Green
local color3 = "62a2ff"; -- Blue
local color4 = "FF12E6"; -- Purple
local color5 = "FF911D"; -- Orange

local function GetItemLevel(iLink)
	if not iLink then 
		return -1; 
	end
	
	local iName, iLink, iRarity, iLevel, iMinLevel, iType, iSubType, iStackCount, iEquipId, iTexture = GetItemInfo(iLink);
	
	if not iLevel or iLevel == nil then
		iLevel = -1;
	end
	
	return iLevel;
end

local function EventItem(itemLink, tooltipObj)
	local itemLevel = GetItemLevel(itemLink);
	
	if itemLevel and itemLevel ~= nil then
		local color = "";
		local showTooltip = 1;
		
		if itemLevel >= level5 then
			color = color5;
		elseif itemLevel >= level4 then
			color = color4;
		elseif itemLevel >= level3 then
			color = color3;
		elseif itemLevel >= level2 then
			color = color2;
		elseif itemLevel >= level1 then
			color = color1;
		else
			showTooltip = 0;
		end
		
		if showTooltip == 1 then
			tooltipObj:AddLine("ItemLevel: |cff" .. color .. itemLevel .. "|r");
		end
	end
end

local function EventSetItem()
	local iName, iLink = GameTooltip:GetItem();
	EventItem(iLink, GameTooltip);
end

local function EventSetItemRef()
	local iName, iLink = ItemRefTooltip:GetItem(); 
	EventItem(iLink, ItemRefTooltip);
end
local function EventSetItemCompare1()
	local iName, iLink = ShoppingTooltip1:GetItem();
	EventItem(iLink, ShoppingTooltip1);
end
local function EventSetItemCompare2()
	local iName, iLink = ShoppingTooltip2:GetItem();
	EventItem(iLink, ShoppingTooltip2);
end

GameTooltip:HookScript("OnTooltipSetItem", EventSetItem)
ItemRefTooltip:HookScript("OnTooltipSetItem", EventSetItemRef)
ShoppingTooltip1:HookScript("OnTooltipSetItem", EventSetItemCompare1)
ShoppingTooltip2:HookScript("OnTooltipSetItem", EventSetItemCompare2)