-- Iungo Monitor main

local version = '2.0 release candidate'

local function getChildVariable(child,varName)
  for _,v in ipairs(child.properties.quickAppVariables or {}) do
    if v.name==varName then return v.value end
  end
  return ""
end


function QuickApp:logging(level,text) -- Logging function for debug
  if tonumber(debugLevel) >= tonumber(level) then 
    self:debug(text)
  end
end


function QuickApp:solarPower(power, m2) -- Calculate Solar Power M2
  self:logging(3,"Quickapp:solarPower")
  if m2 > 0 and power > 0 then
    solarPower = power / m2
  else
    solarPower = 0
  end
  return solarPower
end


function QuickApp:unitCheckWh(measurement) -- Set the measurement and unit to Wh, kWh, MWh or GWh
  self:logging(3,"unitCheckWh() - Set the measurement and unit to Wh, kWh, MWh or GWh")
  if measurement > 1000000000 then
    return string.format("%.3f",measurement/1000000000),"GWh"
  elseif measurement > 1000000 then
    return string.format("%.3f",measurement/1000000),"MWh"
  elseif measurement > 1000 then
    return string.format("%.3f",measurement/1000),"kWh"
  else
    return string.format("%.3f",measurement),"Wh"
  end
end


function QuickApp:recalcMeter(meter,reading) -- Recalculate meter readings
  self:logging(3,"recalcMeter() - Recalculate meter readings")
  if tonumber(meter) > 0 and tonumber(meter) <= tonumber(reading) then
    return string.format("%.3f",reading - meter)
  elseif tonumber(meter) > 0 and tonumber(meter) > tonumber(reading) then
    return string.format("%.3f",reading + meter)
  end
  return string.format("%.3f",reading)
end


function QuickApp:updateProperties() -- Update the properties
  self:logging(3,"updateProperties() - Update the properties")
  self:updateProperty("value", tonumber(string.format("%.3f",data.house_consumption)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.house_consumption)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", data.tarifcodeText .." " ..translation["tarif"])
end


function QuickApp:updateLabels() -- Update the labels 
  self:logging(3,"updateLabels() - Update the labels")
  local labelText = ""
  
  if debugLevel == 4 then
    labelText = labelText ..translation["SIMULATION MODE"]  .."\n\n"
  end
  
  if solarPanel then
    labelText = labelText ..translation["Grid Consumption"] ..": " ..data.grid_consumption .." " .."Watt" .." "  ..data.tarifcodeText .." " ..translation["tarif"] .."\n"
    labelText = labelText ..translation["House"] .." " ..translation["Consumption"] ..": " ..data.house_consumption .." " .."Watt" .."\n"
    labelText = labelText ..translation["Solar"] .." " ..translation["Production"] ..": " ..data.solar .." " .."Watt" .." (" ..solarM2 .." m² / " ..data.solarPower .." " .."Watt/m²)" .."\n"
  else
    labelText = labelText ..translation["Consumption"] ..": " ..data.consumption .." " .."Watt" .."/" ..translation["tarif"] ..": (" ..data.tarifcodeText ..")" .."\n"
  end
  if gasMeterAnalog then
    labelText = labelText ..translation["Gas"] .." " ..translation["Consumption"] ..": " ..data.consumption_gas .." " ..translation["L/min"] .."\n"
  end
  if waterMeter then
    labelText = labelText ..translation["Waterflow"] ..": " ..data.flow .." " ..translation["L/min"] .."\n"
  end
  
  labelText = labelText .."\n" ..translation["Totals"] .." " ..translation["Consumption"] ..":" .."\n"
  labelText = labelText ..translation["Netting"] ..": " ..data.total_netting .." " .."kWh" .."\n" 
  labelText = labelText ..translation["Consumption"] .." " ..translation["high"] ..": " ..data.consumption_high .." " .."kWh" .."\n" 
  labelText = labelText ..translation["Consumption"] .." " ..translation["low"] ..": " ..data.consumption_low .." " .."kWh" .."\n"
  labelText = labelText ..translation["Consumption"] .." " ..translation["total"] ..": " ..data.total_consumption .." " .."kWh" .."\n" 
  labelText = labelText ..translation["Consumption"] .." " ..translation["low"] ..": " ..string.format("%.2f",tonumber(data.consumption_low)*tonumber(data.cost_consumption_low)/100) .." " .."EUR" .." (" ..data.cost_consumption_low .." EURcent)" .."\n" 
  labelText = labelText ..translation["Consumption"] .." " ..translation["high"] ..": " ..string.format("%.2f",tonumber(data.consumption_high)*tonumber(data.cost_consumption_high)/100) .." " .."EUR" .." (" ..data.cost_consumption_high .." EURcent)" .."\n" 
  labelText = labelText ..translation["Consumption"] .." " ..translation["total"] ..": " ..string.format("%.2f",(tonumber(data.consumption_low)*tonumber(data.cost_consumption_low)/100)+(tonumber(data.consumption_high)*tonumber(data.cost_consumption_high)/100)) .." " .."EUR" .." (" ..data.cost_consumption_low .." EURcent)" .."\n\n"
  
  labelText = labelText ..translation["Totals"] .." " ..translation["Production"] ..":" .."\n"
  if solarPanel then
    labelText = labelText ..translation["Solar"] .." " ..translation["Production"] .." " ..translation["total"] ..": " ..data.meterreading .." " ..data.meterreadingUnit .."\n"
  end
  labelText = labelText ..translation["Production"] .." " ..translation["high"] ..": " ..data.production_high .." " .."kWh" .."\n" 
  labelText = labelText ..translation["Production"] .." " ..translation["low"] ..": " ..data.production_low .." " .."kWh" .."\n"
  labelText = labelText ..translation["Production"] .." " ..translation["total"] ..": " ..data.total_production .." " .."kWh" .."\n"
  labelText = labelText ..translation["Production"] .." " ..translation["high"] ..": " ..string.format("%.2f",tonumber(data.production_high)*tonumber(data.cost_production_high)/100) .." " .."EUR" .." (" ..data.cost_production_high .." EURcent)" .."\n" 
  labelText = labelText ..translation["Production"] .." " ..translation["low"] ..": " ..string.format("%.2f",tonumber(data.production_low)*tonumber(data.cost_production_low)/100) .." " .."EUR" .." (" ..data.cost_production_low .." EURcent)" .."\n" 
  labelText = labelText ..translation["Production"] .." " ..translation["total"] ..": " ..string.format("%.2f",(tonumber(data.production_low)*tonumber(data.cost_production_low)/100)+(tonumber(data.production_high)*tonumber(data.cost_production_high)/100)) .." " .."EUR" .." (" ..data.cost_production_low .." EURcent)" .."\n\n"
  
  labelText = labelText ..translation["Totals"] .." " ..translation["Gas"] ..":" .."\n"
  labelText = labelText ..translation["Gas"] .." " ..translation["total"] ..": " ..data.gas .." " .."m³" .."\n"
  labelText = labelText ..translation["Gas"] .." " ..translation["total"] ..": " ..string.format("%.2f",tonumber(data.gas)*tonumber(data.cost_gas)/100) .." " .."EUR" .." (" ..data.cost_gas .." EURcent)" .."\n\n" 
  if waterMeter then
    labelText = labelText ..translation["Totals"] .." " ..translation["Water"] ..":" .."\n"
    labelText = labelText ..translation["Water"] .." " .."total" ..": " ..data.wused .." " .."m³" .."\n\n"
  end
  labelText = labelText ..translation["Ampere"] ..": " .."\n"
  labelText = labelText .."L1" ..": " ..data.L1_A .." " .."L2" ..": " ..data.L2_A .." " .."L3" ..": " ..data.L3_A .."\n\n" 
  
  labelText = labelText ..translation["Voltage"] ..": " .."\n"
  labelText = labelText .."L1" ..": " ..data.L1_V .." " .."L2" ..": " ..data.L2_V .." " .."L3" ..": " ..data.L3_V .."\n\n" 

  labelText = labelText ..translation["Import"] ..": " .."\n"
  labelText = labelText .."L1" ..": " ..data.L1_imp .." " .."L2" ..": " ..data.L2_imp .." " .."L3" ..": " ..data.L3_imp .."\n\n" 

  labelText = labelText ..translation["Export"] ..": " .."\n"
  labelText = labelText .."L1" ..": " ..data.L1_exp .." " .."L2" ..": " ..data.L2_exp .." " .."L3" ..": " ..data.L3_exp .."\n\n" 

  labelText = labelText ..translation["Meter"] ..": " ..data.name .." " ..data.metertype .." " ..data.version .."\n"
  labelText = labelText .."Energy" ..": " ..data.serialE .."\n"
  labelText = labelText ..translation["Gas"] ..": " ..data.serialG .."\n"
  self:updateView("label", "text", labelText)
  self:logging(2,labelText)
end


function QuickApp:valuesWater() -- Update the Water values from json file
  self:logging(3,"valuesWater() - Update the Water values from json file")
  data.flow = string.format("%.3f",jsonTableWater.rv.propsval[2].value)
  data.pulstotal = jsonTableWater.rv.propsval[3].value
  data.kfact = jsonTableWater.rv.propsval[4].value 
  data.offset = jsonTableWater.rv.propsval[5].value
  data.wused = string.format("%.3f",data.pulstotal/data.kfact+data.offset)
  data.wused = self:recalcMeter(meterWater, data.wused)
end


function QuickApp:valuesGas() -- Update the Analog Gas values from json file
  self:logging(3,"valuesGas() - Update the Analog Gas values from json file")
  data.consumption_gas = string.format("%.3f",jsonTableGas.rv.propsval[2].value)
  data.gas = string.format("%.3f",jsonTableGas.rv.propsval[3].value)
  --data.flow = jsonTableGas.rv.propsval[2].value
  data.cost_gas = string.format("%.4f",tonumber(jsonTableGas.rv.propsval[4].value)*100) -- Cost gas
  data.Gasdigits = jsonTableGas.rv.propsval[5].value 
  data.GASrotations = jsonTableGas.rv.propsval[6].value
  data.GASoffset = jsonTableGas.rv.propsval[7].value
  --data.gas = string.format("%.3f",data.GASrotations/data.Gasdigits+data.GASoffset)
  data.gas = self:recalcMeter(meterGas, data.gas)
end


function QuickApp:valuesSolar() -- Update the Solar values from json file
  self:logging(3,"valuesSolar() - Update the Solar values from json file")
  data.solar = string.format("%.1f",jsonTableSolar.rv.propsval[2].value)
  data.pulstotal = string.format("%.3f",jsonTableSolar.rv.propsval[3].value)
  data.ppkwh = string.format("%.3f",jsonTableSolar.rv.propsval[4].value)
  data.offset = string.format("%.3f",jsonTableSolar.rv.propsval[5].value)
  data.meterreading = string.format("%.3f",(tonumber(data.pulstotal)/tonumber(data.ppkwh)+tonumber(data.offset))*1000) -- Calculate meterreading x1000 for Wh values
  data.meterreading, data.meterreadingUnit = self:unitCheckWh(tonumber(data.meterreading)) -- Set measurement and unit to Wh, kWh, MWh or GWh
  data.solarPower = string.format("%.2f",self:solarPower(tonumber(data.solar), tonumber(solarM2)))
  --data.grid_consumption = string.format("%.1f",tonumber(data.consumption) - tonumber(data.solar)) -- Calculate net_consumption
  data.house_consumption = string.format("%.1f",tonumber(data.consumption) + tonumber(data.solar)) -- House_consumption is consumption plus solar
end


function QuickApp:valuesMonitor() -- Update the Monitor values from json file
  self:logging(3,"valuesMonitor() - Update the Monitor values from json file")
  local i=1
  while jsonTableMonitor.rv.propsval[i] do
    --self:logging(4,jsonTableMonitor.rv.propsval[i].id)
    --self:logging(4,jsonTableMonitor.rv.propsval[i].value)
    if jsonTableMonitor.rv.propsval[i].id == "usage" then
      data.consumption = string.format("%.1f",jsonTableMonitor.rv.propsval[i].value) -- Usage form the grid
    elseif jsonTableMonitor.rv.propsval[i].id == "T1" then
      data.consumption_low = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
      data.consumption_low = self:recalcMeter(meterConsLow, data.consumption_low)
    elseif jsonTableMonitor.rv.propsval[i].id == "Cost-T1" then
      data.cost_consumption_low = string.format("%.4f",tonumber(jsonTableMonitor.rv.propsval[i].value)*100)
    elseif jsonTableMonitor.rv.propsval[i].id == "T2" then
      data.consumption_high = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
      data.consumption_high = self:recalcMeter(meterConsHigh, data.consumption_high)
    elseif jsonTableMonitor.rv.propsval[i].id == "Cost-T2" then
      data.cost_consumption_high = string.format("%.4f",tonumber(jsonTableMonitor.rv.propsval[i].value)*100)
    elseif jsonTableMonitor.rv.propsval[i].id == "-T1" then
      data.production_low = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
      data.production_low = self:recalcMeter(meterProdLow, data.production_low)
    elseif jsonTableMonitor.rv.propsval[i].id == "Cost-nT1" then
      data.cost_production_low = string.format("%.4f",tonumber(jsonTableMonitor.rv.propsval[i].value)*100)
    elseif jsonTableMonitor.rv.propsval[i].id == "-T2" then
      data.production_high = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
      data.production_high = self:recalcMeter(meterProdHigh, data.production_high)
    elseif jsonTableMonitor.rv.propsval[i].id == "Cost-nT2" then
      data.cost_production_high = string.format("%.4f",tonumber(jsonTableMonitor.rv.propsval[i].value)*100)
    elseif jsonTableMonitor.rv.propsval[i].id == "gas_usage" and not gasMeterAnalog then
      data.consumption_gas = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "gas" and not gasMeterAnalog then
      data.gas = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
      data.gas = self:recalcMeter(meterGas, data.gas)
    elseif jsonTableMonitor.rv.propsval[i].id == "Cost-gas" and not gasMeterAnalog then
      data.cost_gas = string.format("%.4f",tonumber(jsonTableMonitor.rv.propsval[i].value)*100) -- Cost gas
    elseif jsonTableMonitor.rv.propsval[i].id == "c_tariff" then
      data.tarifcode = tostring(jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "L1I" then -- L1 Ampere
      data.L1_A = string.format("%.0f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "L2I" then -- L2 Ampere
      data.L2_A = string.format("%.0f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "L3I" then -- L3 Ampere
      data.L3_A = string.format("%.0f",jsonTableMonitor.rv.propsval[i].value) 
    elseif jsonTableMonitor.rv.propsval[i].id == "L1U" then -- L1 Voltage
      data.L1_V = string.format("%.0f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "L2U" then -- L2 Voltage
      data.L2_V = string.format("%.0f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "L3U" then -- L3 Voltage
      data.L3_V = string.format("%.0f",jsonTableMonitor.rv.propsval[i].value) 
    elseif jsonTableMonitor.rv.propsval[i].id == "L1Pimp" then -- L1 Import kW
      data.L1_imp = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "L2Pimp" then -- L2 Import kW
      data.L2_imp = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "L3Pimp" then -- L3 Import kW
      data.L3_imp = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "L1Pexp" then -- L1 Export kW
      data.L1_exp = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "L2Pexp" then -- L2 Export kW
      data.L2_exp = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "L3Pexp" then -- L3 Export kW
      data.L3_exp = string.format("%.3f",jsonTableMonitor.rv.propsval[i].value)
    elseif jsonTableMonitor.rv.propsval[i].id == "name" then -- Name
      data.name = jsonTableMonitor.rv.propsval[i].value
    elseif jsonTableMonitor.rv.propsval[i].id == "metertype" then -- Metertype
      data.metertype = jsonTableMonitor.rv.propsval[i].value
    elseif jsonTableMonitor.rv.propsval[i].id == "version" then -- Version
      data.version = jsonTableMonitor.rv.propsval[i].value
    elseif jsonTableMonitor.rv.propsval[i].id == "serial_e" then -- Version
      data.serialE = jsonTableMonitor.rv.propsval[i].value
    elseif jsonTableMonitor.rv.propsval[i].id == "serial_g" then -- Version
      data.serialG = jsonTableMonitor.rv.propsval[i].value
    else
      --self:warning("Unknown measurement value")
    end
    i=i+1
  end
  --data.grid_consumption = string.format("%.1f",tonumber(data.consumption) - tonumber(data.solar)) -- Initial calculation without Solar Panel
  data.grid_consumption = string.format("%.1f",tonumber(data.consumption)) -- Net consumption is equal to consumption
  data.house_consumption = string.format("%.1f",tonumber(data.consumption) + tonumber(data.solar)) -- House_consumption is consumption plus solar
  data.total_consumption = string.format("%.3f",tonumber(data.consumption_low) + tonumber(data.consumption_high))
  data.total_production = string.format("%.3f",tonumber(data.production_low) + tonumber(data.production_high))
  data.total_netting = string.format("%.3f",data.total_consumption - data.total_production)

  if data.tarifcode == "2" then 
    data.tarifcodeText = translation["high"]
  elseif data.tarifcode == "1" then
    data.tarifcodeText = translation["low"]
  else
    data.tarifcodeText = ""
  end
end 


function QuickApp:getData() -- Get data from Iungo Monitor, Solar, Water
  self:logging(3,"getData() - Get data from Iungo Monitor, Solar, Water")
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
      self:logging(3,"Response data: " ..response.data)
      apiResult =  response.data

      if currentMethod == methodMonitor then
        jsonTableMonitor = json.decode(apiResult) -- Decode the json string from api to lua-table Monitor
        self:valuesMonitor() -- Get the values from Monitor json file
        self:updateLabels() -- Update the labels
        self:updateProperties() -- Update the propterties
        self:updateChildDevices() -- Update the Child Devices
        if solarPanel then
          currentMethod = methodSolar
        elseif gasMeterAnalog then
          currentMethod = methodGas
        elseif waterMeter then
          currentMethod = methodWater
        end

      elseif currentMethod == methodSolar then
        jsonTableSolar = json.decode(apiResult) -- Decode the json string lua-table Solarpanel
        self:valuesSolar() -- Get the values from Solar json file
        self:updateLabels() -- Update the labels
        self:updateProperties() -- Update the propterties
        self:updateChildDevices() -- Update the Child Devices
        if gasMeterAnalog then
          currentMethod = methodGas
        elseif waterMeter then 
          currentMethod = methodWater
        else
          currentMethod = methodMonitor
        end
        
      elseif currentMethod == methodGas then
        jsonTableGas = json.decode(apiResult) -- Decode the json string lua-table Analog Gasmeter
        self:valuesGas() -- Get the values from Analog Gas json file
        self:updateLabels() -- Update the labels
        self:updateChildDevices() -- Update the Child Devices
        currentMethod = methodMonitor 

      elseif currentMethod == methodWater then
        jsonTableWater = json.decode(apiResult) -- Decode the json string lua-table Watermeter
        self:valuesWater() -- Get the values from Water json file
        self:updateLabels() -- Update the labels
        self:updateChildDevices() -- Update the Child Devices
        if gasMeterAnalog then
          currentMethod = methodGas
        else
          currentMethod = methodMonitor
        end

      else
        self:warning("No Monitor, Solar, Water or Analog Gas active")
        return
      end

    end,
    error = function(message)
      self:logging(3,"error: " ..message)
      self:updateProperty("log", "error: " ..json.encode(error))
    end
  })
  self:logging(3,"setTimeout " ..interval .." seconds")
  fibaro.setTimeout(interval*1000, function() -- Checks every [interval] seconds for new data
    self:getData()
  end)
end 


function QuickApp:simData() -- Simulate Iungo Monitor, Solar, Water
  self:logging(3,"simData() - Simulate Iungo Monitor, Solar, Water")
  if currentMethod == methodMonitor then
    
    --apiResult = '{"ok":true,"type":"response","time":0.0026875899638981,"rv":{"propsval":[{"id":"name","value":"EnergieDirect"},{"id":"metertype","value":"XMX"},{"id":"version","value":"5"},{"id":"serial_e","value":"4999999999999999999999666666666666"},{"id":"usage","value":516},{"id":"T1","value":10817.833},{"id":"T2","value":5398.875},{"id":"-T1","value":4379.797},{"id":"-T2","value":9959.182},{"id":"L1I","value":1},{"id":"L2I","value":1},{"id":"L3I","value":2},{"id":"L1Pimp","value":0.054},{"id":"L2Pimp","value":0.125},{"id":"L3Pimp","value":0.336},{"id":"L1Pexp","value":0},{"id":"L2Pexp","value":0},{"id":"L3Pexp","value":0},{"id":"c_tariff","value":2},{"id":"serial_g","value":"4999999999999999999999999999999996"},{"id":"gas_usage","value":1},{"id":"gas","value":3903.388},{"id":"Cost-T1","value":0.20721},{"id":"Cost-T2","value":0.22921},{"id":"Cost-nT1","value":0.20721},{"id":"Cost-nT2","value":0.22921},{"id":"Cost-gas","value":0.7711},{"id":"Gas-interval","value":3600},{"id":"Client-blob","value":""},{"id":"available","value":true}]},"systime":1610986159,"seq":1,"error":false}' -- Old API version

    --apiResult = '{"ok":true,"type":"response","time":0.0024689069832675,"rv":{"propsval":[{"id":"name","value":"EnergieDirect"},{"id":"metertype","value":"XMX"},{"id":"version","value":"5"},{"id":"serial_e","value":"4999999999999999999999666666666666"},{"id":"usage","value":740},{"id":"T1","value":17096.104},{"id":"T2","value":8852.012},{"id":"-T1","value":7768.567},{"id":"-T2","value":17359.683},{"id":"L1I","value":1},{"id":"L2I","value":1},{"id":"L3I","value":3},{"id":"L1Pimp","value":0.031},{"id":"L2Pimp","value":0.128},{"id":"L3Pimp","value":0.581},{"id":"L1Pexp","value":0},{"id":"L2Pexp","value":0},{"id":"L3Pexp","value":0},{"id":"c_tariff","value":1},{"id":"serial_g","value":"4999999999999999999999999999999996"},{"id":"gas_usage","value":0},{"id":"gas","value":5779.389},{"id":"Cost-T1","value":0.36789},{"id":"Cost-T2","value":0.37031},{"id":"Cost-nT1","value":0.36789},{"id":"Cost-nT2","value":0.37031},{"id":"netting","value":"off"},{"id":"Cost-net-comp","value":0},{"id":"Cost-gas","value":1.2987},{"id":"Gas-interval","value":3600},{"id":"Client-blob","value":""},{"id":"available","value":true}]},"systime":1700510795,"seq":1,"error":false}' -- New API version

    apiResult =  '{"ok":true,"type":"response","time":0.0026876579795498,"rv":{"propsval":[{"id":"name","value":"EnergieDirect"},{"id":"metertype","value":"XMX"},{"id":"version","value":"5"},{"id":"serial_e","value":"4999999999999999999999666666666666"},{"id":"usage","value":501},{"id":"T1","value":17157.847},{"id":"T2","value":8929.761},{"id":"-T1","value":7770.154},{"id":"-T2","value":17361.077},{"id":"L1I","value":1},{"id":"L2I","value":1},{"id":"L3I","value":2},{"id":"L1Pimp","value":0.189},{"id":"L2Pimp","value":0},{"id":"L3Pimp","value":0.312},{"id":"L1Pexp","value":0},{"id":"L2Pexp","value":0},{"id":"L3Pexp","value":0},{"id":"c_tariff","value":2},{"id":"serial_g","value":"4999999999999999999999999999999996"},{"id":"gas_usage","value":0},{"id":"gas","value":5795.05},{"id":"Cost-T1","value":0.36789},{"id":"Cost-T2","value":0.37031},{"id":"Cost-nT1","value":0.36789},{"id":"Cost-nT2","value":0.37031},{"id":"netting","value":"off"},{"id":"Cost-net-comp","value":0},{"id":"Cost-gas","value":1.2987},{"id":"Gas-interval","value":3600},{"id":"Client-blob","value":""},{"id":"crc_err","value":2},{"id":"available","value":true}]},"systime":1701084126,"seq":1,"error":false}' -- New (November 2023) API version with extra L1U, L2U and L3U

    --apiResult =  '{"ok":true,"type":"response","time":0.0039377399953082,"rv":{"propsval":[{"id":"name","value":"Kosten"},{"id":"metertype","value":"Ene"},{"id":"version","value":"5"},{"id":"serial_e","value":"4999999999999999999999666666666666"},{"id":"usage","value":489},{"id":"T1","value":8945.53},{"id":"T2","value":4963.677},{"id":"-T1","value":2051.765},{"id":"-T2","value":6024.202},{"id":"L1I","value":3},{"id":"L1Pimp","value":0.489},{"id":"L1Pexp","value":0},{"id":"c_tariff","value":1},{"id":"serial_g","value":"4999999999999999999999999999999996"},{"id":"gas_usage","value":0},{"id":"gas","value":3143.767},{"id":"Cost-T1","value":0.18875},{"id":"Cost-T2","value":0.18875},{"id":"Cost-nT1","value":0.18875},{"id":"Cost-nT2","value":0.18875},{"id":"Cost-gas","value":0.64413},{"id":"Gas-interval","value":300},{"id":"Client-blob","value":""},{"id":"available","value":true}]},"systime":1611347255,"seq":1,"error":false}' -- Iungo Monitor Lite/Basic version
    
    jsonTableMonitor = json.decode(apiResult) -- Decode the json string from api to lua-table Monitor
    self:valuesMonitor() -- Get the values from Monitor json file
    self:updateLabels() -- Update the labels
    self:updateProperties() -- Update the propterties
    self:updateChildDevices() -- Update the Child Devices
    if solarPanel then
      currentMethod = methodSolar
    elseif gasMeterAnalog then
      currentMethod = methodGas
    elseif waterMeter then
      currentMethod = methodWater
    end
  
  elseif currentMethod == methodSolar then
    apiResult = '{"ok":true,"type":"response","time":0.0016563490498811,"rv":{"propsval":[{"id":"name","value":"20 panelen"},{"id":"solar","value":500.4},{"id":"pulstotal","value":16575341},{"id":"ppkwh","value":800},{"id":"offset","value":292.07},{"id":"connection","value":"breakout"},{"id":"functiongroup","value":"solar"}]},"systime":1611237657,"seq":1,"error":false}' -- Iungo Solarpanel    
    jsonTableSolar = json.decode(apiResult) -- Decode the json string lua-table Solarpanel
    self:valuesSolar() -- Get the values from Solar json file
    self:updateLabels() -- Update the labels
    self:updateChildDevices() -- Update the Child Devices
    if gasMeterAnalog then
      currentMethod = methodGas
    elseif waterMeter then 
      currentMethod = methodWater
    else
      currentMethod = methodMonitor
    end

  elseif currentMethod == methodGas then
    apiResult = '{"ok":true,"type":"response","time":0.0018438370898366,"rv":{"propsval":[{"id":"name","value":"-"},{"id":"gas_usage","value":1},{"id":"gas","value":5005.31},{"id":"Cost-gas","value":0.74},{"id":"Gas-digits","value":100},{"id":"GAS-rotations","value":385780},{"id":"GAS-offset","value":1147.51},{"id":"fw-version","value":"3.2"},{"id":"Client-blob","value":""},{"id":"available","value":true}]},"systime":1637350411,"seq":1,"error":false}' -- Iungo Analog Gas Meter
    jsonTableGas = json.decode(apiResult) -- Decode the json string lua-table Analog Gasmeter
    self:valuesGas() -- Get the values from Analog Gas json file
    self:updateLabels() -- Update the labels
    self:updateChildDevices() -- Update the Child Devices
    currentMethod = methodMonitor

  elseif currentMethod == methodWater then
    apiResult = '{"ok":true,"type":"response","time":0.0010625629220158,"rv":{"propsval":[{"id":"name","value":"Water"},{"id":"flow","value":2},{"id":"pulstotal","value":456523},{"id":"kfact","value":1000},{"id":"offset","value":-47.091},{"id":"tariff","value":0.9616},{"id":"connection","value":"breakout_ch2"}]},"systime":1611765184,"seq":1,"error":false}' -- Iungo Watermeter    
    jsonTableWater = json.decode(apiResult) -- Decode the json string lua-table Watermeter
    self:valuesWater() -- Get the values from Water json file
    self:updateLabels() -- Update the labels
    self:updateChildDevices() -- Update the Child Devices
    if gasMeterAnalog then
      currentMethod = methodGas
    else
      currentMethod = methodMonitor
    end

  else
    self:warning("No Monitor, Solar Water or Analog Gas active")
    return 
  end

  self:logging(3,"setTimeout " ..interval .." seconds")
  fibaro.setTimeout(interval*1000, function() -- Checks every [interval] seconds for new data
    self:simData()
  end)
end 


function QuickApp:createVariables() -- Create Variables
  self:logging(3,"createVariables() - Create Variables")
  Path = "/iungo/api_request" -- Default Path
  methodMonitor = '{"seq":1,"method":"object_list_props_values","arguments":{"oid":"' ..monitorOID ..'"}}' -- Default Method for Iungo Monitor
  methodSolar = '{"seq":1,"method":"object_list_props_values","arguments":{"oid":"' ..solarOID ..'"}}' -- Default Method for Iungo Solarpanel
  methodWater = '{"seq":1,"method":"object_list_props_values","arguments":{"oid":"' ..waterOID ..'"}}' -- Default Method for Iungo Watermeter
  methodGas = '{"seq":1,"method":"object_list_props_values","arguments":{"oid":"' ..gasAnalogOID ..'"}}' -- Default Method for Iungo Analog Gasmeter
  currentMethod = methodMonitor -- Set default Method to Iungo Monitor Method
  
  data = {}
  data.grid_consumption = "0"
  data.house_consumption = "0"
  data.consumption = "0" 
  data.consumption_low = "0" 
  data.consumption_high = "0" 
  data.production_low = "0" 
  data.production_high = "0" 
  data.cost_consumption_low = "0" 
  data.cost_consumption_high = "0" 
  data.cost_production_low = "0" 
  data.cost_production_high = "0" 
  data.L1_A = "0" 
  data.L2_A = "0" 
  data.L3_A = "0"   
  data.L1_V = "0" 
  data.L2_V = "0" 
  data.L3_V = "0" 
  data.L1_imp = "0"
  data.L2_imp = "0"
  data.L3_imp = "0"
  data.L1_exp = "0"
  data.L2_exp = "0"
  data.L3_exp = "0"
  data.consumption_gas = "0" 
  data.gas = "0" 
  data.cost_gas = "0" 
  
  data.tarifcode = ""
  data.total_consumption = "0"  
  data.total_production = "0" 
  data.total_netting = "0" 
  
  data.solar = "0"
  data.solarPower = "0" 
  data.tarifcodeText = " "
  data.meterreading = "0"
  data.meterreadingUnit = " "

  data.GASrotations = "0"
  data.Gasdigits = "0"
  data.GASoffset = "0"

  data.flow = "0"
  data.wused = "0"
  data.pulstotal = "0"
  data.ppkwh = "0"
  data.offset = "0"
  data.kfact = "0"
  
  data.name = " "
  data.metertype = " "
  data.version = " "
  data.serialE = " " 
  data.serialG = " " 
end


function QuickApp:getQuickAppVariables() -- Get all getQuickApp Variables or create them
  IPaddress = self:getVariable("IPaddress")
  interval = tonumber(self:getVariable("interval")) 
  debugLevel = tonumber(self:getVariable("debugLevel"))
  local language = string.lower(self:getVariable("language"))
  solarPanel = string.lower(self:getVariable("solarPanel"))
  waterMeter = string.lower(self:getVariable("waterMeter"))
  gasMeterAnalog = string.lower(self:getVariable("gasMeterAnalog"))
  solarM2 = tonumber(self:getVariable("solarM2"))
  monitorOID = self:getVariable("monitorOID")
  solarOID = self:getVariable("solarOID")
  gasAnalogOID = self:getVariable("gasAnalogOID")
  waterOID = self:getVariable("waterOID")
  meterEnergyD = self:getVariable("meterEnergyD")
  meterConsHigh = tonumber(self:getVariable("meterConsHigh"))
  meterConsLow = tonumber(self:getVariable("meterConsLow"))
  meterProdHigh = tonumber(self:getVariable("meterProdHigh"))
  meterProdLow = tonumber(self:getVariable("meterProdLow"))
  meterGasD = self:getVariable("meterGasD")
  meterGas = tonumber(self:getVariable("meterGas"))
  meterWaterD = self:getVariable("meterWaterD")
  meterWater = tonumber(self:getVariable("meterWater"))


  -- Check existence of the mandatory variables, if not, create them with default values 
  if IPaddress == "" or IPaddress == nil then 
    IPaddress = "192.168.178.12" -- Default IPaddress of Iungo Monitor
    self:setVariable("IPaddress", IPaddress)
    self:trace("Added QuickApp variable IPaddress")
  end
  if interval == "" or interval == nil then
    interval = "10" -- Default interval in seconds (The Iungo meter normally reads every 10 seconds)
    self:setVariable("interval", interval)
    self:trace("Added QuickApp variable interval")
    interval = tonumber(interval)
  end
  if debugLevel == "" or debugLevel == nil then
    debugLevel = "4" -- Default value for debugLevel is "4"
    self:setVariable("debugLevel",debugLevel)
    self:trace("Added QuickApp variable debugLevel")
    debugLevel = tonumber(debugLevel)
  end
  if language == "" or language == nil or type(i18n:translation(string.lower(self:getVariable("language")))) ~= "table" then
    language = "en" 
    self:setVariable("language",language)
    self:trace("Added QuickApp variable language")
    translation = i18n:translation(string.lower(self:getVariable("language"))) -- (Extra) Initialise the translation because of early createVariables()
  end
  if solarPanel == "" or solarPanel == nil then 
    solarPanel = "false" -- Default availability of solarPanel is "false"
    self:setVariable("solarPanel",solarPanel)
    self:trace("Added QuickApp variable solarPanel")
  end  
  if gasMeterAnalog == "" or gasMeterAnalog == nil then 
    gasMeterAnalog = "false" -- Default availability of gasMeterAnalog is "false"
    self:setVariable("gasMeterAnalog",gasMeterAnalog)
    self:trace("Added QuickApp variable gasMeterAnalog")
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
  if monitorOID == "" or monitorOID == nil then 
    monitorOID = "538d72d9" -- ObjectID of the monitor
    self:setVariable("monitorOID",monitorOID)
    self:trace("Added QuickApp variable monitorOID")
  end
  if solarOID == "" or solarOID == nil then 
    solarOID = "95778a43" -- ObjectID of the solar monitor
    self:setVariable("solarOID",solarOID)
    self:trace("Added QuickApp variable solarOID")
  end
  if gasAnalogOID == "" or gasAnalogOID == nil then 
    gasAnalogOID = "06e869e1" -- ObjectID of the analog gas meter
    self:setVariable("gasAnalogOID",gasAnalogOID)
    self:trace("Added QuickApp variable gasAnalogOID")
  end
  if waterOID == "" or waterOID == nil then 
    waterOID = "82ec52ad" -- ObjectID of the water meter
    self:setVariable("waterOID",waterOID)
    self:trace("Added QuickApp variable waterOID")
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
  if meterEnergyD == "" or meterEnergyD == nil then 
    meterEnergyD = "00-00-0000" 
    self:setVariable("meterEnergyD", meterEnergyD)
    self:trace("Added QuickApp variable meterEnergyD")
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
  if gasMeterAnalog == "true" then 
    gasMeterAnalog = true 
  else
    gasMeterAnalog = false
  end
  if waterMeter == "true" then 
    waterMeter = true 
  else
    waterMeter = false
  end

  if meterEnergyD == "0" or meterEnergyD == "00-00-0000" then
    meterEnergyD = ""
  else 
    meterEnergyD = translation["Since"] ..": " ..meterEnergyD
  end
  if meterGasD == "0" or meterGasD == "00-00-0000" then
    meterGasD = ""
  else
    meterGasD = translation["Since"] ..": " ..meterGasD
  end
  if meterWaterD == "0" or meterWaterD == "00-00-0000" then
    meterWaterD = ""
  else 
    meterWaterD = translation["Since"] ..": " ..meterWaterD
  end
  
  local sum = 1
  if solarPanel then
    sum = sum+1
  end
  if waterMeter then
    sum = sum+1
  end
  if gasMeterAnalog then
    sum = sum+1
  end
  interval = tonumber(string.format("%.3f", interval / sum))
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
      {className="consumption", name="Consumption", type="com.fibaro.powerMeter", value=0},
      {className="production", name="Production", type="com.fibaro.powerMeter", value=0},
      {className="solarPower", name="Solar Power", type="com.fibaro.powerMeter", value=0},
      {className="gas_usage", name="Gas usage", type="com.fibaro.gasMeter", value=0},
      {className="waterflow", name="Water Flow", type="com.fibaro.waterMeter", value=0},
      {className="consumption_high", name="Consumption High", type="com.fibaro.energyMeter", value=0},
      {className="consumption_low", name="Consumption Low", type="com.fibaro.energyMeter", value=0},
      {className="production_high", name="Production High", type="com.fibaro.energyMeter", value=0},
      {className="production_low", name="Production Low", type="com.fibaro.energyMeter", value=0},
      {className="netting", name="Total Netting", type="com.fibaro.powerMeter", value=0},
      {className="gas", name="Total Gas", type="com.fibaro.gasMeter", value=0},
      {className="total_waterflow", name="Total Water Flow", type="com.fibaro.waterMeter", value=0},
      {className="L1_A", name="Ampere L1", type="com.fibaro.electricMeter", value=0},
      {className="L2_A", name="Ampere L2", type="com.fibaro.electricMeter", value=0},
      {className="L3_A", name="Ampere L3", type="com.fibaro.electricMeter", value=0},
      {className="L1_V", name="Voltage L1", type="com.fibaro.electricMeter", value=0},
      {className="L2_V", name="Voltage L2", type="com.fibaro.electricMeter", value=0},
      {className="L3_V", name="Voltage L3", type="com.fibaro.electricMeter", value=0},
      {className="L1_imp", name="Import L1", type="com.fibaro.powerMeter", value=0},
      {className="L2_imp", name="Import L2", type="com.fibaro.powerMeter", value=0},
      {className="L3_imp", name="Import L3", type="com.fibaro.powerMeter", value=0},
      {className="L1_exp", name="Export L1", type="com.fibaro.powerMeter", value=0},
      {className="L2_exp", name="Export L2", type="com.fibaro.powerMeter", value=0},
      {className="L3_exp", name="Export L3", type="com.fibaro.powerMeter", value=0},
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
  self:debug("onInit Iungo Monitor - Version "..version.." - ⓒ by SmartHomeEddy")
  
  self:setupChildDevices()
  
  if not api.get("/devices/"..self.id).enabled then
    self:warning("Device", fibaro.getName(plugin.mainDeviceId), "is disabled")
    return
  end
  
  self:getQuickAppVariables() -- Get QuickApp Variables
  self:createVariables() -- Create all Variables

  self.http = net.HTTPClient({timeout=3000})
  
  if tonumber(debugLevel) >= 4 then 
    self:simData() -- Go in simulation
  else
    self:getData() -- Get data from Iungo Monitor, Solarpanel, Watermeter and or Analog Gasmeter
  end
end

-- EOF 