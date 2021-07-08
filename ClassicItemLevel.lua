--[Settings]
itemlevelSetting_AddonEnabled = nil;
itemlevelSetting_ShowEquipItemsOnly = nil;

--[Other Variables]
local level1 = 35; -- color1 used for >= this & < level2
local level2 = 55; -- color2 used for >= this & < level3
local level3 = 105; -- color3 used for >= this & < level4
local level4 = 116; -- color4 used for >= this & < level5
local level5 = 121; -- color5 used for the highest items (121+ in T4)

local color1 = "ffffff"; -- White
local color2 = "03E500"; -- Green
local color3 = "62a2ff"; -- Blue
local color4 = "FF12E6"; -- Purple
local color5 = "FE8505"; -- Orange

local cmdWordsOn = { "on", "enable", "yes", "y" };
local cmdWordsOff = { "off", "disable", "no", "n" };

--[Helper Functions]
local function Split(text, separator)
    result = {};
    for part in (text .. separator):gmatch("(.-)" .. separator) do
        table.insert(result, part);
    end
    return result;
end
local function ListHasValue(list, value)
    for index, listObj in ipairs(list) do
        if listObj == value then
            return true; -- exit immediately, save time
        end
    end
    return false;
end
local function NotifyUser(message)
	print(tostring(message));
end

--[Addon Functions]
local function GetItemLevelAndEquip(itemLink)
	local isEquippableItem = false;
	
	if not itemLink or itemLink == nil then 
		return -1; 
	end
	
	local iLevel, _, iType, iSubType, _, iEquipLoc, _ = select(4, GetItemInfo(itemLink));
	if not iLevel or iLevel == nil then
		iLevel = -1;
	end
	if iEquipLoc ~= nil and iEquipLoc ~= "" then
		isEquippableItem = true;
	end
		
	return iLevel, isEquippableItem;
end

local function EventItem(itemLink, tooltipObj)
	if itemlevelSetting_AddonEnabled == false then
		return; --Exit before doing anything
	end
	
	local itemLevel, isEquipItem = GetItemLevelAndEquip(itemLink);
	
	if itemlevelSetting_AddonEnabled == nil then
		itemlevelSetting_AddonEnabled = true;
	end
	if itemlevelSetting_ShowEquipItemsOnly == nil then
		itemlevelSetting_ShowEquipItemsOnly = true;
	end
			
	if (itemlevelSetting_ShowEquipItemsOnly == true and isEquipItem == true) or itemlevelSetting_ShowEquipItemsOnly == false then
		if itemLevel and itemLevel ~= nil then
			local color = "FFFFFF"; -- Default White
			local validItemLevel = 1;
			
			if 		itemLevel >= level5 then color = color5;
			elseif 	itemLevel >= level4 then color = color4;
			elseif 	itemLevel >= level3 then color = color3;
			elseif 	itemLevel >= level2 then color = color2;
			elseif 	itemLevel >= level1 then color = color1;
			else 	validItemLevel = 0;
			end
			
			if validItemLevel == 1 then
				tooltipObj:AddLine("ItemLevel: |cff" .. color .. itemLevel .. "|r");
			end
		end
	end
end

--[Commands]
SLASH_ITEMLEVEL1 = "/itemlevel"
SLASH_ITEMLEVEL2 = "/ilvl"
SLASH_ITEMLEVEL3 = "/itemlvl"
SlashCmdList["ITEMLEVEL"] = function(msg)
	if msg == nil or msg == '' then --List commands
		NotifyUser("/ilvl 'on/off' will toggle levels being shown");
		NotifyUser("/ilvl equip 'on/off' will decide if only equippable items are shown");
	else
		local parts = Split(msg, " ");
		local p1 = string.lower(parts[1]);
		local p2 = string.lower(parts[2]);
				
		if p1 == "equip" then
			if ListHasValue(cmdWordsOn, p2) then
				itemlevelSetting_AddonEnabled = true;
				itemlevelSetting_ShowEquipItemsOnly = true;
				NotifyUser("ItemLevel 'EquipOnly' enabled");
			elseif ListHasValue(cmdWordsOff, p2) then
				itemlevelSetting_AddonEnabled = true;
				itemlevelSetting_ShowEquipItemsOnly = false;
				NotifyUser("ItemLevel 'EquipOnly' disabled");
			else
				if itemlevelSetting_ShowEquipItemsOnly then
					NotifyUser("ItemLevel 'EquipOnly' is currently enabled");
				else
					NotifyUser("ItemLevel 'EquipOnly' is currently disabled");
				end
			end
		else
			if ListHasValue(cmdWordsOn, p1) then
				itemlevelSetting_AddonEnabled = true;
				NotifyUser("ItemLevel addon enabled");
			elseif ListHasValue(cmdWordsOff, p1) then
				itemlevelSetting_AddonEnabled = false;
				NotifyUser("ItemLevel addon disabled");
			end
		end
	end
end 

--[Event Wrappers]
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

--[Tooltip Hooks]
GameTooltip:HookScript("OnTooltipSetItem", EventSetItem);
ItemRefTooltip:HookScript("OnTooltipSetItem", EventSetItemRef);
ShoppingTooltip1:HookScript("OnTooltipSetItem", EventSetItemCompare1);
ShoppingTooltip2:HookScript("OnTooltipSetItem", EventSetItemCompare2);