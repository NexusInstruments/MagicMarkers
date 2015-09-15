------------------------------------------------------------------------------------------------
--  MagicMarkers ver. @project-version@
--  Authored by Chrono Syz -- Entity-US / Wildstar
--  Based on ZinMakers
--  Build @project-hash@
--  Copyright (c) Chronosis. All rights reserved
--
--  https://github.com/chronosis/MagicMarkers
------------------------------------------------------------------------------------------------
-- MagicMarkers.lua
------------------------------------------------------------------------------------------------

require "Window"
require "Unit"
require "GameLib"
require "GroupLib"
require "Apollo"
require "ICComm"

-----------------------------------------------------------------------------------------------
-- MagicMarkers Module Definition
-----------------------------------------------------------------------------------------------
local CommAttemptDelay = 3 -- The delay between attempts to load channel
local MaxCommAttempts = 10 -- The number of attempts made to connect to Comm Channel before abandoning
local CommChannelName = "MagicMarkersChannel" -- The channel name
local CommChannelTimer = nil

local MagicMarkers = {}
local Utils = Apollo.GetPackage("SimpleUtils").tPackage
local RaidMemberHelper = Apollo.GetPackage("RaidMemberHelper").tPackage
local log

local Major, Minor, Patch, Suffix = 1, 3, 1, 1
local MAGICMARKERS_CURRENT_VERSION = string.format("%d.%d.%d", Major, Minor, Patch)

-----------------------------------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------------------------------
-- e.g. local kiExampleVariableMax = 999
local markerEnum = {
  ["Bomb"] = 1,
  ["Chicken"] = 2,
  ["Ghost"] = 3,
  ["Mask"] = 4,
  ["Octopus"] = 5,
  ["Pig"] = 6,
  ["Toaster"] = 7,
  ["UFO"] = 8,
  ["Number_1"] = 9,
  ["Number_2"] = 11,
  ["Number_3"] = 12,
  ["Number_4"] = 13,
  ["Number_5"] = 14,
  ["Number_5"] = 15,
  ["Number_7"] = 16,
  ["Number_8"] = 17,
  ["Number_9"] = 18,
  ["Number_0"] = 19,
  ["OldGreg"] = 20,
  ["Star"] = 21,
  ["Moon"] = 22,
  ["Planet"] = 23,
  ["North"] = 24,
  ["East"] = 25,
  ["South"] = 26,
  ["West"] = 27,
}

local markers = {
  -- name(string), sprite(string), set(bool), location(table), options(table)
  Bomb = {
    name = "Bomb",
    sprite = "Icon_Windows_UI_CRB_Marker_Bomb",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  Chicken = {
    name = "Chicken",
    sprite = "Icon_Windows_UI_CRB_Marker_Chicken",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  Ghost = {
    name = "Ghost",
    sprite = "Icon_Windows_UI_CRB_Marker_Ghost",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  Mask = {
    name = "Mask",
    sprite = "Icon_Windows_UI_CRB_Marker_Mask",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  Octopus = {
    name = "Octopus",
    sprite = "Icon_Windows_UI_CRB_Marker_Octopus",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  Pig = {
    name = "Pig",
    sprite = "Icon_Windows_UI_CRB_Marker_Pig",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  Toaster = {
    name = "Toaster",
    sprite = "Icon_Windows_UI_CRB_Marker_Toaster",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  UFO = {
    name = "UFO",
    sprite = "Icon_Windows_UI_CRB_Marker_UFO",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  Number_1 = {
    name = "Number_1",
    sprite = "sprFloater_Critical1",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  Number_2 = {
    name = "Number_2",
    sprite = "sprFloater_Critical2",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  Number_3 = {
    name = "Number_3",
    sprite = "sprFloater_Critical3",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  Number_4 = {
    name = "Number_4",
    sprite = "sprFloater_Critical4",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  Number_5 = {
    name = "Number_5",
    sprite = "sprFloater_Critical5",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  Number_6 = {
    name = "Number_6",
    sprite = "sprFloater_Critical6",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  Number_7 = {
    name = "Number_7",
    sprite = "sprFloater_Critical7",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  Number_8 = {
    name = "Number_8",
    sprite = "sprFloater_Critical8",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  Number_9 = {
    name = "Number_9",
    sprite = "sprFloater_Critical9",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  Number_0 = {
    name = "Number_0",
    sprite = "sprFloater_Critical0",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  OldGreg = {
    name = "OldGreg",
    sprite = "MagicMarkersSprites:OldGreg_256",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  Star = {
    name = "Star",
    sprite = "MagicMarkersSprites:Star_256",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  Moon = {
    name = "Moon",
    sprite = "MagicMarkersSprites:Moon_256",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  Planet = {
    name = "Planet",
    sprite = "MagicMarkersSprites:Planet_256",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  North = {
    name = "North",
    sprite = "MagicMarkersSprites:LetterN_256",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  East = {
    name = "East",
    sprite = "MagicMarkersSprites:LetterE_256",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  South = {
    name = "South",
    sprite = "MagicMarkersSprites:LetterS_256",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  },
  West = {
    name = "West",
    sprite = "MagicMarkersSprites:LetterW_256",
    pixieId = nil,
    location = nil,
    options = { w = 20, h = 20}
  }
}

local tDefaultProfiles = {
  [1] = {
    name = "Kuralak",
    markers = {
      [1] = "North;206.6851348877;-111.44667053223;-555.53625488281;MagicMarkersSprites:LetterN_256",
      [2] = "Bomb;162.05693054199;-112.09367370605;-477.77438354492;Icon_Windows_UI_CRB_Marker_Bomb",
      [3] = "Pig;175.57383728027;-112.08802032471;-478.5954284668;Icon_Windows_UI_CRB_Marker_Pig",
      [4] = "Toaster;182.1371307373;-112.09367370605;-482.68237304688;Icon_Windows_UI_CRB_Marker_Toaster",
      [5] = "Octopus;184.51776123047;-112.09367370605;-489.25350952148;Icon_Windows_UI_CRB_Marker_Octopus",
      [6] = "UFO;181.76831054688;-112.08521270752;-496.77624511719;Icon_Windows_UI_CRB_Marker_UFO",
      [7] = "Mask;176.64668273926;-112.09366607666;-501.96658325195;Icon_Windows_UI_CRB_Marker_Mask",
      [8] = "Ghost;162.85749816895;-112.09367370605;-501.84780883789;Icon_Windows_UI_CRB_Marker_Ghost",
      [9] = "Chicken;154.77198791504;-112.09367370605;-489.76553344727;Icon_Windows_UI_CRB_Marker_Chicken"
    }
  },
  [2] = {
    name = "Phage Maw",
    markers = {
      [1] = "Star;3734.1630859375;-306.59585571289;-125.1821975708;MagicMarkersSprites:Star_256"
    }
  },
  [3] = {
    name = "Ohmna",
    markers = {
      [1] = "Bomb;2814.2836914063;-448.78671264648;-105.99939727783;Icon_Windows_UI_CRB_Marker_Bomb",
      [2] = "Chicken;2774.5405273438;-448.78659057617;-108.68078613281;Icon_Windows_UI_CRB_Marker_Chicken",
      [3] = "Ghost;2791.1359863281;-448.78634643555;-145.60018920898;Icon_Windows_UI_CRB_Marker_Ghost",
      [4] = "UFO;2814.9113769531;-448.78454589844;-126.84462738037;Icon_Windows_UI_CRB_Marker_UFO"
    }
  },
  [4] = {
    name = "System Daemons",
    markers = {
      [1] = "North;131.63136291504;-223.5594329834;-279.75894165039;MagicMarkersSprites:LetterN_256",
      [2] = "South;133.46859741211;-222.90234375;-67.640289306641;MagicMarkersSprites:LetterS_256"
    }
  },
  [5] = {
    name = "Limbo Infomatrix",
    markers = {
        [1]  = "Ghost;-10005.637695313;-727.08416748047;-16353.180664063;Icon_Windows_UI_CRB_Marker_Ghost",
        [2]  = "Mask;-9706.37109375;-726.33465576172;-16447.697265625;Icon_Windows_UI_CRB_Marker_Mask",
        [3]  = "Number_1;-9891.4521484375;-724.70965576172;-16559.23046875;sprFloater_Critical1",
        [4]  = "Number_2;-9855.919921875;-723.82641601563;-16363.112304688;sprFloater_Critical2",
        [5]  = "North;-9827.201171875;-719.77172851563;-16627.810546875;MagicMarkersSprites:LetterN_256",
        [6]  = "Number_9;-9980.1240234375;-709.23016357422;-16491.849609375;sprFloater_Critical9",
        [7]  = "Number_8;-9951.8486328125;-723.30963134766;-16211.5859375;sprFloater_Critical8",
        [8]  = "South;-9725.1240234375;-713.86016845703;-16122.1796875;MagicMarkersSprites:LetterS_256",
        [9]  = "Moon;-9502.2080078125;-711.69409179688;-16303.55078125;MagicMarkersSprites:Moon_256",
        [10] = "Star;-9551.3115234375;-716.08087158203;-16541.69140625;MagicMarkersSprites:Star_256",
        [11] = "OldGreg;-9979;-709.26086425781;-16491.10546875;MagicMarkersSprites:OldGreg_256",
        [12] = "Planet;-9950.8681640625;-723.32281494141;-16211.50390625;MagicMarkersSprites:Planet_256",
    }
  },
  [6] = {
    name = "Volatility Lattice",
    markers = {
      [1]  = "Star;16796.3984375;-370.70474243164;-17570.611328125;MagicMarkersSprites:Star_256",
      [2]  = "Planet;16792.6796875;-370.70474243164;-17570.720703125;MagicMarkersSprites:Planet_256",
      [3]  = "Moon;16799.857421875;-370.70852661133;-17570.71484375;MagicMarkersSprites:Moon_256",
      [4]  = "OldGreg;16796.8125;-370.70852661133;-17566.9921875;MagicMarkersSprites:OldGreg_256",
      [5]  = "Number_0;16796.515625;-370.69854736328;-17574.708984375;sprFloater_Critical0",
      [6]  = "Number_3;16818.53125;-370.69644165039;-17566.57421875;sprFloater_Critical3",
      [7]  = "Number_1;16758.015625;-370.69497680664;-17506.205078125;sprFloater_Critical1",
      [8]  = "North;16813.361328125;-366.65243530273;-17665.01171875;MagicMarkersSprites:LetterN_256",
      [9]  = "West;16755.8203125;-366.84378051758;-17605.662109375;MagicMarkersSprites:LetterW_256",
      [10] = "East;16836.908203125;-366.31011962891;-17579.837890625;MagicMarkersSprites:LetterE_256",
      [11] = "South;16780.10546875;-364.60528564453;-17519.517578125;MagicMarkersSprites:LetterS_256",
      [12] = "Pig;16799.857421875;-370.7004699707;-17513.958984375;Icon_Windows_UI_CRB_Marker_Pig",
      [13] = "UFO;16800.41796875;-370.69464111328;-17686.16796875;Icon_Windows_UI_CRB_Marker_UFO",
      [14] = "Number_4;16757.890625;-370.70269775391;-17566.7890625;sprFloater_Critical4",
      [15] = "Number_2;16818.01171875;-370.69467163086;-17506.880859375;sprFloater_Critical2",
      [16] = "Number_5;16826.384765625;-370.69201660156;-17635.228515625;sprFloater_Critical5",
      [17] = "Number_6;16758.177734375;-370.70462036133;-17635.1328125;sprFloater_Critical6",
      [18] = "Number_7;16757.642578125;-370.69705200195;-17686.470703125;sprFloater_Critical7",
      [19] = "Number_8;16826.857421875;-370.69714355469;-17686.162109375;sprFloater_Critical8"
    }
  },
  [7] = {
    name = "Maelstrom Authority",
    markers = {
      [1] = "North;7290.00000;-250.00000;-13120.00000;MagicMarkersSprites:LetterN_256",
      [2] = "West;7040.0000;-250.00000;-12600.00000;MagicMarkersSprites:LetterW_256",
      [3] = "East;7530.0000;-250.00000;-12600.00000;MagicMarkersSprites:LetterE_256",
      [4] = "South;7290.00000;-250.00000;-12080.00000;MagicMarkersSprites:LetterS_256"
    }
  },
  [8] = {
    name = "Core Y-83",
    markers = {
      [1] = "Bomb;2814.2836914063;-448.78671264648;-105.99939727783;Icon_Windows_UI_CRB_Marker_Bomb",
      [2] = "Chicken;2774.5405273438;-448.78659057617;-108.68078613281;Icon_Windows_UI_CRB_Marker_Chicken",
      [3] = "Ghost;2791.1359863281;-448.78634643555;-145.60018920898;Icon_Windows_UI_CRB_Marker_Ghost",
      [4] = "UFO;2814.9113769531;-448.78454589844;-126.84462738037;Icon_Windows_UI_CRB_Marker_UFO",
      [5] = "Planet;1252.095703125;-800.50634765625;885.97393798828;MagicMarkersSprites:Planet_256",
      [6] = "Star;1268.5686035156;-800.50775146484;859.26635742188;MagicMarkersSprites:Star_256",
      [7] = "Moon;1283.7844238281;-800.50982666016;886.46051025391;MagicMarkersSprites:Moon_256",
      [8] = "Number_1;1242.1364746094;-800.51348876953;815.38665771484;sprFloater_Critical1",
      [9] = "Number_3;1268.6258544922;-800.50445556641;800.20007324219;sprFloater_Critical3",
      [10] = "Number_2;1294.5014648438;-800.50897216797;815.40576171875;sprFloater_Critical2",
      [11] = "Number_4;1334.7492675781;-800.51428222656;885.82275390625;sprFloater_Critical4",
      [12] = "Number_6;1335.1800537109;-800.51544189453;915.98394775391;sprFloater_Critical6",
      [13] = "Number_5;1308.4053955078;-800.51605224609;931.09381103516;sprFloater_Critical5",
      [14] = "Number_7;1227.3753662109;-800.5107421875;931.19451904297;sprFloater_Critical7",
      [15] = "Number_9;1200.9818115234;-800.50347900391;914.85766601563;sprFloater_Critical9",
      [16] = "Number_8;1201.0769042969;-800.51275634766;885.13397216797;sprFloater_Critical8"
    }
  }
}

local tDefaultSettings = {
  version = MAGICMARKERS_CURRENT_VERSION,
  user = {
    savedWndLoc = {}
  },
  options = {
    shareMarkerRaid = true,
    shareMarekrParty = true,
    frameSkip = 2,
    buttons = {
      w = 48,
      h = 48
    }
  },
  savedProfiles = {}
}

local tDefaultState = {
  isOpen = false,
  isOptionsOpen = false,
  isLoaded = false,
  frameCount = 0,
  windows = {
    main = nil,
    options = nil,
    overlay = nil
  },
  channel = {
    attemptsCount = 0,
    timerActive = false,
    ready = false
  },
  width2 = 1,
  height2 = 1,
  activeMarkers = {},
  debug = false,
  messageQueue = {}

}

-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------
function MagicMarkers:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self

  -- Saved and Restored values are stored here.
  o.settings = deepcopy(tDefaultSettings)
  -- Volatile values are stored here. These are impermenant and not saved between sessions
  o.state = deepcopy(tDefaultState)

  return o
end

function MagicMarkers:Init()
  self.state.isLoaded = false
  local bHasConfigureFunction = false
  local strConfigureButtonText = ""
  local tDependencies = {
    "Gemini:Logging-1.2"
  }

  Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)

  -- Saved and Restored values are stored here.
  self.settings = deepcopy(tDefaultSettings)
  -- Volatile values are stored here. These are impermenant and not saved between sessions
  self.state = deepcopy(tDefaultState)
end

-----------------------------------------------------------------------------------------------
-- MagicMarkers OnLoad
-----------------------------------------------------------------------------------------------
function MagicMarkers:OnLoad()
  local GeminiLogging = Apollo.GetPackage("Gemini:Logging-1.2").tPackage
  log = GeminiLogging:GetLogger({
     level = GeminiLogging.INFO,
      pattern = "%l - %m",
      appender = "GeminiConsole"
  })

  Apollo.LoadSprites("MagicMarkersSprites.xml")

  -- load our form file
  self.xmlDoc = XmlDoc.CreateFromFile("MagicMarkers.xml")
  self.xmlDoc:RegisterCallback("OnDocLoaded", self)
  self.state.timerActive = true

  -- Load Utils
  Utils = Apollo.GetPackage("SimpleUtils-1.0").tPackage

  -- Interface Menu
  Apollo.RegisterEventHandler("Generic_ToggleMagicMarkers", "OnToggleMagicMarkers", self)
  Apollo.RegisterEventHandler("InterfaceMenuListHasLoaded", "OnInterfaceMenuListHasLoaded", self)
end

-----------------------------------------------------------------------------------------------
-- MagicMarkers OnDocLoaded
-----------------------------------------------------------------------------------------------
function MagicMarkers:OnDocLoaded()
  if self.xmlDoc == nil then
    return
  end

  self.shareChannel = nil

  self.state.windows.main = Apollo.LoadForm(self.xmlDoc, "MagicMarkers", nil, self)
  self.state.windows.options = Apollo.LoadForm(self.xmlDoc, "MagicMarkersOptions", nil, self)
  self.state.windows.overlay = Apollo.LoadForm(self.xmlDoc, "Overlay", nil, self)
  if self.state.windows.main == nil then
    Apollo.AddAddonErrorText(self, "Could not load the main window for some reason.")
    return
  end

  -- Setup Comms
  Apollo.RegisterTimerHandler("MagicMarkers_UpdateCommChannel", "UpdateCommChannel", self)
  CommChannelTimer = ApolloTimer.Create(5, false, "UpdateCommChannel", self) -- make sure everything is loaded, so after 5sec

  -- Register handlers for events, slash commands and timer, etc.
  Apollo.RegisterSlashCommand("mm", "OnMagicMarkersOn", self)

  -- This update event is smooth, but probably horribly inefficient
  Apollo.RegisterEventHandler("NextFrame", "OnNextFrame", self)

  -- Do additional Addon initialization here
  self.state.windows.main:Show(self.state.isOpen, true)
  self.state.windows.options:Show(self.state.isOptionsOpen, true)
  self.state.isLoaded = true
end

-----------------------------------------------------------------------------------------------
-- MagicMarkers OnInterfaceMenuListHasLoaded
-----------------------------------------------------------------------------------------------
function MagicMarkers:OnInterfaceMenuListHasLoaded()
  Event_FireGenericEvent("InterfaceMenuList_NewAddOn", "MagicMarkers", {"Generic_ToggleMagicMarkers", "", "MagicMarkersSprites:Marker_256"})
  Event_FireGenericEvent("OneVersion_ReportAddonInfo", "MagicMarkers", Major, Minor, Patch, Suffix, false)
end

-----------------------------------------------------------------------------------------------
-- MagicMarkers Functions
-----------------------------------------------------------------------------------------------
-- Define general functions here

-- on SlashCommand "/mm"
function MagicMarkers:OnMagicMarkersOn(cmd, params)
  p = string.lower(params)
  args = p:split("[ ]+")
  local cmd = args[1]
  if cmd == "defaults" then
    self:LoadDefaultProfiles()
  elseif cmd == "debug" then
    self.state.debug = not self.state.debug
    Utils:cprint("Debug Mode: " .. tostring(self.state.debug))
  else
    self:OnToggleMagicMarkers()
  end
end

---------------------------------------------------------------------------------------------------
-- MagicMarkers General UI Functions
---------------------------------------------------------------------------------------------------
function MagicMarkers:OnToggleMagicMarkers()
  if self.state.isOpen == true then
    self.state.isOpen = false
    self:SaveLocation()
    self:CloseMain()
  else
    self.state.isOpen = true
    self.state.windows.main:Invoke() -- show the window
  end
end

function MagicMarkers:OnMagicMarkersClose()
  self.state.isOpen = false
  self:SaveLocation()
  self:CloseMain()
end

-----------------------------------------------------------------------------------------------
-- MagicMarkers OnMove
-----------------------------------------------------------------------------------------------
function MagicMarkers:OnMagicMarkersMove()
  self:SaveLocation()
end

function MagicMarkers:SaveLocation()
  self.settings.user.savedWndLoc = self.state.windows.main:GetLocation():ToTable()
end

function MagicMarkers:CloseMain()
  self.state.windows.main:Close()
end

function MagicMarkers:RefreshUI()
  if self.settings.user.savedWndLoc and self.state.isLoaded then
    locSavedLoc = WindowLocation.new(self.settings.user.savedWndLoc)
    self.state.windows.main:MoveToLocation(locSavedLoc)
  end
end

-- on timer
function MagicMarkers:OnNextFrame()
  if self.state.isLoaded then
    self.state.frameCount = self.state.frameCount + 1
    -- Only update every Nth frame
    if self.state.frameCount == nil then self.state.frameCount = 0 end

    if (self.state.frameCount > self.settings.options.frameSkip) then
      self.state.frameCount = 0
      self:DrawMarkers()
    end
  end
end

function MagicMarkers:DrawMarkers()
  for key, marker in pairs(self.state.activeMarkers) do
    local pixie = self:GenerateMarkerPixie(marker, self.state.width2, self.state.height2)
    self.state.windows.overlay:UpdatePixie(marker.pixieId, pixie)
  end
end

-----------------------------------------------------------------------------------------------
-- MagicMarkers Marker Functions
-----------------------------------------------------------------------------------------------
function MagicMarkers:SetMarker(marker, loc)
  -- clear old position
  local index = self:GetMarkerIndex(marker)
  if index ~= nil then
    self:ClearMarker(self.state.activeMarkers[index])
    table.remove(self.state.activeMarkers, index)
  end

  -- set new marker
  marker.location = loc
  local pixie = self:GenerateMarkerPixie(marker, self.state.width2, self.state.height2)
  marker.pixieId = self.state.windows.overlay:AddPixie(pixie) -- safe pixie id for position updates
  table.insert(self.state.activeMarkers, marker)

  self.state.markerToSet = nil
  self.state.setMarkers = false
end

function MagicMarkers:ClearMarker(marker)
  if marker.pixieId ~= nil then
    self.state.windows.overlay:DestroyPixie(marker.pixieId)
    marker.pixieId = nil
    marker.location = nil
  end
end

-----------------------------------------------------------------------------------------------
-- MagicMarkersForm Communication Functions
-----------------------------------------------------------------------------------------------
function MagicMarkers:ShareMarker(marker)
  if GroupLib.GetMemberCount() > 0 then
    msg = self:MarkerToString(marker)
    -- Sends the Markers to the Raid
    if self.settings.options.shareMarkerRaid and GroupLib.InRaid() and RaidMemberHelper:CanMark() then
      self:DBPrint("(ShareRaid) " .. msg)
      self:SendMessage(msg)
    end
    -- Sends the Markers to the Party
    if self.settings.options.shareMarkerParty and GroupLib.InGroup() and not GroupLib.InRaid() then
      self:DBPrint("(ShareParty) " .. msg)
      self:SendMessage(msg)
    end
  end
end

function MagicMarkers:OnReceiveMarker(chan, msg)
  local markerInfo = self:GetMarkerInfoFromString(msg)
  if not markerInfo then
    self:SetMarker(markerInfo, markerInfo.loc)
    self:DBPrint("(RecieveMarker) " .. msg)
  else -- Message to reset all markers
    self:ResetAllMarker()
  end
end

function MagicMarkers:UpdateCommChannel()
  if not self.shareChannel then
    self:DBPrint(" InitComms")
    self.shareChannel = ICCommLib.JoinChannel(CommChannelName, ICCommLib.CodeEnumICCommChannelType.Group)
    self.shareChannel:SetJoinResultFunction("OnCommJoin", self)
  end

  if self.shareChannel:IsReady() then
    self:DBPrint(" Channel is ready." )
    self.shareChannel:SetReceivedMessageFunction("OnReceiveMarker", self)
    self.shareChannel:SetSendMessageResultFunction("OnMessageSent", self)
    self.shareChannel:SetThrottledFunction("OnChannelThrottle", self)
    self.state.channel.ready = true

    -- Check the message queue and push waiting messages
    while #self.state.messageQueue > 0 do
      self:SendMessage(self.state.messageQueue[1])
      table.remove(self.state.messageQueue, 1)
    end
  else
    self:DBPrint(" Channel is not ready, retrying.")
    -- Channel not ready yet, repeat in a few seconds
    if self.state.channel.attemptsCount < MaxCommAttempts then
      self.state.timerActive = true
      Apollo.CreateTimer("MagicMarkers_UpdateCommChannel", CommAttemptDelay, false)
      Apollo.StartTimer("MagicMarkers_UpdateCommChannel")
    else
      -- Comms disabled, send alert
      self.state.timerActive = false
      Utils:cprint("[MagicMarkers] Could not initialize comm channel. Group Comm channels appear to be disabled -- please open a ticket with Carbine.")
    end
    -- Increment the number of attempts
    self.state.channel.attemptsCount = self.state.channel.attemptsCount + 1
  end
end

function MagicMarkers:SendMessage(msg)
  self:DBPrint("(SendMessage)" .. msg )
  if not self.shareChannel or not self.state.channel.ready then
    -- Reinitialize only if the timer is not active
    if not self.state.timerActive then
      self:DBPrint(" Error sending Markers. Attempting to fix this now.")
      -- Attempt to re-initialize chanel
      self.state.channel.attemptsCount = 0
      self:UpdateCommChannel()
    end
    -- Queue the message
    table.insert(self.state.messageQueue, msg)
    return false
  else
    return self.shareChannel:SendMessage(msg)
  end
end

function MagicMarkers:OnCommJoin(channel, eResult)
  self:DBPrint( string.format("(JoinResult) %s:%s", channel:GetName(), tostring(eResult)) )
end

function MagicMarkers:OnMessageSent(channel, eResult, idMessage)
  self:DBPrint( string.format("(MessageResult) %s:%s", channel:GetName(), tostring(eResult)) )
end

function MagicMarkers:OnChannelThrottle(channel, strSender, idMessage)
  self:DBPrint( string.format("(ChannelThrottle) %s:%s:%s", channel:GetName(), strSender, tostring(idMessage) ) )
end

-----------------------------------------------------------------------------------------------
-- MagicMarkersForm Helper Functions
-----------------------------------------------------------------------------------------------
function MagicMarkers:GetMarkerIndex(marker)
  local index = 0
  for i = 1, table.getn(self.state.activeMarkers) do
    if self.state.activeMarkers[i].name == marker.name then
      return i
    end
  end
  return
end

-- copied from WorldMarkers
function MagicMarkers:GenerateMarkerPixie(marker, xoffset, yoffset)
  local loc =  GameLib.WorldLocToScreenPoint(marker.location)
  return {
    strSprite = marker.sprite,
    cr = "FFFFFFFF",
    loc = {
      fPoints = { 0, 0, 0, 0 },
      nOffsets = {
        loc.x-(xoffset),
        loc.y-(yoffset),
        loc.x+(xoffset),
        loc.y+(yoffset)
      }
    }
  }
end

function MagicMarkers:MarkerToString(marker)
  return marker.name .. ";" .. marker.location.x .. ";"
      .. marker.location.y .. ";" .. marker.location.z
      .. ";" .. marker.sprite
end

function MagicMarkers:GetMarkerInfoFromString(str)
  local marker = {}
  local counter = 1

  if string.find(str, "clear-all") then
    return nil
  else
    for coord in string.gmatch(str, '([^;]+)') do
        marker[counter] = coord
      counter = counter + 1
    end

    return {
      loc = Vector3.New(marker[2],marker[3],marker[4]),
      name = marker[1],
      sprite = marker[5]
    }
  end
end

-----------------------------------------------------------------------------------------------
-- MagicMarkers Options Window
-----------------------------------------------------------------------------------------------
function MagicMarkers:ShowOptions(wndHandler, wndControl, eMouseButton)
  if self.state.isOptionsOpen then
    self.state.isOptionsOpen = false

  else
    self.state.isOptionsOpen = true
    self:LoadMarkerOptions(wndHandler, self.state.windows.options:FindChild("Marker"), eMouseButton)
  end
  self.state.windows.options:Show(self.state.isOptionsOpen, true)
end

function MagicMarkers:LoadMarkerOptions(wndHandler, wndControl, eMouseButton)
  local optionStr = "Marker"
  self.state.windows.options:FindChild("Options"):FindChild("OptionsTitle"):SetText(optionStr)
  local container = self.state.windows.options:FindChild("Options"):FindChild("OptionContainer")
  container:DestroyChildren()
  local form = Apollo.LoadForm(self.xmlDoc, "MarkerOptions", container, self)
  form:FindChild("MarkerSize"):SetText(self.settings.options.buttons.w)
  form:FindChild("ShareRaid"):SetCheck(self.settings.options.shareMarkerRaid)
  form:FindChild("ShareParty"):SetCheck(self.settings.options.shareMarkerParty)
  form:FindChild("FrameSkip"):FindChild("Text"):SetText(self.settings.options.frameSkip)
end

function MagicMarkers:OnChangeMarkerSize(wndHandler, wndControl, strText)
  local value = tonumber(strText)
  if value ~= nil then
    self.settings.options.buttons.w = value
    self.settings.options.buttons.h = value
    self.state.width2 = bit32.rshift(self.settings.options.buttons.w,1)
    self.state.height2 = bit32.rshift(self.settings.options.buttons.w,1)
  else
    wndControl:SetText(tostring(self.settings.options.buttons.w))
  end
end

function MagicMarkers:OnChangeShareMarkerRaid(wndHandler, wndControl, eMouseButton)
  self.settings.options.shareMarkerRaid = wndControl:IsChecked()
end

function MagicMarkers:OnChangeShareMarkerParty(wndHandler, wndControl, eMouseButton)
  self.settings.options.shareMarkerParty = wndControl:IsChecked()
end

function MagicMarkers:LoadProfileOptions()
  local optionStr = "Profile"
  self.state.windows.options:FindChild("Options"):FindChild("OptionsTitle"):SetText(optionStr)
  local container = self.state.windows.options:FindChild("Options"):FindChild("OptionContainer")
  container:DestroyChildren()
  Apollo.LoadForm(self.xmlDoc, "ProfileSave", container, self)
  self:AddProfileList(container)
end

function MagicMarkers:AddProfileList(container)
  for _, profile in pairs(self.settings.savedProfiles) do
    local selectProfile = Apollo.LoadForm(self.xmlDoc, "Profile", container, self)
    selectProfile:FindChild("LoadProfile"):SetText(profile.name)
  end
  container:ArrangeChildrenVert()
end

function MagicMarkers:SaveCurrentMarkers(wndHandler, wndControl, eMouseButton)
  local profileName  = wndControl:GetParent():FindChild("ProfileName"):GetText()
  local somethingToSave = false
  -- profile name has to contain at least one charachter
  if profileName ~= nil and profileName ~= "" then
    local markersToSave = {}
    for _,marker in pairs(self.state.activeMarkers) do
      table.insert(markersToSave, self:MarkerToString(marker))
    end
    if table.getn(markersToSave) > 0 then
      local profile = {
          name = profileName,
          markers = markersToSave
      }
      local index = self:GetProfileIndex(profileName)
      if index ~= nil then
        self.settings.savedProfiles[index] = profile
      else
        table.insert(self.settings.savedProfiles, profile)
      end
      if self.state.isOptionsOpen then
        self:LoadProfileOptions()
      end
    end
  end
end

function MagicMarkers:DeleteProfile(wndHandler, wndControl, eMouseButton)
  local profileName  = wndControl:GetParent():FindChild("LoadProfile"):GetText()
  local index = self:GetProfileIndex(profileName)
  local counter = 1
  table.remove(self.settings.savedProfiles, index)
  self:LoadProfileOptions()
end

function MagicMarkers:LoadProfile(wndHandler, wndControl, eMouseButton)
  local profileName  = wndControl:GetText()
  local profile
  for key, temp in pairs(self.settings.savedProfiles) do
    if temp.name == profileName then
      profile = temp
    end
  end
  self:ResetAllMarker()
  for key, markerString in pairs(profile.markers) do
    local markerInfo = self:GetMarkerInfoFromString(markerString)
    local marker = {
      name = markerInfo.name,
      sprite = markerInfo.sprite,
      loc = markerInfo.loc
    }

    self:SetMarker(marker, markerInfo.loc)

    self:ShareMarker(marker)
  end
end

function MagicMarkers:DecFrameSkip( wndHandler, wndControl, eMouseButton )
  local par = wndHandler:GetParent()
  local txt = par:FindChild("Text")
  local str = txt:GetText()
  local value = tonumber(str)
  if value ~= nil then
    if value > 0 then
      value = value - 1
    end
  else
    value = 0
  end
  txt:SetText(tostring(value))
  self.settings.options.frameSkip = value
end

function MagicMarkers:IncFrameSkip( wndHandler, wndControl, eMouseButton )
  local par = wndHandler:GetParent()
  local txt = par:FindChild("Text")
  local str = txt:GetText()
  local value = tonumber(str)
  if value ~= nil then
    if value < 20 then
      value = value + 1
    end
  else
    value = 0
  end
  txt:SetText(tostring(value))
  self.settings.options.frameSkip = value
end

function MagicMarkers:GetProfileIndex(profileName)
  local index = nil
  local counter = 1
  for _, temp in pairs(self.settings.savedProfiles) do
    if temp.name == profileName then
      index = counter
    end
    counter = counter + 1
  end
  return index
end

-----------------------------------------------------------------------------------------------
-- MagicMarkers Bar functions
-----------------------------------------------------------------------------------------------
function MagicMarkers:ActivateMarker(wndHandler, wndControl, eMouseButton)
  self.state.setMarker = true
  self.state.markerToSet = wndControl:GetName()

  local marker = markers[self.state.markerToSet]
  local pos = GameLib.GetPlayerUnit():GetPosition()
  local vec = Vector3.New(pos.x, pos.y, pos.z)
  self:SetMarker(marker, vec)

  self:ShareMarker(marker)
end

function MagicMarkers:ResetMarker(wndHandler, wndControl, eMouseButton)
  local btnName = wndControl:GetName()
  local markerStr  = string.gsub(wndControl:GetName(), "Reset", "")
  local marker = markers[markerStr]
  self:ClearMarker(marker)
  table.remove(self.state.activeMarkers, self:GetMarkerIndex(marker)
)
end

function MagicMarkers:OnResetAllMarker()
  if GroupLib.GetMemberCount() > 0 then
    -- Sends the all clear to the raid
    if self.settings.options.shareMarkerRaid and GroupLib.InRaid() and RaidMemberHelper:CanMark() then
      self:DBPrint("(ShareRaid) Clear-All")
      self:SendMessage("clear-all")
    end
  end
  self:ResetAllMarker()
end

function MagicMarkers:ResetAllMarker()
  for key, marker in pairs(self.state.activeMarkers) do
    self:ClearMarker(marker)
  end
  self.state.activeMarkers = {}
end

-----------------------------------------------------------------------------------------------
-- MagicMarkers Event Handler
-----------------------------------------------------------------------------------------------
function MagicMarkers:OnSave(eType)
  if eType ~= GameLib.CodeEnumAddonSaveLevel.Character then return end
  return deepcopy(self.settings)
end

function MagicMarkers:OnRestore(eType, tSavedData)
  if eType ~= GameLib.CodeEnumAddonSaveLevel.Character then return end

  if tSavedData and tSavedData.user then
    -- Copy the settings wholesale
    self.settings = deepcopy(tSavedData)

    -- Convert old settings
    if self.settings.user.version ~= MAGICMARKERS_CURRENT_VERSION then
      if self.settings.options.shareMarker then
        self.settings.options.shareMarkerRaid = self.settings.options.shareMarker
      else
        self.settings.options.shareMarkerRaid = true
      end
      if self.settings.options.shareMarkerParty == nil then
        self.settings.options.shareMarkerParty = true
      end
      if self.settings.options.frameSkip == nil then
        self.settings.options.frameSkip = 2
      end
      self.settings.options.shareMarker = nil
    end

    -- Fill in any missing values from the default options
    -- This Protects us from configuration additions in the future versions
    for key, value in pairs(tDefaultSettings) do
      if self.settings[key] == nil then
        self.settings[key] = deepcopy(tDefaultSettings[key])
      end
    end

    -- Check to see if there are any profiles, if there are not then load the default profiles
    if #self.settings.savedProfiles <= 0 then
      self.settings.savedProfiles = deepcopy(tDefaultProfiles)
    end

    self.settings.user.version = MAGICMARKERS_CURRENT_VERSION
    self.state.width2 = bit32.rshift(self.settings.options.buttons.w,1)
    self.state.height2 = bit32.rshift(self.settings.options.buttons.w,1)

    self:RefreshUI()
  end
end

function MagicMarkers:LoadDefaultProfiles()
  self.settings.savedProfiles = deepcopy(tDefaultProfiles)
  self:LoadProfileOptions()
end

function MagicMarkers:DBPrint(msg)
  if self.settings.user.debug then
    Utils:debug( "[MagicMarkers]" .. msg )
  end
end

-----------------------------------------------------------------------------------------------
-- MagicMarkers Instance
-----------------------------------------------------------------------------------------------
local MagicMarkersInst = MagicMarkers:new()
MagicMarkersInst:Init()
