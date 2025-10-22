SV_ilvl=SV_ilvl or {}
local sEnabled=1
local sEquipOnly=2
local sColor=3
local _cachedRarityColors={}

local function SplitParams(text)
    local result={}
    for part in text:gmatch("%S+") do
        table.insert(result, part)
    end
    return result
end
local function NotifyUser(message) print("|cFF4FC0C4[ClassicItemLevel]:|r |cFF40C24F"..tostring(message).."|r") end
local function GetItemColor(itemRarity)
	local clr = "|cFFFFFFFF"
	if itemRarity and itemRarity>1 then
		if _cachedRarityColors[itemRarity] then
			clr=_cachedRarityColors[itemRarity]
		else
			local r,g,b = C_Item.GetItemQualityColor(itemRarity)
			clr=string.format("|cFF%02x%02x%02x", r*255,g*255, b*255)
			_cachedRarityColors[itemRarity] = clr
		end
	end
	return clr
end
local function GetItemLevelAndEquip(itemLink)
    if itemLink==nil then return -1 end
    local iRarity,iLevel,_,_,_,_,iEquipLoc=select(3, C_Item.GetItemInfo(itemLink))
    return iLevel or -1,iRarity or 1,(iEquipLoc~=nil and iEquipLoc~="")
end
local function EventItem(itemLink,tooltipObj)
	if SV_ilvl[sEnabled]==false then
		return
	end

	local ilvl,iRarity,isEquipItem=GetItemLevelAndEquip(itemLink)
	local showEquipOnly=SV_ilvl[sEquipOnly]
	if showEquipOnly==nil then
		showEquipOnly=true
	end
	if (showEquipOnly and isEquipItem) or not showEquipOnly then
		if ilvl and ilvl>=0 then
			local color="|cFFFFFFFF"
			if SV_ilvl[sColor]~=false then
				color=GetItemColor(iRarity)
			end
			tooltipObj:AddLine("ItemLevel: "..color..ilvl.."|r")
		end
	end
end
local function SetSettingNotify(setting,value,txtBase,txtOn,txtOff,txtEnabled,txtDisabled,ensureAddonOn,elseCheck)
	if (value=="on" or value=="enable" or value=="yes" or value=="y") then
		SV_ilvl[setting]=true
		if ensureAddonOn then SV_ilvl[sEnabled]=true end
		NotifyUser(txtBase..txtOn)
	elseif (value=="off" or value=="disable" or value=="no" or value=="n") then
		SV_ilvl[setting]=false
		if ensureAddonOn then SV_ilvl[sEnabled]=true end
		NotifyUser(txtBase..txtOff)
	elseif elseCheck==true then
		if SV_ilvl[setting]==nil and true or SV_ilvl[setting] then
			NotifyUser(txtBase..txtEnabled)
		else
			NotifyUser(txtBase..txtDisabled)
		end
	end
end

SLASH_CITEMLEVEL1 = "/itemlevel"
SLASH_CITEMLEVEL2 = "/ilvl"
SLASH_CITEMLEVEL3 = "/itemlvl"
SlashCmdList["CITEMLEVEL"]=function(msg)
	if msg=='' then
		NotifyUser("/ilvl 'on/off' to enable or disable display of itemlevels")
		NotifyUser("/ilvl equip 'on/off' to change if itemlevel is only shown for equippable items")
		NotifyUser("/ilvl color 'on/off' to change if itemlevel is be colored or white.")
	else
		local parts=SplitParams(msg)
		local p1=string.lower(parts[1])
		local p2
		if parts[2]~=nil then
			p2=string.lower(parts[2])
		end
		if p1=="equip" then
			SetSettingNotify(sEquipOnly,p2,"'EquipOnly' ","on","off","is on","is off",true,true)
		elseif p1=="color" or p1=="colour" or p1=="colors" or p1=="colours" then
			SetSettingNotify(sColor,p2,"Colors ","on","off","are on","are off",true,true)
		else
			SetSettingNotify(sEnabled,p1,"Addon ","on","off",nil,nil,false,false)
		end
	end
end
local basicEventFrame = CreateFrame("Frame")
local function EventAddonLoaded(self, event, addonName)
	if addonName=="ClassicItemLevel" then
		local defaults={[sEnabled]=true, [sEquipOnly]=true, [sColor]=true}
		for k,v in pairs(defaults) do
			if SV_ilvl[k]==nil then SV_ilvl[k]=v end
		end
		basicEventFrame:UnregisterEvent("ADDON_LOADED")
	end
end
for _,tt in ipairs({GameTooltip,ItemRefTooltip,ShoppingTooltip1,ShoppingTooltip2}) do
    tt:HookScript("OnTooltipSetItem", function() EventItem(select(2,tt:GetItem()),tt) end)
end
basicEventFrame:RegisterEvent("ADDON_LOADED")
basicEventFrame:SetScript("OnEvent", EventAddonLoaded)