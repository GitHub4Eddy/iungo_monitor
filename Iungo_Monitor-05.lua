-- IUNGO MONITOR 

-- This Quickapp retrieves power consumption, power production and gas usage from the (Iungo Monitor) energy and gas meter 
-- All power consumption of all HomeCenter devices is summerized
-- The difference between the total power consumption and the power consumption of the HomeCenter devices is put in a unused device (unless the powerID = 0 or empty)
-- In the QuickApp labels power consumption, power production and gas usage is shown 
-- The net consumption is also shown in de log (under the icon)


-- Version 0.5 (21th January 2021)
-- Initial version


-- Variables (mandatory and automaticaly generated): 
-- IPaddress = IP address of your Iungo Monitor
-- Path = Path, normally "/iungo/api_request" (don't changes unless you know what you are doing)
-- Method = Method, normally '{"seq":1,"method":"object_list_props_values","arguments":{"oid":"538d72d9"}}' (don't changes unless you know what you are doing)
-- Interval = Number in seconds, the Lungo Monitor normally is updated every 10 seconds
-- powerID = ID of the device where you want to capture the 'delta' power, use 0 if you don't want to store the energy consumption
-- debugLevel = Number (1=some, 2=few, 3=all, 4=simulation mode) (default = 1)

-- Example content Json table
-- {"ok":true,"type":"response","time":0.0026875899638981,"rv":{"propsval":[{"id":"name","value":"EnergieDirect"},{"id":"metertype","value":"XMX"},{"id":"version","value":"5"},{"id":"serial_e","value":"4999999999999999999999999999999996"},{"id":"usage","value":516},{"id":"T1","value":10817.833},{"id":"T2","value":5398.875},{"id":"-T1","value":4379.797},{"id":"-T2","value":9959.182},{"id":"L1I","value":1},{"id":"L2I","value":1},{"id":"L3I","value":2},{"id":"L1Pimp","value":0.054},{"id":"L2Pimp","value":0.125},{"id":"L3Pimp","value":0.336},{"id":"L1Pexp","value":0},{"id":"L2Pexp","value":0},{"id":"L3Pexp","value":0},{"id":"c_tariff","value":2},{"id":"serial_g","value":"4999999999999999999999999999999995"},{"id":"gas_usage","value":0},{"id":"gas","value":3903.388},{"id":"Cost-T1","value":0.20721},{"id":"Cost-T2","value":0.22921},{"id":"Cost-nT1","value":0.20721},{"id":"Cost-nT2","value":0.22921},{"id":"Cost-gas","value":0.7711},{"id":"Gas-interval","value":3600},{"id":"Client-blob","value":""},{"id":"available","value":true}]},"systime":1610986159,"seq":1,"error":false}


-- No editing of this code is needed 


function QuickApp:logging(level,text) -- Logging function for debug
  if tonumber(debugLevel) >= tonumber(level) then 
      self:debug(text)
  end
end


function QuickApp:button1Event() -- Refresh button event
  self:updateView("button1", "text", "Please wait...")
  self:onInit()
  fibaro.setTimeout(3000, function()
    self:updateView("button1", "text", "Update Devicelist")
  end)
end


function QuickApp:updateProperties() -- Update the properties
  self:updateProperty("value",tonumber(string.format("%.0f",net_consumption)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", tarifcodeText)
end


function QuickApp:updateLabels() -- Update the labels 
  local labelText = "Net consumption: " ..net_consumption .." Watt " ..tarifcodeText .."\n\n"
  labelText = labelText .."Consumption: " ..consumption .." Watt" .."\n" 
  labelText = labelText .."Production: " ..production .." Watt" .."\n"
  labelText = labelText .."Net consumption: " ..net_consumption .." Watt " .."\n\n"
  labelText = labelText .."Gross consumption: " ..gross_consumption .." Watt" .."\n"
  labelText = labelText .."Device consumption: " ..device_consumption .." Watt" .."\n\n"
  labelText = labelText .."Total consumption high: " ..consumption_high .." kWh" .."\n" 
  labelText = labelText .."Total consumption low: " ..consumption_low .." kWh" .."\n"
  labelText = labelText .."Total consumption: " ..total_consumption .." kWh" .."\n" 
  labelText = labelText .."Total production high: " ..production_high .." kWh" .."\n" 
  labelText = labelText .."Total producton low: " ..production_low .." kWh" .."\n"
  labelText = labelText .."Total production: " ..total_production .." kWh" .."\n"
  labelText = labelText .."Total gas: " ..gas .." M3"

  self:updateView("label1", "text", labelText)
  self:logging(2,labelText)
end


function QuickApp:updateConsumption() -- Update the energy consumption of all energy devices
  local deviceValue = 0
  local id = 1
  device_consumption = 0
  gross_consumption = 0
  for key, id in pairs(eDevices) do
    if fibaro.getValue(id, "power") and id~=powerID then
      deviceValue = fibaro.getValue(id, "power")
      self:logging(5,fibaro.getName(id) .." (ID " ..id .."): " ..deviceValue .." Watt")
      device_consumption = device_consumption + deviceValue
    end
  end
  gross_consumption = tonumber(net_consumption) - device_consumption -- Measured power usage minus power usage from all devices
  if powerID == 0 or powerID == nil then
    --self:warning("No powerID to store net power consumption")
  else
    api.put("/devices/"..powerID, {["properties"]={["power"]=gross_consumption}}) -- Put gross_consumption into device with powerID
  end
end


function QuickApp:getValues() -- Get the values from json file
  consumption = string.format("%.1f",jsonTable.rv.propsval[5].value)
  consumption_low = string.format("%.3f",jsonTable.rv.propsval[6].value)
  consumption_high = string.format("%.3f",jsonTable.rv.propsval[7].value)
  --production = string.format("%.1f",jsonTable.PRODUCTION_W)
  production = "0" -- Temp setting
  production_low = string.format("%.3f",jsonTable.rv.propsval[8].value)
  production_high = string.format("%.3f",jsonTable.rv.propsval[9].value)
  consumption_gas = string.format("%.3f",jsonTable.rv.propsval[21].value)
  gas = string.format("%.3f",jsonTable.rv.propsval[22].value)
  net_consumption = string.format("%.1f",jsonTable.rv.propsval[5].value - production) -- Temp setting use of production
  total_consumption = string.format("%.3f",(jsonTable.rv.propsval[6].value + jsonTable.rv.propsval[7].value))
  total_production = string.format("%.3f",(jsonTable.rv.propsval[8].value + jsonTable.rv.propsval[9].value))
  tarifcode = jsonTable.rv.propsval[19].value

  if tarifcode == "2" then
    tarifcodeText = "(High)"
  elseif tarifcode == "1" then
    tarifcodeText = "(Low)"
  else
    tarifcodeText = ""
  end
end


function QuickApp:getData() -- Get data from Iungo Monitor
  local url = "http://" ..IPaddress ..Path
  
  self.http:request(url, {
  options = {
    data = Method,
    method = "POST",
    headers = {
      ["Content-Type"] = "application/json",
      ["Accept"] = "application/json",
      }
    },
    success = function(response) 
    self:logging(3,"Response status: " ..response.status)
    self:logging(3,"Response data: " ..response.data)

    local apiResult = response.data
    self:logging(4,"apiResult" ..apiResult)
            
    jsonTable = json.decode(apiResult) -- Decode the json string from api to lua-table

    self:getValues() -- Get the values from json file
    self:updateConsumption() -- Store net consumption in unused device
    self:updateLabels() -- Update the labels
    self:updateProperties() -- Update the properties

    end,
    error = function(message)
      self:logging(3,"error: " ..message)
      self:updateProperty("log", "error: " ..json.encode(error))
    end
    })

  fibaro.setTimeout(Interval*1000, function() -- Checks every [Interval] seconds for new data
    self:getData()
  end)
end 


function QuickApp:simData() -- Simulate Iungo Monitor
  apiResult = '{"ok":true,"type":"response","time":0.0026875899638981,"rv":{"propsval":[{"id":"name","value":"EnergieDirect"},{"id":"metertype","value":"XMX"},{"id":"version","value":"5"},{"id":"serial_e","value":"4999999999999999999999999999999996"},{"id":"usage","value":516},{"id":"T1","value":10817.833},{"id":"T2","value":5398.875},{"id":"-T1","value":4379.797},{"id":"-T2","value":9959.182},{"id":"L1I","value":1},{"id":"L2I","value":1},{"id":"L3I","value":2},{"id":"L1Pimp","value":0.054},{"id":"L2Pimp","value":0.125},{"id":"L3Pimp","value":0.336},{"id":"L1Pexp","value":0},{"id":"L2Pexp","value":0},{"id":"L3Pexp","value":0},{"id":"c_tariff","value":2},{"id":"serial_g","value":"4999999999999999999999999999999995"},{"id":"gas_usage","value":0},{"id":"gas","value":3903.388},{"id":"Cost-T1","value":0.20721},{"id":"Cost-T2","value":0.22921},{"id":"Cost-nT1","value":0.20721},{"id":"Cost-nT2","value":0.22921},{"id":"Cost-gas","value":0.7711},{"id":"Gas-interval","value":3600},{"id":"Client-blob","value":""},{"id":"available","value":true}]},"systime":1610986159,"seq":1,"error":false}'
  self:logging(4,"apiResult" ..apiResult)

  jsonTable = json.decode(apiResult) -- Decode the json string from api to lua-table

  self:getValues() -- Get the values from json file
  self:updateConsumption() -- Store net consumption in unused device
  self:updateLabels() -- Update the labels
  self:updateProperties() -- Update the properties

  fibaro.setTimeout(Interval*1000, function() -- Checks every [Interval] seconds for new data
    self:simData()
  end)
end 


function QuickApp:geteDevices() -- Get all Device IDs which measure Energy Consumption
  eDevices = {}
  local devices, status = api.get("/devices?interface=energy")
  self:trace("Updated devicelist devices with energy consumption")
  for k in pairs(devices) do
    table.insert(eDevices,devices[k].id)
  end
  self:logging(2,"Energy Devices: " ..json.encode(eDevices))
end


function QuickApp:getGlobals() -- Get all Global Variables or create them
  IPaddress = self:getVariable("IPaddress")
  Path = self:getVariable("Path")
  Method = self:getVariable("Method")
  powerID = tonumber(self:getVariable("powerID"))
  Interval = tonumber(self:getVariable("Interval")) 
  debugLevel = tonumber(self:getVariable("debugLevel"))

  -- Check existence of the mandatory variables, if not, create them with default values 
  if IPaddress == "" or IPaddress == nil then 
    IPaddress = "192.168.178.12" -- Default IPaddress 
    self:setVariable("IPaddress", IPaddress)
    self:trace("Added QuickApp variable IPaddress")
  end
  if Path == "" or Path == nil then 
    Path = "/iungo/api_request" -- Default Path
    self:setVariable("Path", Path)
    self:trace("Added QuickApp variable Path")
  end  
  if Method == "" or Method == nil then 
    Method = '{"seq":1,"method":"object_list_props_values","arguments":{"oid":"538d72d9"}}' -- Default Method
    self:setVariable("Method", Method)
    self:trace("Added QuickApp variable Method")
  end
  if powerID == "" or powerID == nil then 
    powerID = "0" -- ID of the device where you want to capture the 'delta' power, use 0 if you don't want to store the energy consumption
    self:setVariable("powerID", powerID)
    self:trace("Added QuickApp variable powerID")
    powerID = tonumber(powerID)
  end
  if Interval == "" or Interval == nil then
    Interval = "10" -- Default interval in seconds (The Iungo meter normally reads every 10 seconds)
    self:setVariable("Interval", Interval)
    self:trace("Added QuickApp variable Interval")
    Interval = tonumber(Interval)
  end
  if debugLevel == "" or debugLevel == nil then
    debugLevel = "1" -- Default value for debugLevel
    self:setVariable("debugLevel",debugLevel)
    self:trace("Added QuickApp variable debugLevel")
    debugLevel = tonumber(debugLevel)
  end
  if powerID == 0 or powerID == nil then
    self:warning("No powerID to store net power consumption")
  end
end


function QuickApp:onInit()
    __TAG = fibaro.getName(plugin.mainDeviceId) .." ID:" ..plugin.mainDeviceId
    self:debug("onInit")

    self:getGlobals() -- Get Global Variables
    self:geteDevices() -- Get all Energy Devices

    self.http = net.HTTPClient({timeout=3000})
    
    if tonumber(debugLevel) >= 4 then 
      self:simData() -- Go in simulation
    else
      self:getData() -- Get data from Iungo Monitor
    end
end

-- EOF 
