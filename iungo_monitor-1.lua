-- IUNGO MONITOR 

-- This Quickapp retrieves power consumption, solar production, gas usage and water flow from the Iungo Monitor, Solarpanel and Watermeter

-- (Child) Devices for Net Consumption, House Consumption, Solar Production, Solar Power, Water Flow, Consumption High, Consumption Low, Production High, Production Low, Total Gas and Total Water FLow


-- TODO
-- Counter from period
-- Finetuning interval between loops

-- Version 1.0 (6th February 2021)
-- Now also supports Iungo Solarpanel and Iungo Watermeter
-- Added a lot of Child devices
-- Added QuickApp Variable for user defined icon Mother Device
-- Added QuickApp Variable for Solar Power m2
-- Removed calculation and storage of energy consumption of Fibaro devices


-- Version 0.6 (22th January 2021)
-- Now also supports Iungo basic version

-- Version 0.5 (21th January 2021)
-- Initial version


-- Variables (mandatory and automaticaly generated): 
-- IPaddress = IP address of your Iungo Monitor
-- solarPanel = true or false for use of the SolarPanel module (default is false)
-- waterMeter = true or false for use of the Watermeter module (default is false)
-- interval = Number in seconds, the Lungo Monitor normally is updated every 10 seconds
-- solarM2 = The amount of m2 Solar Panels (use . for decimals) for calculating Solar Power m2
-- debugLevel = Number (1=some, 2=few, 3=all, 4=simulation mode) (default = 1)
-- icon = User defined icon number (add the icon via an other device and lookup the number, like 1020)


-- No editing of this code is needed 


class 'consumption'(QuickAppChild)
function consumption:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Consumption QuickappChild initiated, deviceId:",self.id)
end
function consumption:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.0f", data.net_consumption)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "Tarif: " ..data.tarifcodeText)
end


class 'production'(QuickAppChild)
function production:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Production QuickappChild initiated, deviceId:",self.id)
end
function production:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.0f", data.solar)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", data.meterreading .." kWh")
end


class 'solarPower'(QuickAppChild)
function solarPower:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("solarPower QuickappChild initiated, deviceId:",self.id)
end
function solarPower:updateValue(data) 
  self:updateProperty("value", tonumber(data.solarPower))
  self:updateProperty("unit", "Watt/m²")
  self:updateProperty("log", "")
end


class 'waterflow'(QuickAppChild)
function waterflow:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Waterflow QuickappChild initiated, deviceId:",self.id)
end
function waterflow:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.0f",data.flow)))
  self:updateProperty("unit", "m³")
  self:updateProperty("log", "")
end


class 'consumption_high'(QuickAppChild)
function consumption_high:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("consumption_high QuickappChild initiated, deviceId:",self.id)
end
function consumption_high:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption_high)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", "")
end


class 'consumption_low'(QuickAppChild)
function consumption_low:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("consumption_low QuickappChild initiated, deviceId:",self.id)
end
function consumption_low:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption_low)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", "")
end

class 'production_high'(QuickAppChild)
function production_high:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("production_high QuickappChild initiated, deviceId:",self.id)
end
function production_high:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production_high)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", "")
end


class 'production_low'(QuickAppChild)
function production_low:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("production_low QuickappChild initiated, deviceId:",self.id)
end
function production_low:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production_low)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", "")
end


class 'gas'(QuickAppChild)
function gas:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("gas QuickappChild initiated, deviceId:",self.id)
end
function gas:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.gas)))
  self:updateProperty("unit", "m³")
  self:updateProperty("log", "")
end


class 'total_waterflow'(QuickAppChild)
function total_waterflow:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("total_waterflow QuickappChild initiated, deviceId:",self.id)
end
function total_waterflow:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.wused)))
  self:updateProperty("unit", "m³")
  self:updateProperty("log", "")
end


local function getChildVariable(child,varName)
  for _,v in ipairs(child.properties.quickAppVariables or {}) do
    if v.name==varName then return v.value end
  end
  return ""
end


-- QuickApp Functions


function QuickApp:button1Event() -- Refresh button event
  self:updateView("button1", "text", "Please wait...")
  self:onInit()
  fibaro.setTimeout(3000, function()
    self:updateView("button1", "text", "Update Devicelist")
  end)
end


function QuickApp:solarPower(power, m2) -- Calculate Solar Power M2
  self:logging(3,"Start solarPower")
  if m2 > 0 and power > 0 then
    solarPower = power / m2
  else
    solarPower = 0
  end
  return solarPower
end


function QuickApp:updateLabels() -- Update the labels 
  local labelText = ""
  if solarPanel then
    labelText = labelText .."Net Consumption: " ..data.net_consumption .." Watt / tarif: (" ..data.tarifcodeText ..")" .."\n"
    labelText = labelText .."House Consumption: " ..data.consumption .." Watt" .."\n"
    labelText = labelText .."Solar Production: " ..data.solar .." Watt" .."\n"
  else
    labelText = labelText .."Consumption: " ..data.consumption .." Watt / tarif: (" ..data.tarifcodeText ..")" .."\n"
  end
  labelText = labelText .."\n" .."Totals:" .."\n"
  labelText = labelText .."Consumption high: " ..data.consumption_high .." kWh" .."\n" 
  labelText = labelText .."Consumption low: " ..data.consumption_low .." kWh" .."\n"
  labelText = labelText .."Consumption total: " ..data.total_consumption .." kWh" .."\n" 
  if solarPanel then
    labelText = labelText .."Solar Meterreading: " ..data.meterreading .." kWh" .."\n"
  end
  labelText = labelText .."Production high: " ..data.production_high .." kWh" .."\n" 
  labelText = labelText .."Producton low: " ..data.production_low .." kWh" .."\n"
  labelText = labelText .."Production total: " ..data.total_production .." kWh" .."\n"
  labelText = labelText .."Gas: " ..data.gas .." m³" .."\n"
  if waterMeter then
    labelText = labelText .."Water: " ..data.wused .." m³" .."\n"
  end
  if solarPanel then
    labelText = labelText .."\n" .."Solar:" .."\n"
    labelText = labelText .."Production: " ..data.solar .." Watt" .."\n"
    labelText = labelText .."Power: " ..data.solarPower .." Watt/m²" .."\n"
  end
  if waterMeter then
    labelText = labelText .."\n" .."Water:" .."\n"
    labelText = labelText .."Waterflow: " ..data.flow .." m³" .."\n"
  end
  
  self:updateView("label1", "text", labelText)
  self:logging(2,labelText)
end


function QuickApp:valuesWater() -- Update the Water values from json file
  data.flow = jsonTableWater.rv.propsval[2].value
  data.pulstotal = jsonTableWater.rv.propsval[3].value
  data.kfact = jsonTableWater.rv.propsval[4].value 
  data.offset = jsonTableWater.rv.propsval[5].value
  data.wused = data.pulstotal/data.kfact+data.offset
end


function QuickApp:valuesSolar() -- Update the Solar values from json file
  data.solar = string.format("%.1f",jsonTableSolar.rv.propsval[2].value)
  data.pulstotal = string.format("%.3f",jsonTableSolar.rv.propsval[3].value)
  data.ppkwh = string.format("%.3f",jsonTableSolar.rv.propsval[4].value)
  data.offset = string.format("%.3f",jsonTableSolar.rv.propsval[5].value)
  data.meterreading = string.format("%.3f",tonumber(data.pulstotal)/tonumber(data.ppkwh)+tonumber(data.offset))
  data.solarPower = string.format("%.2f",self:solarPower(tonumber(data.solar), tonumber(solarM2)))
  data.net_consumption = tonumber(data.consumption) - tonumber(data.solar) -- Re-calculate net_consumption
end


function QuickApp:valuesMonitor() -- Update the Monitor values from json file
  local n = 29
  local i = 1
  for i=1,n do
    --self:logging(4,jsonTableMonitor.rv.propsval[i].id .." " ..jsonTableMonitor.rv.propsval[i].value)
    if jsonTableMonitor.rv.propsval[i].id == "usage" then
      data.consumption = string.format("%.1f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "T1" then
      data.consumption_low = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "T2" then
      data.consumption_high = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "-T1" then
      data.production_low = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "-T2" then
      data.production_high = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "gas_usage" then
      data.consumption_gas = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "gas" then
      data.gas = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "c_tariff" then
      data.tarifcode = tostring(jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "Gas-interval" then
      data.net_consumption = tonumber(data.consumption) - tonumber(data.solar) -- Initial calculation without Solar Panel
      data.total_consumption = tonumber(data.consumption_low) + tonumber(data.consumption_high)
      data.total_production = tonumber(data.production_low) + tonumber(data.production_high)

      if data.tarifcode == "2" then 
        data.tarifcodeText = "high"
      elseif data.tarifcode == "1" then
        data.tarifcodeText = "low"
      else
        data.tarifcodeText = ""
      end
      return ""
    else
      --self:warning("Unknown measurement value")
    end
  end
end 


function QuickApp:getData() -- Get data from Iungo Monitor, Solar, Water
  local url = "http://" ..IPaddress ..Path
  self:logging(3,"url: " ..url)
  self:logging(3,"currentMethod: " ..currentMethod)
  
  self.http:request(url, {
  options = {
    data = currentMethod,
    method = "POST",
    headers = {
      ["Content-Type"] = "application/json",
      ["Accept"] = "application/json",
      }
    },
    success = function(response) 
      self:logging(3,"Response status: " ..response.status)
      --self:logging(3,"Response data: " ..response.data)
      apiResult =  response.data

      if monitorToggle then
        jsonTableMonitor = json.decode(apiResult) -- Decode the json string from api to lua-table Monitor
        self:logging(3,"Start getValuesMonitor")
        self:valuesMonitor() -- Get the values from Monitor json file
        self:logging(3,"Start updateLabels")
        self:updateLabels() -- Update the labels
        self:logging(3,"Start updateChildDevices")
        self:updateChildDevices() -- Update the Child Devices
        if solarPanel then
          monitorToggle = false
          solarToggle = true
          waterToggle = false
          currentMethod = methodSolar
        elseif waterMeter then
          monitorToggle = false
          solarToggle = false
          waterToggle = true
          currentMethod = methodWater
        end

      elseif solarToggle then
        jsonTableSolar = json.decode(apiResult) -- Decode the json string lua-table Solarpanel
        self:logging(3,"Start getValuesSolar")
        self:valuesSolar() -- Get the values from Solar json file
        self:logging(3,"Start updateLabels")
        self:updateLabels() -- Update the labels
        self:logging(3,"Start updateChildDevices")
        self:updateChildDevices() -- Update the Child Devices
        if waterMeter then 
          monitorToggle = false
          solarToggle = false
          waterToggle = true
          currentMethod = methodWater
        else
          monitorToggle = true
          solarToggle = false
          waterToggle = false
          currentMethod = methodMonitor
        end

      elseif waterToggle then
        jsonTableWater = json.decode(apiResult) -- Decode the json string lua-table Watermeter
        self:logging(3,"Start getValuesWater")
        self:valuesWater() -- Get the values from Water json file
        self:logging(3,"Start updateLabels")
        self:updateLabels() -- Update the labels
        self:logging(3,"Start updateChildDevices")
        self:updateChildDevices() -- Update the Child Devices
        monitorToggle = true
        solarToggle = false
        waterToggle = false
        currentMethod = methodMonitor

      else
        self:warning("No toggle Monitor, Solar or Water active")
        return
      end

    end,
    error = function(message)
      self:logging(3,"error: " ..message)
      self:updateProperty("log", "error: " ..json.encode(error))
    end
  })
  self:logging(3,"Start setTimeout " ..interval .." seconds")
  fibaro.setTimeout(interval*1000, function() -- Checks every [interval] seconds for new data
    self:getData()
  end)
end 


function QuickApp:simData() -- Simulate Iungo Monitor, Solar, Water
  if monitorToggle then
    apiResult = '{"ok":true,"type":"response","time":0.0026875899638981,"rv":{"propsval":[{"id":"name","value":"EnergieDirect"},{"id":"metertype","value":"XMX"},{"id":"version","value":"5"},{"id":"serial_e","value":"4999999999999999999999999999999996"},{"id":"usage","value":516},{"id":"T1","value":10817.833},{"id":"T2","value":5398.875},{"id":"-T1","value":4379.797},{"id":"-T2","value":9959.182},{"id":"L1I","value":1},{"id":"L2I","value":1},{"id":"L3I","value":2},{"id":"L1Pimp","value":0.054},{"id":"L2Pimp","value":0.125},{"id":"L3Pimp","value":0.336},{"id":"L1Pexp","value":0},{"id":"L2Pexp","value":0},{"id":"L3Pexp","value":0},{"id":"c_tariff","value":2},{"id":"serial_g","value":"4999999999999999999999999999999995"},{"id":"gas_usage","value":0},{"id":"gas","value":3903.388},{"id":"Cost-T1","value":0.20721},{"id":"Cost-T2","value":0.22921},{"id":"Cost-nT1","value":0.20721},{"id":"Cost-nT2","value":0.22921},{"id":"Cost-gas","value":0.7711},{"id":"Gas-interval","value":3600},{"id":"Client-blob","value":""},{"id":"available","value":true}]},"systime":1610986159,"seq":1,"error":false}' -- Iungo Monitor Light version
    --apiResult =  '{"ok":true,"type":"response","time":0.0039377399953082,"rv":{"propsval":[{"id":"name","value":"Kosten"},{"id":"metertype","value":"Ene"},{"id":"version","value":"5"},{"id":"serial_e","value":"4999999999999999999999999999999997"},{"id":"usage","value":489},{"id":"T1","value":8945.53},{"id":"T2","value":4963.677},{"id":"-T1","value":2051.765},{"id":"-T2","value":6024.202},{"id":"L1I","value":3},{"id":"L1Pimp","value":0.489},{"id":"L1Pexp","value":0},{"id":"c_tariff","value":1},{"id":"serial_g","value":"4999999999999999999999999999999997"},{"id":"gas_usage","value":0},{"id":"gas","value":3143.767},{"id":"Cost-T1","value":0.18875},{"id":"Cost-T2","value":0.18875},{"id":"Cost-nT1","value":0.18875},{"id":"Cost-nT2","value":0.18875},{"id":"Cost-gas","value":0.64413},{"id":"Gas-interval","value":300},{"id":"Client-blob","value":""},{"id":"available","value":true}]},"systime":1611347255,"seq":1,"error":false}' -- Iungo Monitor Basic version    
    jsonTableMonitor = json.decode(apiResult) -- Decode the json string from api to lua-table Monitor
    self:logging(3,"Start getValuesMonitor")
    self:valuesMonitor() -- Get the values from Monitor json file
    self:logging(3,"Start updateLabels")
    self:updateLabels() -- Update the labels
    self:logging(3,"Start updateChildDevices")
    self:updateChildDevices() -- Update the Child Devices
    if solarPanel then
      monitorToggle = false
      solarToggle = true
      waterToggle = false
      currentMethod = methodSolar
    elseif waterMeter then
      monitorToggle = false
      solarToggle = false
      waterToggle = true
      currentMethod = methodWater
    end
  
  elseif solarToggle then
    apiResult = '{"ok":true,"type":"response","time":0.0016563490498811,"rv":{"propsval":[{"id":"name","value":"20 panelen"},{"id":"solar","value":500.4},{"id":"pulstotal","value":16575341},{"id":"ppkwh","value":800},{"id":"offset","value":292.07},{"id":"connection","value":"breakout"},{"id":"functiongroup","value":"solar"}]},"systime":1611237657,"seq":1,"error":false}' -- Iungo Solarpanel    
    jsonTableSolar = json.decode(apiResult) -- Decode the json string lua-table Solarpanel
    self:logging(3,"Start getValuesSolar")
    self:valuesSolar() -- Get the values from Solar json file
    self:logging(3,"Start updateLabels")
    self:updateLabels() -- Update the labels
    self:logging(3,"Start updateChildDevices")
    self:updateChildDevices() -- Update the Child Devices
    if waterMeter then 
      monitorToggle = false
      solarToggle = false
      waterToggle = true
      currentMethod = methodWater
    else
      monitorToggle = true
      solarToggle = false
      waterToggle = false
      currentMethod = methodMonitor
    end

  elseif waterToggle then
    apiResult = '{"ok":true,"type":"response","time":0.0010625629220158,"rv":{"propsval":[{"id":"name","value":"Water"},{"id":"flow","value":0},{"id":"pulstotal","value":456523},{"id":"kfact","value":1000},{"id":"offset","value":-47.091},{"id":"tariff","value":0.9616},{"id":"connection","value":"breakout_ch2"}]},"systime":1611765184,"seq":1,"error":false}' -- Iungo Watermeter    
    jsonTableWater = json.decode(apiResult) -- Decode the json string lua-table Watermeter
    self:logging(3,"Start getValuesWater")
    self:valuesWater() -- Get the values from Water json file
    self:logging(3,"Start updateLabels")
    self:updateLabels() -- Update the labels
    self:logging(3,"Start updateChildDevices")
    self:updateChildDevices() -- Update the Child Devices
    monitorToggle = true
    solarToggle = false
    waterToggle = false
    currentMethod = methodMonitor
  else
    self:warning("No toggle Monitor, Solar or Water active")
    return
  end

  self:logging(3,"Start setTimeout " ..interval .." seconds")
  fibaro.setTimeout(interval*1000, function() -- Checks every [interval] seconds for new data
    self:simData()
  end)
end 


function QuickApp:logging(level,text) -- Logging function for debug
  if tonumber(debugLevel) >= tonumber(level) then 
    self:debug(text)
  end
end


function QuickApp:variables() -- Create Variables
  monitorToggle = true
  solarToggle = false
  waterToggle = false
  Path = "/iungo/api_request" -- Default Path
  methodMonitor = '{"seq":1,"method":"object_list_props_values","arguments":{"oid":"538d72d9"}}' -- Default Method for Iungo Monitor
  methodSolar = '{"seq":1,"method":"object_list_props_values","arguments":{"oid":"95778a43"}}' -- Default Method for Iungo Solarpanel
  methodWater = '{"seq":1,"method":"object_list_props_values","arguments":{"oid":"82ec52ad"}}' -- MDefault Method for Iungo Watermeter
  currentMethod = methodMonitor -- Set default Method to Iungo Monitor Method
  data = {}
  data.net_consumption = "0"
  data.house_consumption = "0"
  data.solar = "0"
  data.solarPower = "0" 
  data.tarifcodeText = " "
  data.meterreading = "0"
  data.flow = "0"
  data.wused = "0"
end


function QuickApp:getQuickAppVariables() -- Get all getQuickApp Variables or create them
  IPaddress = self:getVariable("IPaddress")
  solarPanel = string.lower(self:getVariable("solarPanel"))
  waterMeter = string.lower(self:getVariable("waterMeter"))
  solarM2 = tonumber(self:getVariable("solarM2"))
  interval = tonumber(self:getVariable("interval")) 
  debugLevel = tonumber(self:getVariable("debugLevel"))
  local icon = tonumber(self:getVariable("icon")) 

  -- Check existence of the mandatory variables, if not, create them with default values 
  if IPaddress == "" or IPaddress == nil then 
    IPaddress = "192.168.178.12" -- Default IPaddress of Iungo Monitor
    self:setVariable("IPaddress", IPaddress)
    self:trace("Added QuickApp variable IPaddress")
  end
  if solarPanel == "" or solarPanel == nil then 
    solarPanel = "false" -- Default availability of solarPanel is "false"
    self:setVariable("solarPanel",solarPanel)
    self:trace("Added QuickApp variable solarPanel")
  end  
  if waterMeter == "" or waterMeter == nil then 
    waterMeter = "false" -- Default availability of waterMeter is "false"
    self:setVariable("waterMeter",waterMeter)
    self:trace("Added QuickApp variable waterMeter")
  end  
  if solarM2 == "" or solarM2 == nil then 
    solarM2 = "0" -- How much m2 Solar Panels, default is 0
    self:setVariable("solarM2",solarM2)
    self:trace("Added QuickApp variable solarM2")
  end
  if interval == "" or interval == nil then
    interval = "10" -- Default interval in seconds (The Iungo meter normally reads every 10 seconds)
    self:setVariable("interval", interval)
    self:trace("Added QuickApp variable interval")
    interval = tonumber(interval)
  end
  if debugLevel == "" or debugLevel == nil then
    debugLevel = "1" -- Default value for debugLevel is "1"
    self:setVariable("debugLevel",debugLevel)
    self:trace("Added QuickApp variable debugLevel")
    debugLevel = tonumber(debugLevel)
  end
  if icon == "" or icon == nil then 
    icon = "0" -- Default icon
    self:setVariable("icon",icon)
    self:trace("Added QuickApp variable icon")
    icon = tonumber(icon)
  end
  if icon ~= 0 then 
    self:updateProperty("deviceIcon", icon) -- set user defined icon 
  end

  if solarPanel == "true" then 
    solarPanel = true 
  elseif solarPanel == "false" then 
    solarPanel = false
  end

  if waterMeter == "true" then 
    waterMeter = true 
  elseif waterMeter == "false" then 
    waterMeter = false
  end

  if solarPanel and waterMeter then
    interval = tonumber(string.format("%.3f", interval / 3))
  elseif solarPanel or waterMeter then
    interval = tonumber(string.format("%.3f", interval / 2))
  end
  self:logging(3,"Interval: " ..tostring(interval))

end


function QuickApp:updateChildDevices()
  for id,child in pairs(self.childDevices) do -- Update Child Devices
    child:updateValue(data) 
  end
end


function QuickApp:setupChildDevices() -- Setup Child Devices
  local cdevs = api.get("/devices?parentId="..self.id) or {} -- Pick up all Child Devices
  function self:initChildDevices() end -- Null function, else Fibaro calls it after onInit()...

  if #cdevs == 0 then -- If no Child Devices, create them
    local initChildData = { 
      {className="consumption", name="Net Consumption", type="com.fibaro.multilevelSensor", value=0, unit="Watt"},
      {className="production", name="Solar Production", type="com.fibaro.multilevelSensor", value=0, unit="Watt"},
      {className="solarPower", name="Solar Power", type="com.fibaro.multilevelSensor", value=0, unit="Watt/m²"},
      {className="waterflow", name="Water Flow", type="com.fibaro.multilevelSensor", value=0, unit="m³"},
      {className="consumption_high", name="Consumption High", type="com.fibaro.multilevelSensor", value=0, unit="kWh"},
      {className="consumption_low", name="Consumption Low", type="com.fibaro.multilevelSensor", value=0, unit="kWh"},
      {className="production_high", name="Production High", type="com.fibaro.multilevelSensor", value=0, unit="kWh"},
      {className="production_low", name="Production Low", type="com.fibaro.multilevelSensor", value=0, unit="kWh"},
      {className="gas", name="Total Gas", type="com.fibaro.multilevelSensor", value=0, unit="m³"},
      {className="total_waterflow", name="Total Water Flow", type="com.fibaro.multilevelSensor", value=0, unit="m³"},
    }
    for _,c in ipairs(initChildData) do
      local child = self:createChildDevice(
        {name = c.name,
          type=c.type,
          value=c.value,
          unit=c.unit,
          initialInterfaces = {},
        },
        _G[c.className] -- Fetch class constructor from class name
      )
      child:setVariable("className",c.className)  -- Save class name so we know when we load it next time
    end   
  else 
    for _,child in ipairs(cdevs) do
      local className = getChildVariable(child,"className") -- Fetch child class name
      local childObject = _G[className](child) -- Create child object from the constructor name
      self.childDevices[child.id]=childObject
      childObject.parent = self -- Setup parent link to device controller 
    end
  end
end


function QuickApp:onInit() -- Let's get started
  __TAG = fibaro.getName(plugin.mainDeviceId) .." ID:" ..plugin.mainDeviceId
  self:debug("onInit")
  self:debug("Start setupChildDevices")
  self:setupChildDevices()
  self:debug("Start getQuickAppVariables")
  self:getQuickAppVariables() -- Get QuickApp Variables
  self:logging(3,"Start variables")
  self:variables() -- Create all Variables

  self.http = net.HTTPClient({timeout=3000})
  
  if tonumber(debugLevel) >= 4 then 
    self:logging(3,"Start simData")
    self:simData() -- Go in simulation
  else
    self:logging(3,"Start getData")
    self:getData() -- Get data from Iungo Monitor, Solarpanel, Watermeter
  end
end

-- EOF 
