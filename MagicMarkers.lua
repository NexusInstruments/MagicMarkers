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
require "Apollo"

-----------------------------------------------------------------------------------------------
-- MagicMarkers Module Definition
-----------------------------------------------------------------------------------------------
local MagicMarkers = {}
local Utils = Apollo.GetPackage("SimpleUtils-1.0").tPackage
local log

local MAGICMARKERS_CURRENT_VERSION = "1.1.1"

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
  activeMarkers = {}
}

-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------
function MagicMarkers:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self

  -- Saved and Restored values are stored here.
  o.settings = shallowcopy(tDefaultSettings)
  -- Volatile values are stored here. These are impermenant and not saved between sessions
  o.state = shallowcopy(tDefaultState)

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
  self.settings = shallowcopy(tDefaultSettings)
  -- Volatile values are stored here. These are impermenant and not saved between sessions
  self.state = shallowcopy(tDefaultState)
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

  -- Load Utils
  Utils = Apollo.GetPackage("SimpleUtils-1.0").tPackage

  -- Setup Comms
  self.shareChannelRaid = ICCommLib.JoinChannel("MagicMarkersRaid", ICCommLib.CodeEnumICCommChannelType.Raid)
  self.shareChannelRaid:SetReceivedMessageFunction("OnReceiveMarker", self)

  self.shareChannelParty = ICCommLib.JoinChannel("MagicMarkersParty", ICCommLib.CodeEnumICCommChannelType.Party)
  self.shareChannelParty:SetReceivedMessageFunction("OnReceiveMarker", self)

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

  self.state.windows.main = Apollo.LoadForm(self.xmlDoc, "MagicMarkers", nil, self)
  self.state.windows.options = Apollo.LoadForm(self.xmlDoc, "MagicMarkersOptions", nil, self)
  self.state.windows.overlay = Apollo.LoadForm(self.xmlDoc, "Overlay", nil, self)
  if self.state.windows.main == nil then
    Apollo.AddAddonErrorText(self, "Could not load the main window for some reason.")
    return
  end

  -- Register handlers for events, slash commands and timer, etc.
  Apollo.RegisterSlashCommand("mm", "OnMagicMarkersOn", self)

  -- This update event is strange, and fires off intermittently
  -- Apollo.RegisterEventHandler("VarChange_FrameCount", "OnNextFrame", self)
  -- This update event is smooth, but probably horribly inefficient
  Apollo.RegisterEventHandler("NextFrame", "OnNextFrame", self)
  -- This update event is customizable, but still doesn't fix fps lag
  --self.timerFreq = .03
  --self.frameTimer = ApolloTimer.Create(self.timerFreq, true, "OnNextFrame", self)

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
end

function MagicMarkers:SetSpritesForButtons()
  sprite = {}
  sprite.w = 34
  sprite.h = 34

  for i = 1, self.markers do
    local marker = self.markers[i]
    lof:info("Set marker " .. marker[0])
  end
end

-----------------------------------------------------------------------------------------------
-- MagicMarkers Functions
-----------------------------------------------------------------------------------------------
-- Define general functions here

-- on SlashCommand "/mm"
function MagicMarkers:OnMagicMarkersOn(cmd, params)
  p = string.lower(params)
  args = p:split("[ ]+")

  if args[1] == "defaults" then
    self:LoadDefaultProfiles()
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
  if self.settings.user.savedWndLoc then
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
    local pixie = self:GenerateMarkerPixie(marker)
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
  local pixie = self:GenerateMarkerPixie(marker)
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
    if self.settings.options.shareMarkerRaid then
      self.shareChannelRaid:SendMessage(msg)
    end
    -- Sends the Markers to the Party
    if self.settings.options.shareMarekrParty then
      self.shareChannelParty:SendMessage(msg)
    end
  end
end

function MagicMarkers:OnReceiveMarker(chan, msg)
  local markerInfo =	self:GetMarkerInfoFromString(msg)
  self:SetMarker(markerInfo, markerInfo.loc)
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
function MagicMarkers:GenerateMarkerPixie(marker)
  local loc =  GameLib.WorldLocToScreenPoint(marker.location)
  local w = self.settings.options.buttons.w /2
  local h = self.settings.options.buttons.h /2
  return {
    strSprite = marker.sprite,
    cr = "FFFFFFFF",
    loc = {
      fPoints = { 0, 0, 0, 0 },
      nOffsets = {
        loc.x-(w),
        loc.y-(h),
        loc.x+(w),
        loc.y+(h)
      }
    }
  }
end

function MagicMarkers:MarkerToString(marker)
  return marker.name .. ";" .. marker.location.x .. ";"
      .. marker.location.y .. ";" .. marker.location.z
      .. ";" .. marker.sprite
end

function MagicMarkers:GetMarkerInfoFromString(string)
  local marker = {}
  local counter = 1
  for coord in string.gmatch(string, '([^;]+)') do
      marker[counter] = coord
    counter = counter + 1
  end

  return {
    loc = Vector3.New(marker[2],marker[3],marker[4]),
    name = marker[1],
    sprite = marker[5]
  }
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
    if self.settings.user.version == "1.0.0" then
      self.settings.options.shareMarkerRaid = self.settings.options.shareMarker
      self.settings.options.shareMarkerParty = true
      self.settings.options.frameSkip = 2
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

    self:RefreshUI()
  end
end

function MagicMarkers:LoadDefaultProfiles()
  self.settings.savedProfiles = deepcopy(tDefaultProfiles)
  self:LoadProfileOptions()
end

-----------------------------------------------------------------------------------------------
-- MagicMarkers Instance
-----------------------------------------------------------------------------------------------
local MagicMarkersInst = MagicMarkers:new()
MagicMarkersInst:Init()
