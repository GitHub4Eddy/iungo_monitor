-- IUNGO MONITOR 

-- This Quickapp retrieves power consumption, solar production, energy usage, gas usage and waterflow from the Iungo Monitor, Solarpanel and Watermeter

-- (Child) Devices for Consumption, Production, Solar Power, Water Flow, Consumption High, Consumption Low, Production High, Production Low, Total Gas and Total Water FLow


-- Version 1.1 (11th September 2021)
-- Changed the Child Devices Consumption High, Consumption Low, Production High and Production Low to device type energyMeter to facilitate the new Energy Panel
-- Added automaticaly change rateType interface of Child device Consumption High and Low to "consumption" and Production High and Low to "production"
-- Changed the Main Device to device type powerSensor to show the power graphs
-- Added Net Consumption to the value of the Main Device 
-- Changed the Child Devices Consumption, Production and Solar Power to device type powerSensor to show the power graphs 
-- Changed the Water Flow unit text from m³ to Litre
-- Added the amount of m2 Solar Panels to the log text ot the Child Device Solar Power and to the labels
-- Changed meterreading to automatically kWh, MWh of GWh
-- Moved tarif informatie to main device log text
-- Added Meter measurement for Consumption High, Consumption Low, Production High, Production Low, Gas and Water to reset the measurements
-- Added Meter measurement Date for Consumption High, Consumption Low, Production High, Production Low, Gas and Water
-- Removed Refresh button
-- Added some extra debug information when debug level = 3



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
-- meterConsHigh = Last meter measurement Consumption High
-- meterConsLow = Last meter measurement Consumption Low
-- meterProdHigh = Last meter measurement Production High 
-- meterProdLow = Last meter measurement Production Low 
-- meterGas = Last meter measurement Gas 
-- meterWater = Last meter measurement Water 
-- meterConsHighD = Date last meter measurement Consumption High
-- meterConsLowD = Date last meter measurement Consumption Low
-- meterProdHighD = Date last meter measurement Production High 
-- meterProdLowD = Date last meter measurement Production Low 
-- meterGasD = Date last meter measurement Gas 
-- meterWaterD = Date last meter measurement Water 



-- No editing of this code is needed 


class 'consumption'(QuickAppChild)
function consumption:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Consumption QuickappChild initiated, deviceId:",self.id)
end
function consumption:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.0f", data.consumption)))
  self:updateProperty("power", tonumber(string.format("%.0f", data.consumption)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", " ")
end


class 'production'(QuickAppChild)
function production:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Production QuickappChild initiated, deviceId:",self.id)
end
function production:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.0f", data.solar)))
  self:updateProperty("power", tonumber(string.format("%.0f", data.solar)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", data.meterreading .." " ..data.meterreadingUnit)
end


class 'solarPower'(QuickAppChild)
function solarPower:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("solarPower QuickappChild initiated, deviceId:",self.id)
end
function solarPower:updateValue(data) 
  self:updateProperty("value", tonumber(data.solarPower))
  self:updateProperty("power", tonumber(data.solarPower))
  self:updateProperty("unit", "Watt/m²")
  self:updateProperty("log", solarM2 .." m² panels")
end


class 'waterflow'(QuickAppChild)
function waterflow:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Waterflow QuickappChild initiated, deviceId:",self.id)
end
function waterflow:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.0f",data.flow)))
  self:updateProperty("unit", "Litre")
  self:updateProperty("log", " ")
end


class 'consumption_high'(QuickAppChild)
function consumption_high:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("consumption_high QuickappChild initiated, deviceId:",self.id)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Consumption High child device (" ..self.id ..") to consumption")
  end
end
function consumption_high:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption_high)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", meterConsHighD)
end


class 'consumption_low'(QuickAppChild)
function consumption_low:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("consumption_low QuickappChild initiated, deviceId:",self.id)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Consumption High child device (" ..self.id ..") to consumption")
  end
end
function consumption_low:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption_low)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", meterConsLowD)
end


class 'production_high'(QuickAppChild)
function production_high:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("production_high QuickappChild initiated, deviceId:",self.id)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Production High child device (" ..self.id ..") to production")
  end
end
function production_high:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production_high)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", meterProdHighD)
end


class 'production_low'(QuickAppChild)
function production_low:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("production_low QuickappChild initiated, deviceId:",self.id)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Production High child device (" ..self.id ..") to production")
  end
end
function production_low:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production_low)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", meterProdLowD)
end


class 'gas'(QuickAppChild)
function gas:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("gas QuickappChild initiated, deviceId:",self.id)
end
function gas:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.gas)))
  self:updateProperty("unit", "m³")
  self:updateProperty("log", meterGasD)
end


class 'total_waterflow'(QuickAppChild)
function total_waterflow:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("total_waterflow QuickappChild initiated, deviceId:",self.id)
end
function total_waterflow:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.wused)))
  self:updateProperty("unit", "m³")
  self:updateProperty("log", meterWaterD)
end


local function getChildVariable(child,varName)
  for _,v in ipairs(child.properties.quickAppVariables or {}) do
    if v.name==varName then return v.value end
  end
  return ""
end


-- QuickApp Functions


function QuickApp:logging(level,text) -- Logging function for debug
  if tonumber(debugLevel) >= tonumber(level) then 
    self:debug(text)
  end
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


function QuickApp:unitCheckWh(measurement) -- Set the measurement and unit to Wh, kWh, MWh or GWh
  self:logging(3,"Start unitCheckWh")
  if measurement > 1000000000 then
    return string.format("%.2f",measurement/1000000000),"GWh"
  elseif measurement > 1000000 then
    return string.format("%.2f",measurement/1000000),"MWh"
  elseif measurement > 1000 then
    return string.format("%.2f",measurement/1000),"kWh"
  else
    return string.format("%.0f",measurement),"Wh"
  end
end


function QuickApp:recalcMeter(meter,reading) -- Recalculate meter readings
  self:logging(3,"QuickApp:recalcMeter")
  self:logging(3,"meter: " ..meter)
  self:logging(3,"reading: " ..reading)
  if tonumber(meter) > 0 and tonumber(meter) < tonumber(reading) then
    return string.format("%.3f",reading - meter)
  end
  return string.format("%.3f",reading)
end


function QuickApp:updateProperties() -- Update the properties
  self:logging(3,"QuickApp:updateProperties")
  self:updateProperty("value", tonumber(string.format("%.3f",data.net_consumption)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.net_consumption)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "Tarif: " ..data.tarifcodeText)
end


function QuickApp:updateLabels() -- Update the labels 
  self:logging(3,"QuickApp:updateLabels")
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
    labelText = labelText .."Solar Meterreading: " ..data.meterreading .." " ..data.meterreadingUnit .."\n"
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
    labelText = labelText .."Panels: " ..solarM2 .." m²" .."\n"
    labelText = labelText .."Power: " ..data.solarPower .." Watt/m²" .."\n"
  end
  if waterMeter then
    labelText = labelText .."\n" .."Water:" .."\n"
    labelText = labelText .."Waterflow: " ..data.flow .." Litre" .."\n"
  end
  
  self:updateView("label1", "text", labelText)
  self:logging(2,labelText)
end


function QuickApp:valuesWater() -- Update the Water values from json file
  self:logging(3,"QuickApp:valuesWater")
  data.flow = jsonTableWater.rv.propsval[2].value
  data.pulstotal = jsonTableWater.rv.propsval[3].value
  data.kfact = jsonTableWater.rv.propsval[4].value 
  data.offset = jsonTableWater.rv.propsval[5].value
  data.wused = string.format("%.3f",data.pulstotal/data.kfact+data.offset)
  data.wused = self:recalcMeter(meterWater, data.wused)
end


function QuickApp:valuesSolar() -- Update the Solar values from json file
  self:logging(3,"QuickApp:valuesSolar")
  data.solar = string.format("%.1f",jsonTableSolar.rv.propsval[2].value)
  data.pulstotal = string.format("%.3f",jsonTableSolar.rv.propsval[3].value)
  data.ppkwh = string.format("%.3f",jsonTableSolar.rv.propsval[4].value)
  data.offset = string.format("%.3f",jsonTableSolar.rv.propsval[5].value)
  data.meterreading = string.format("%.3f",tonumber(data.pulstotal)/tonumber(data.ppkwh)+tonumber(data.offset)) -- Calculate meterreading
  data.meterreading, data.meterreadingUnit = self:unitCheckWh(tonumber(data.meterreading)) -- Set measurement and unit to Wh, kWh, MWh or GWh
  data.solarPower = string.format("%.2f",self:solarPower(tonumber(data.solar), tonumber(solarM2)))
  data.net_consumption = tonumber(data.consumption) - tonumber(data.solar) -- Calculate net_consumption
end


function QuickApp:valuesMonitor() -- Update the Monitor values from json file
  self:logging(3,"QuickApp:valuesMonitor")
  local n = 29
  local i = 1
  for i=1,n do
    --self:logging(4,jsonTableMonitor.rv.propsval[i].id .." " ..jsonTableMonitor.rv.propsval[i].value)
    if jsonTableMonitor.rv.propsval[i].id == "usage" then
      data.consumption = string.format("%.1f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "T1" then
      data.consumption_low = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
      data.consumption_low = self:recalcMeter(meterConsLow, data.consumption_low)
    elseif jsonTableMonitor.rv.propsval[i].id == "T2" then
      data.consumption_high = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
      data.consumption_high = self:recalcMeter(meterConsHigh, data.consumption_high)
    elseif jsonTableMonitor.rv.propsval[i].id == "-T1" then
      data.production_low = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
      data.production_low = self:recalcMeter(meterProdLow, data.production_low)
    elseif jsonTableMonitor.rv.propsval[i].id == "-T2" then
      data.production_high = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
      data.production_high = self:recalcMeter(meterProdHigh, data.production_high)
    elseif jsonTableMonitor.rv.propsval[i].id == "gas_usage" then
      data.consumption_gas = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "gas" then
      data.gas = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
      data.gas = self:recalcMeter(meterGas, data.gas)
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
  self:logging(3,"QuickApp:getData")
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
        self:logging(3,"Start updateProperties")
        self:updateProperties() -- Update the propterties
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
        self:logging(3,"Start updateProperties")
        self:updateProperties() -- Update the propterties
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
  self:logging(3,"QuickApp:simData")
  if monitorToggle then
    apiResult = '{"ok":true,"type":"response","time":0.0026875899638981,"rv":{"propsval":[{"id":"name","value":"EnergieDirect"},{"id":"metertype","value":"XMX"},{"id":"version","value":"5"},{"id":"serial_e","value":"4999999999999999999999999999999996"},{"id":"usage","value":516},{"id":"T1","value":10817.833},{"id":"T2","value":5398.875},{"id":"-T1","value":4379.797},{"id":"-T2","value":9959.182},{"id":"L1I","value":1},{"id":"L2I","value":1},{"id":"L3I","value":2},{"id":"L1Pimp","value":0.054},{"id":"L2Pimp","value":0.125},{"id":"L3Pimp","value":0.336},{"id":"L1Pexp","value":0},{"id":"L2Pexp","value":0},{"id":"L3Pexp","value":0},{"id":"c_tariff","value":2},{"id":"serial_g","value":"4999999999999999999999999999999995"},{"id":"gas_usage","value":0},{"id":"gas","value":3903.388},{"id":"Cost-T1","value":0.20721},{"id":"Cost-T2","value":0.22921},{"id":"Cost-nT1","value":0.20721},{"id":"Cost-nT2","value":0.22921},{"id":"Cost-gas","value":0.7711},{"id":"Gas-interval","value":3600},{"id":"Client-blob","value":""},{"id":"available","value":true}]},"systime":1610986159,"seq":1,"error":false}' -- Iungo Monitor Light version
    --apiResult =  '{"ok":true,"type":"response","time":0.0039377399953082,"rv":{"propsval":[{"id":"name","value":"Kosten"},{"id":"metertype","value":"Ene"},{"id":"version","value":"5"},{"id":"serial_e","value":"4999999999999999999999999999999997"},{"id":"usage","value":489},{"id":"T1","value":8945.53},{"id":"T2","value":4963.677},{"id":"-T1","value":2051.765},{"id":"-T2","value":6024.202},{"id":"L1I","value":3},{"id":"L1Pimp","value":0.489},{"id":"L1Pexp","value":0},{"id":"c_tariff","value":1},{"id":"serial_g","value":"4999999999999999999999999999999997"},{"id":"gas_usage","value":0},{"id":"gas","value":3143.767},{"id":"Cost-T1","value":0.18875},{"id":"Cost-T2","value":0.18875},{"id":"Cost-nT1","value":0.18875},{"id":"Cost-nT2","value":0.18875},{"id":"Cost-gas","value":0.64413},{"id":"Gas-interval","value":300},{"id":"Client-blob","value":""},{"id":"available","value":true}]},"systime":1611347255,"seq":1,"error":false}' -- Iungo Monitor Basic version    
    jsonTableMonitor = json.decode(apiResult) -- Decode the json string from api to lua-table Monitor
    self:logging(3,"Start getValuesMonitor")
    self:valuesMonitor() -- Get the values from Monitor json file
    self:logging(3,"Start updateLabels")
    self:updateLabels() -- Update the labels
    self:logging(3,"Start updateProperties")
    self:updateProperties() -- Update the propterties
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
    apiResult = '{"ok":true,"type":"response","time":0.0010625629220158,"rv":{"propsval":[{"id":"name","value":"Water"},{"id":"flow","value":2},{"id":"pulstotal","value":456523},{"id":"kfact","value":1000},{"id":"offset","value":-47.091},{"id":"tariff","value":0.9616},{"id":"connection","value":"breakout_ch2"}]},"systime":1611765184,"seq":1,"error":false}' -- Iungo Watermeter    
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


function QuickApp:createVariables() -- Create Variables
  monitorToggle = true
  solarToggle = false
  waterToggle = false
  Path = "/iungo/api_request" -- Default Path
  methodMonitor = '{"seq":1,"method":"object_list_props_values","arguments":{"oid":"538d72d9"}}' -- Default Method for Iungo Monitor
  methodSolar = '{"seq":1,"method":"object_list_props_values","arguments":{"oid":"95778a43"}}' -- Default Method for Iungo Solarpanel
  methodWater = '{"seq":1,"method":"object_list_props_values","arguments":{"oid":"82ec52ad"}}' -- Default Method for Iungo Watermeter
  currentMethod = methodMonitor -- Set default Method to Iungo Monitor Method
  
  data = {}
  data.net_consumption = "0"
  data.house_consumption = "0"
  data.consumption = "0" 
  data.consumption_low = "0" 
  data.consumption_high = "0" 
  data.production_low = "0" 
  data.production_high = "0" 
  data.consumption_gas = "0" 
  data.gas = "0" 
  data.tarifcode = ""
  data.total_consumption = "0"  
  data.total_production = "0" 
  
  data.solar = "0"
  data.solarPower = "0" 
  data.tarifcodeText = " "
  data.meterreading = "0"
  data.meterreadingUnit = ""
  
  data.flow = "0"
  data.wused = "0"
  data.pulstotal = "0"
  data.ppkwh = "0"
  data.offset = "0"
  data.flow = "0"
  data.kfact = "0"
  
end


function QuickApp:getQuickAppVariables() -- Get all getQuickApp Variables or create them
  IPaddress = self:getVariable("IPaddress")
  solarPanel = string.lower(self:getVariable("solarPanel"))
  waterMeter = string.lower(self:getVariable("waterMeter"))
  solarM2 = tonumber(self:getVariable("solarM2"))
  interval = tonumber(self:getVariable("interval")) 
  debugLevel = tonumber(self:getVariable("debugLevel"))
  meterConsHigh = tonumber(self:getVariable("meterConsHigh"))
  meterConsHighD = self:getVariable("meterConsHighD")
  meterConsLow = tonumber(self:getVariable("meterConsLow"))
  meterConsLowD = self:getVariable("meterConsLowD")
  meterProdHigh = tonumber(self:getVariable("meterProdHigh"))
  meterProdHighD = self:getVariable("meterProdHighD")
  meterProdLow = tonumber(self:getVariable("meterProdLow"))
  meterProdLowD = self:getVariable("meterProdLowD")
  meterGas = tonumber(self:getVariable("meterGas"))
  meterGasD = self:getVariable("meterGasD")
  meterWater = tonumber(self:getVariable("meterWater"))
  meterWaterD = self:getVariable("meterWaterD")


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
  if meterConsHigh == "" or meterConsHigh == nil then 
    meterConsHigh = "0" 
    self:setVariable("meterConsHigh", meterConsHigh)
    self:trace("Added QuickApp variable meterConsHigh")
    meterConsHigh = tonumber(meterConsHigh)
  end
  if meterConsLow == "" or meterConsLow == nil then 
    meterConsLow = "0" 
    self:setVariable("meterConsLow", meterConsLow)
    self:trace("Added QuickApp variable meterConsLow")
    meterConsLow = tonumber(meterConsLow)
  end  
  if meterProdHigh == "" or meterProdHigh == nil then 
    meterProdHigh = "0" 
    self:setVariable("meterProdHigh", meterProdHigh)
    self:trace("Added QuickApp variable meterProdHigh")
    meterProdHigh = tonumber(meterProdHigh)
  end 
  if meterProdLow == "" or meterProdLow == nil then 
    meterProdLow = "0" 
    self:setVariable("meterProdLow", meterProdLow)
    self:trace("Added QuickApp variable meterProdLow")
    meterProdLow = tonumber(meterProdLow)
  end   
  if meterGas == "" or meterGas == nil then 
    meterGas = "0" 
    self:setVariable("meterGas", meterGas)
    self:trace("Added QuickApp variable meterGas")
    meterGas = tonumber(meterGas)
  end   
  if meterWater == "" or meterWater == nil then 
    meterWater = "0" 
    self:setVariable("meterWater", meterWater)
    self:trace("Added QuickApp variable meterWater")
    meterWater = tonumber(meterWater)
  end  
  if meterConsHighD == "" or meterConsHighD == nil then 
    meterConsHighD = "00-00-0000" 
    self:setVariable("meterConsHighD", meterConsHighD)
    self:trace("Added QuickApp variable meterConsHighD")
  end
  if meterConsLowD == "" or meterConsLowD == nil then 
    meterConsLowD = "00-00-0000" 
    self:setVariable("meterConsLowD", meterConsLowD)
    self:trace("Added QuickApp variable meterConsLowD")
  end  
  if meterProdHighD == "" or meterProdHighD == nil then 
    meterProdHighD = "00-00-0000" 
    self:setVariable("meterProdHighD", meterProdHighD)
    self:trace("Added QuickApp variable meterProdHighD")
  end 
  if meterProdLowD == "" or meterProdLowD == nil then 
    meterProdLowD = "00-00-0000" 
    self:setVariable("meterProdLowD", meterProdLowD)
    self:trace("Added QuickApp variable meterProdLowD")
  end   
  if meterGasD == "" or meterGasD == nil then 
    meterGasD = "00-00-0000" 
    self:setVariable("meterGasD", meterGasD)
    self:trace("Added QuickApp variable meterGasD")
  end   
  if meterWaterD == "" or meterWaterD == nil then 
    meterWaterD = "00-00-0000" 
    self:setVariable("meterWaterD", meterWaterD)
    self:trace("Added QuickApp variable meterWaterD")
  end  
  
  if solarPanel == "true" then 
    solarPanel = true 
  else
    solarPanel = false
  end

  if waterMeter == "true" then 
    waterMeter = true 
  else
    waterMeter = false
  end

  if solarPanel and waterMeter then
    interval = tonumber(string.format("%.3f", interval / 3))
  elseif solarPanel or waterMeter then
    interval = tonumber(string.format("%.3f", interval / 2))
  end
  self:logging(3,"Interval: " ..tostring(interval))

  if meterConsHighD == " 0" or meterConsHighD == "00-00-0000" then
    meterConsHighD = ""
  else 
    meterConsHighD = "Since: " ..meterConsHighD
  end
  if meterConsLowD == " 0" or meterConsLowD == "00-00-0000" then
    meterConsLowD = ""
  else 
    meterConsLowD = "Since: " ..meterConsLowD
  end
  if meterProdHighD == " 0" or meterProdHighD == "00-00-0000" then
    meterProdHighD = ""
  else 
    meterProdHighD = "Since: " ..meterProdHighD
  end
  if meterProdLowD == " 0" or meterProdLowD == "00-00-0000" then
    meterProdLowD = ""
  else 
    meterProdLowD = "Since: " ..meterProdLowD
  end
  if meterGasD == " 0" or meterGasD == "00-00-0000" then
    meterGasD = ""
  end
  if meterWaterD == " 0" or meterWaterD == "00-00-0000" then
    meterWaterD = ""
  else 
    meterWaterD = "Since: " ..meterWaterD
  end

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
      {className="consumption", name="Consumption", type="com.fibaro.powerSensor", value=0},
      {className="production", name="Production", type="com.fibaro.powerSensor", value=0},
      {className="solarPower", name="Solar Power", type="com.fibaro.powerSensor", value=0},
      {className="waterflow", name="Water Flow", type="com.fibaro.multilevelSensor", value=0},
      {className="consumption_high", name="Consumption High", type="com.fibaro.energyMeter", value=0},
      {className="consumption_low", name="Consumption Low", type="com.fibaro.energyMeter", value=0},
      {className="production_high", name="Production High", type="com.fibaro.energyMeter", value=0},
      {className="production_low", name="Production Low", type="com.fibaro.energyMeter", value=0},
      {className="gas", name="Total Gas", type="com.fibaro.multilevelSensor", value=0},
      {className="total_waterflow", name="Total Water Flow", type="com.fibaro.multilevelSensor", value=0},
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
  self:createVariables() -- Create all Variables

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
