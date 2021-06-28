local threshold1Level = 35;
local threshold2Level = 50;
local threshold3Level = 91;
local threshold4Level = 105;
local threshold5Level = 121; -- >120 highest stuff in T4

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
		
		if itemLevel >= threshold5Level then
			color = color5;
		elseif itemLevel >= threshold4Level then
			color = color4;
		elseif itemLevel >= threshold3Level then
			color = color3;
		elseif itemLevel >= threshold2Level then
			color = color2;
		elseif itemLevel >= threshold1Level then
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