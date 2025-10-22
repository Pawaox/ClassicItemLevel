SV_ilvl=SV_ilvl or{}
local _s1=1--enabled
local _s2=2--equip
local _s3=3--clr
local _c={}--cache

local function Chat(message) print("|cFF4FC0C4[ClassicItemLevel]:|r |cFF40C24F"..tostring(message).."|r") end
local function Display(itm,ttObj)
	if SV_ilvl[_s1]==false then return end
    local rarity,lvl,_,_,_,_,ieq=select(3, C_Item.GetItemInfo(itm))
	local iEquip=(ieq~=nil and ieq~="" and ieq~="INVTYPE_NON_EQUIP_IGNORE")
	if SV_ilvl[_s2]==false or iEquip then
		if lvl and lvl>=0 then
			local clr="|cFFFFFFFF"
			if SV_ilvl[_s3]~=false and rarity and rarity>0 then
				if _c[rarity] then
					clr=_c[rarity]
				else
					local r,g,b=C_Item.GetItemQualityColor(rarity)
					clr=string.format("|cFF%02x%02x%02x",r*255,g*255,b*255)
					_c[rarity]=clr
				end
			end
			ttObj:AddLine("ItemLevel: "..clr..lvl.."|r")
		end
	end
end
local function Command(s,val,tPre,tOn,tOff,tsOn,tsOff,turnOn,eCheck)
	if (val=="on" or val=="enable" or val=="yes" or val=="y") then
		SV_ilvl[s]=true
		if turnOn then SV_ilvl[_s1]=true end
		Chat(tPre..tOn)
	elseif (val=="off" or val=="disable" or val=="no" or val=="n") then
		SV_ilvl[s]=false
		if turnOn then SV_ilvl[_s1]=true end
		Chat(tPre..tOff)
	elseif eCheck==true then
		if SV_ilvl[s]==nil and true or SV_ilvl[s] then
			Chat(tPre..tsOn)
		else
			Chat(tPre..tsOff)
		end
	end
end

SLASH_CITEMLEVEL1 = "/itemlevel"
SLASH_CITEMLEVEL2 = "/ilvl"
SLASH_CITEMLEVEL3 = "/itemlvl"
SlashCmdList["CITEMLEVEL"]=function(msg)
	if msg=='' then
		Chat("/ilvl 'on/off' to toggle display of itemlevels")
		Chat("/ilvl equip 'on/off' to only show ilvl on equippable items")
		Chat("/ilvl color 'on/off' to change if itemlevel is be colored or white.")
	else
		local p1,p2=msg:match("(%S+)%s*(%S*)")
		p1=p1 and p1:lower() or ""
		p2=p2~="" and p2:lower() or nil
		if p1=="equip" then
			Command(_s2,p2,"'EquipOnly' ","on","off","is on","is off",true,true)
		elseif p1=="color" or p1=="colour" or p1=="colors" or p1=="colours" then
			Command(_s3,p2,"Colors ","on","off","are on","are off",true,true)
		else
			Command(_s1,p1,"Display is ","on","off",nil,nil,false,false)
		end
	end
end
local frm = CreateFrame("Frame")
local function OnLoad(_, _,addonName)
	if addonName=="ClassicItemLevel" then
		for k,v in pairs({[_s1]=true,[_s2]=true,[_s3]=true}) do
			if SV_ilvl[k]==nil then SV_ilvl[k]=v end
		end
		frm:UnregisterEvent("ADDON_LOADED")
	end
end
for _,tt in ipairs({GameTooltip,ItemRefTooltip,ShoppingTooltip1,ShoppingTooltip2}) do
    tt:HookScript("OnTooltipSetItem", function() Display(select(2,tt:GetItem()),tt) end)
end
frm:RegisterEvent("ADDON_LOADED")
frm:SetScript("OnEvent", OnLoad)