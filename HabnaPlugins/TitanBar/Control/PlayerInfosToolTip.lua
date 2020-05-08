-- Written By Habna
-- Refactored By 4andreas
-- Adjusted for CalcStat use By Giseldah (and added a few more caps)

import "Giseldah.CalcStat";

-- interface to CalcStat classnames
CSClassNames = {
	[L["Beorning"]]="Beorning",
	[L["Burglar"]]="Burglar",
	[L["Captain"]]="Captain",
	[L["Champion"]]="Champion",
	[L["Guardian"]]="Guardian",
	[L["Hunter"]]="Hunter",
	[L["Lore-Master"]]="LoreMaster",
	[L["Minstrel"]]="Minstrel",
	[L["Rune-Keeper"]]="RuneKeeper",
	[L["Warden"]]="Warden"
	};

-- Data 2-dim array, Data[index][string], string could be name,value,icon
Data = {};
-- DataHeading - headings for Data, index - position of heading in Data
DataHeading = {[9] = "Stats", [22] = "Mitigations", [20] = "Healing", [14] = "Offence", [26] = "Defence"};
for i = 1,36 do Data[i] = {}; end

function GetData()
    Data[1]["name"] = "Morale";
    Data[1]["value"] = comma_value(round(Player:GetMorale()))
        .." / ".. comma_value(round(Player:GetMaxMorale()));
    Data[1]["icon"] = resources.PlayerInfo.Morale;
    if PlayerClassIs == L["Beorning"] then 
        Power = round(Player:GetClassAttributes():GetWrath());
        MaxPower = 100;
    else 
        Power = comma_value(round(Player:GetPower()));
        MaxPower = comma_value(round(Player:GetMaxPower()));
    end;
    Data[2]["name"],Data[2]["value"] = "Power",(Power .." / ".. MaxPower);
    Data[2]["icon"] = resources.PlayerInfo.Power;  
    
    if PlayerAlign == 1 then
        Data[3]["name"],Data[3]["value"] = "Armour",comma_value(PlayerAtt:GetArmor());
        Data[3]["icon"] = resources.PlayerInfo.Armor;    
        curLvl = Player:GetLevel(); --Current player level
        -- OTHER --
        Data[4]["name"],Data[4]["value"] = "Level",curLvl;
        Data[5]["name"],Data[5]["value"] = "Race",PlayerRaceIs;
        Data[6]["name"],Data[6]["value"] = "Class",PlayerClassIs;
        Data[7]["name"],Data[7]["value"] = "XP", L["MLvl"];
        Data[8]["name"],Data[8]["value"] = "NXP", "";

        if curLvl < CalcStat("LevelCap") then
            --Calculate experience cost for next level
            maxXP = CalcStat("LvlExpCost",curLvl+1);
            --Calculate the min xp for current level
            minXP = ExpPTS;         
            --minXP = string.gsub(minXP, ",", ""); --Replace "," in 1,400 to get 1400
            minXP = string.gsub(minXP, "%p", ""); --Replace decimal separator Ex.: in 1,400 to get 1400
            minXP = minXP - CalcStat("LvlExpCostTot",curLvl);
            if minXP < 0 then minXP = "No Data"; else minXP = string.format("%2d", minXP); end          
            --Calculate % for current level
            if minXP ~= "No Data" then 
                percentage_done = " (" .. string.format("%.2f", (minXP / maxXP)*100) .. "%)"; 
                minXP = comma_value(minXP); -- Convert back number with comma
            else 
                percentage_done = ""; 
            end         
            -- Convert back number with comma
            Data[7]["value"] = minXP .. percentage_done;
            Data[8]["value"] = comma_value(maxXP);
        end
        -- OTHER END --
        -- STATISTICS --
        Data[9]["name"],Data[9]["value"] = "Might",PlayerAtt:GetMight();
        Data[10]["name"],Data[10]["value"] = "Agility",PlayerAtt:GetAgility();
        Data[11]["name"],Data[11]["value"] = "Vitality",PlayerAtt:GetVitality();
        Data[12]["name"],Data[12]["value"] = "Will",PlayerAtt:GetWill();
        Data[13]["name"],Data[13]["value"] = "Fate",PlayerAtt:GetFate();
        -- STATISTICS END --
        for i = 9,13 do Data[i]["value"] = comma_value(Data[i]["value"]); end
        PlayerAttArray = {}; -- array[i] = {"Visible label name", value, "formula category", "penetration debuff", penetration factor};
        -- for i = 14,33 do PlayerAttArray[i] = {} end; 
        PlayerAttArray[22] = {"Physical", PlayerAtt:GetCommonMitigation(), "PhyMit", "Armour", 1.0};
        PlayerAttArray[23] = {"Tactical", PlayerAtt:GetTacticalMitigation(), "TacMit", "Armour", 1.0};
        PlayerAttArray[24] = {"Orc", PlayerAtt:GetPhysicalMitigation(), "PhyMit", "Armour", 1.0};
        PlayerAttArray[25] = {"Fell", PlayerAtt:GetPhysicalMitigation(), "PhyMit", "Armour", 1.0};
        PlayerAttArray[20] = {"Outgoing", PlayerAtt:GetOutgoingHealing(), "OutHeal", nil, nil};
        PlayerAttArray[21] = {"Incoming", PlayerAtt:GetIncomingHealing(), "InHeal", nil, nil};
        PlayerAttArray[14] = {"Melee", PlayerAtt:GetMeleeDamage(), "PhyDmg", nil, nil};
        PlayerAttArray[15] = {"Ranged", PlayerAtt:GetRangeDamage(), "PhyDmg", nil, nil};
        PlayerAttArray[16] = {"Tactical", PlayerAtt:GetTacticalDamage(), "TacDmg", nil, nil};
        PlayerAttArray[17] = {"CritHit", PlayerAtt:GetBaseCriticalHitChance(), "CritHit", nil, nil};
        PlayerAttArray[18] = {"DevHit", PlayerAtt:GetBaseCriticalHitChance(), "DevHit", nil, nil};
        PlayerAttArray[19] = {"Finesse", PlayerAtt:GetFinesse(), "Finesse", nil, nil};
        PlayerAttArray[26] = {"CritDef", PlayerAtt:GetBaseCriticalHitAvoidance(), "CritDef", nil, nil};
        PlayerAttArray[27] = {"Resistances", PlayerAtt:GetBaseResistance(), "Resist", "Resist", nil};
        PlayerAttArray[28] = {"Block", PlayerAtt:GetBlock(), "Block", "BPE", nil};
        PlayerAttArray[29] = {"Partial", PlayerAtt:GetBlock(), "PartBlock", "BPE", nil};
        PlayerAttArray[30] = {"PartMit", PlayerAtt:GetBlock(), "PartBlockMit", "BPE", nil};
        PlayerAttArray[31] = {"Parry", PlayerAtt:GetParry(), "Parry", "BPE", nil};
        PlayerAttArray[32] = {"Partial", PlayerAtt:GetParry(), "PartParry", "BPE", nil};
        PlayerAttArray[33] = {"PartMit", PlayerAtt:GetParry(), "PartParryMit", "BPE", nil};
        PlayerAttArray[34] = {"Evade", PlayerAtt:GetEvade(), "Evade", "BPE", nil};
        PlayerAttArray[35] = {"Partial", PlayerAtt:GetEvade(), "PartEvade", "BPE", nil};
        PlayerAttArray[36] = {"PartMit", PlayerAtt:GetEvade(), "PartEvadeMit", "BPE", nil};
		local CDCanBlock = CalcStat(CSClassNames[PlayerClassIs].."CDCanBlock",curLvl);
        for i = 14,36 do
            Data[i]["name"] = PlayerAttArray[i][1];
			if not (PlayerAttArray[i][3] == "Block" or PlayerAttArray[i][3] == "PartBlock" or PlayerAttArray[i][3] == "PartBlockMit") or CDCanBlock > 0 then
				Data[i]["value"], Data[i]["capped"] = get_percentage(PlayerAttArray[i][3], PlayerAttArray[i][2], curLvl, PlayerAttArray[i][4], PlayerAttArray[i][5]);
			else
				Data[i]["value"], Data[i]["capped"] = "--",0;
			end
        end
        
    end
end

-- Formula and data used from: http://lotro-wiki.com/index.php/rating_to_percentage_formula
-- Huge thanks to Giseldah for figuring this out and sharing    
function get_percentage(Attribute,R,L,PenName,PenFactor)
    local SName = Attribute;
    local Capped = 0;
    
    if SName == "PhyMit" or SName == "TacMit" then -- is dependant on armour type
		local CDArmourType = CalcStat(CSClassNames[PlayerClassIs].."CDArmourType",L);
		SName = SName..string.sub("LMH",CDArmourType,CDArmourType);
    end

    local P = CalcStat(SName.."PRatP",L,R) + 0.0002 + CalcStat(SName.."PBonus",L);
    local Rcap = CalcStat(SName.."PRatPCapR",L);
  
    if PenName == nil then
      if R >= Rcap then
        Capped = 1;
      end
    else
      local PenValue;
      PenValue = CalcStat("TPen"..PenName,L,3);
      if PenFactor ~= nil then PenValue = PenValue * PenFactor; end
      if R + PenValue >= Rcap then
        Capped = 4;
      else
        PenValue = CalcStat("TPen"..PenName,L,2);
        if PenFactor ~= nil then PenValue = PenValue * PenFactor; end
        if R + PenValue >= Rcap then
          Capped = 3;
        else
          PenValue = CalcStat("T2Pen"..PenName,L);
          if PenFactor ~= nil then PenValue = PenValue * PenFactor; end
          if R + PenValue >= Rcap then
            Capped = 2;
          elseif R >= Rcap then
              Capped = 1;
          end
        end
      end
    end
    
    return rating_string(R, P, Attribute), Capped;
end

function rating_string(r,p,a) -- String format for Rating and percentage 1234 (25.1%)
    r = comma_value(math.floor(r+0.5));
    if a == "PartBlock" or a == "PartParry" or a == "PartEvade" or a == "PartBlockMit" or a == "PartParryMit" or a == "PartEvadeMit" then return (string.format("%.1f", p) .. "%"); end
    return (r .. " (" .. string.format("%.1f", p) .. "%)");
end

function comma_value(n) -- credit http://richard.warburton.it
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end
-- control for stats with icon
function CreateCtr(parent,index)
    local NewCtr = Turbine.UI.Control();
    NewCtr:SetParent(parent);
    NewCtr:SetSize(CtrW, 26);
    NewCtr:SetPosition((15+(index-1)*(CtrW+5)),17);
         
    local NewIcon = Turbine.UI.Control();
    NewIcon:SetParent(NewCtr);
    NewIcon:SetBlendMode(5);
    NewIcon:SetSize(24,26);
    NewIcon:SetPosition(1,1);
    NewIcon:SetBackground(Data[index]["icon"]);        

    local NewLabel = Turbine.UI.Label();
    NewLabel:SetParent(NewCtr);
    NewLabel:SetSize(85,26);
    NewLabel:SetPosition(30,-2);
    NewLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    NewLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro20);
    NewLabel:SetForeColor(Color["nicegreen"]);
    NewLabel:SetText(L[Data[index]["name"]]);

    local NewValue = Turbine.UI.Label();
    NewValue:SetParent(NewCtr);
    NewValue:SetSize(CtrW-85,26);
    NewValue:SetPosition(115, 0);
    NewValue:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    NewValue:SetFont(Turbine.UI.Lotro.Font.Verdana15);
    NewValue:SetForeColor(Color["white"]);
    NewValue:SetText(Data[index]["value"]);
end

-- basic stat with Label and Value
function CreateLabel(parent,index,LblSize,ValSize,x,y)
    if index == 7 then LblSize,ValSize = 60,130; end -- Max lvl reached text too long
    local NewLabel = Turbine.UI.Label();
    NewLabel:SetParent(parent);
    if Data[index]["name"] == "Partial" or Data[index]["name"] == "PartMit" then -- Indent Partial
        LblSize = LblSize - _G.AlignOffP;
        x = x + _G.AlignOffP; 
    end 
    NewLabel:SetSize(LblSize,15);
    NewLabel:SetPosition(x,y);
    NewLabel:SetTextAlignment(_G.AlignLbl);
    NewLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
    NewLabel:SetForeColor( Color["nicegold"] );
    NewLabel:SetText(L[Data[index]["name"]]);

    local NewValue = Turbine.UI.Label();
    NewValue:SetParent(parent);
    NewValue:SetSize(ValSize,15);
    NewValue:SetPosition(NewLabel:GetLeft()+NewLabel:GetWidth()+_G.AlignOff,NewLabel:GetTop());
    NewValue:SetTextAlignment(_G.AlignVal);
    NewValue:SetFont(Turbine.UI.Lotro.Font.Verdana12);
    NewValue:SetForeColor(Color["white"]);
    if Data[index]["capped"] == 1 then
        NewValue:SetForeColor(Color["yellow"]);
    elseif Data[index]["capped"] == 2 then
        NewValue:SetForeColor(Color["orange"]);
    elseif Data[index]["capped"] == 3 then
        NewValue:SetForeColor(Color["red"]);
    elseif Data[index]["capped"] == 4 then
        NewValue:SetForeColor(Color["purple"]);
    end
    NewValue:SetText(Data[index]["value"]);  
end

-- Heading for stat groups
function CreateHeading(parent,index,x,y)
    local NewHeading = Turbine.UI.Label();
    NewHeading:SetParent(parent);
    NewHeading:SetSize(190,18);
    NewHeading:SetPosition(x,y);
    NewHeading:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    NewHeading:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
    NewHeading:SetForeColor(Color["white"]);
    NewHeading:SetText(L[DataHeading[index]]);

    local NewSeparator = Turbine.UI.Control();
    NewSeparator:SetParent(parent);
    NewSeparator:SetSize(191,1);
    NewSeparator:SetPosition(NewHeading:GetLeft(),NewHeading:GetTop()+18);
    NewSeparator:SetBackColor(Color["trueblue"]);
end

function ShowPIWindow()
    CtrW = 285;
    if PlayerAlign == 1 then th = 256; tw = 3*CtrW; else th = 75; tw = 2*CtrW; end --th: temp height / tw: temp width

    -- ( offsetX, offsetY, width, height, bubble side )
    local x, y, w, h = -5, -15, tw, th;
    local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
    
    if w + mouseX > screenWidth then x = w - 10; end
    if not TBTop then y = h; end
    
    _G.ToolTipWin = Turbine.UI.Window();
    _G.ToolTipWin:SetZOrder( 1 );
    _G.ToolTipWin:SetPosition( mouseX - x, mouseY - y);
    _G.ToolTipWin:SetSize( w, h );
    _G.ToolTipWin:SetVisible( true );

    --**v Control of all player infos v**
    local APICtr = Turbine.UI.Control();
    APICtr:SetParent( _G.ToolTipWin );
    APICtr:SetZOrder( 1 );
    APICtr:SetSize( w, h );
    APICtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
    --**^
    GetData();
    if (PlayerAlign ~= 1) then -- not Freep
        for i = 1,2 do CreateCtr(APICtr,i); end
        local WarningLabel = Turbine.UI.Label();
        WarningLabel:SetParent(APICtr);
        WarningLabel:SetPosition(25,47);
        WarningLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
        WarningLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
        WarningLabel:SetForeColor( Color["nicegold"] );
        WarningLabel:SetText( L["NoData"] );
        WarningLabel:SetSize(WarningLabel:GetTextLength()*7.2, 15 ); --Auto size with text lenght
    else
        for i = 1,3 do CreateCtr(APICtr,i); end
        local Separator = Turbine.UI.Control();
        Separator:SetParent(APICtr);
        Separator:SetSize(tw-10,1);
        Separator:SetPosition(5,43);
        Separator:SetBackColor(Color["trueblue"]);
        local x,y = 20,47;
        for i = 4,36 do
            if (i == 14) or (i == 22) or (i == 26) then y = 47; x = x + 210; end
            if DataHeading[i] ~= nill then CreateHeading(APICtr,i,x,y+5); y = y +27; end
            CreateLabel(APICtr,i,90,100,x,y);
            y = y + 15;
        end
        local CappedLabel=Turbine.UI.Label();
        CappedLabel:SetParent(APICtr);
        CappedLabel:SetSize(400,15);
        CappedLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
        CappedLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
        CappedLabel:SetForeColor(Color["yellow"]);
        CappedLabel:SetText("YELLOW - capped");
        CappedLabel:SetPosition(540-CappedLabel:GetTextLength()*4.1,y-75);
        
        local T2Label=Turbine.UI.Label();
        T2Label:SetParent(APICtr);
        T2Label:SetSize(400,15);
        T2Label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
        T2Label:SetFont(Turbine.UI.Lotro.Font.Verdana16);
        T2Label:SetForeColor(Color["orange"]);
        T2Label:SetText("ORANGE - T2 capped");
        T2Label:SetPosition(540-T2Label:GetTextLength()*4.1,y-60);
        
        local T2NLabel=Turbine.UI.Label();
        T2NLabel:SetParent(APICtr);
        T2NLabel:SetSize(400,15);
        T2NLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
        T2NLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
        T2NLabel:SetForeColor(Color["red"]);
        T2NLabel:SetText("RED - new T2 capped");
        T2NLabel:SetPosition(540-T2NLabel:GetTextLength()*4.1,y-45);
        
        local T3NLabel=Turbine.UI.Label();
        T3NLabel:SetParent(APICtr);
        T3NLabel:SetSize(400,15);
        T3NLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
        T3NLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
        T3NLabel:SetForeColor(Color["purple"]);
        T3NLabel:SetText("PURPLE - new T3-5 capped");
        T3NLabel:SetPosition(540-T3NLabel:GetTextLength()*4.1,y-30);
    end
    
    ApplySkin();
end
