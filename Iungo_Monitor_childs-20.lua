-- Iungo Monitor childs


class 'consumption'(QuickAppChild)
function consumption:__init(dev)
  QuickAppChild.__init(self,dev)
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
end
function solarPower:updateValue(data) 
  self:updateProperty("value", tonumber(data.solarPower))
  self:updateProperty("power", tonumber(data.solarPower))
  self:updateProperty("unit", "Watt/m²")
  self:updateProperty("log", solarM2 .." m² " ..translation["Panels"])
end


class 'gas_usage'(QuickAppChild)
function gas_usage:__init(dev)
  QuickAppChild.__init(self,dev)
end
function gas_usage:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.0f",data.consumption_gas)))
  self:updateProperty("unit", "L/min")
  self:updateProperty("log", " ")
end


class 'waterflow'(QuickAppChild)
function waterflow:__init(dev)
  QuickAppChild.__init(self,dev)
end
function waterflow:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.0f",data.flow)))
  self:updateProperty("unit", "L/min")
  self:updateProperty("log", " ")
end


class 'consumption_high'(QuickAppChild)
function consumption_high:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Consumption High child device (" ..self.id ..") to consumption")
  end
end
function consumption_high:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption_high)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", meterEnergyD)
end


class 'consumption_low'(QuickAppChild)
function consumption_low:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Consumption High child device (" ..self.id ..") to consumption")
  end
end
function consumption_low:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption_low)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", meterEnergyD)
end


class 'production_high'(QuickAppChild)
function production_high:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Production High child device (" ..self.id ..") to production")
  end
end
function production_high:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production_high)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", meterEnergyD)
end


class 'production_low'(QuickAppChild)
function production_low:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Production High child device (" ..self.id ..") to production")
  end
end
function production_low:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production_low)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", meterEnergyD)
end


class 'netting'(QuickAppChild)
function netting:__init(dev)
  QuickAppChild.__init(self,dev)
end
function netting:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.0f", data.total_netting)))
  self:updateProperty("power", tonumber(string.format("%.0f", data.total_netting)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", meterEnergyD)
end


class 'gas'(QuickAppChild)
function gas:__init(dev)
  QuickAppChild.__init(self,dev)
end
function gas:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.gas)))
  self:updateProperty("unit", "m³")
  self:updateProperty("log", meterGasD)
end


class 'total_waterflow'(QuickAppChild)
function total_waterflow:__init(dev)
  QuickAppChild.__init(self,dev)
end
function total_waterflow:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.wused)))
  self:updateProperty("unit", "m³")
  self:updateProperty("log", meterWaterD)
end


class 'L1_A'(QuickAppChild)
function L1_A:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Todays Consumption child device (" ..self.id ..") to consumption")
  end
end
function L1_A:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.1f",data.L1_A)))
  self:updateProperty("unit", translation["Amp"])
  self:updateProperty("log", "")
end


class 'L2_A'(QuickAppChild)
function L2_A:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Todays Consumption child device (" ..self.id ..") to consumption")
  end
end
function L2_A:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.1f",data.L2_A)))
  self:updateProperty("unit", translation["Amp"])
  self:updateProperty("log", "")
end


class 'L3_A'(QuickAppChild)
function L3_A:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Todays Consumption child device (" ..self.id ..") to consumption")
  end
end
function L3_A:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.1f",data.L3_A)))
  self:updateProperty("unit", translation["Amp"])
  self:updateProperty("log", "")
end


class 'L1_V'(QuickAppChild)
function L1_V:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Todays Consumption child device (" ..self.id ..") to consumption")
  end
end
function L1_V:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.0f",data.L1_V)))
  self:updateProperty("unit", translation["Volt"])
  self:updateProperty("log", "")
end


class 'L2_V'(QuickAppChild)
function L2_V:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Todays Consumption child device (" ..self.id ..") to consumption")
  end
end
function L2_V:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.0f",data.L2_V)))
  self:updateProperty("unit", translation["Volt"])
  self:updateProperty("log", "")
end


class 'L3_V'(QuickAppChild)
function L3_V:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Todays Consumption child device (" ..self.id ..") to consumption")
  end
end
function L3_V:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.0f",data.L3_V)))
  self:updateProperty("unit", translation["Volt"])
  self:updateProperty("log", "")
end


class 'L1_imp'(QuickAppChild)
function L1_imp:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Todays Production child device (" ..self.id ..") to production")
  end
end
function L1_imp:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.L1_imp)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.L1_imp)))
  self:updateProperty("unit", "kW")
  self:updateProperty("log", " ")
end


class 'L2_imp'(QuickAppChild)
function L2_imp:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Todays Production child device (" ..self.id ..") to production")
  end
end
function L2_imp:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.L2_imp)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.L2_imp)))
  self:updateProperty("unit", "kW")
  self:updateProperty("log", " ")
end


class 'L3_imp'(QuickAppChild)
function L3_imp:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Todays Production child device (" ..self.id ..") to production")
  end
end
function L3_imp:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.L3_imp)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.L3_imp)))
  self:updateProperty("unit", "kW")
  self:updateProperty("log", " ")
end


class 'L1_exp'(QuickAppChild)
function L1_exp:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Todays Production child device (" ..self.id ..") to production")
  end
end
function L1_exp:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.L1_exp)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.L1_exp)))
  self:updateProperty("unit", "kW")
  self:updateProperty("log", " ")
end


class 'L2_exp'(QuickAppChild)
function L2_exp:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Todays Production child device (" ..self.id ..") to production")
  end
end
function L2_exp:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.L2_exp)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.L2_exp)))
  self:updateProperty("unit", "kW")
  self:updateProperty("log", " ")
end


class 'L3_exp'(QuickAppChild)
function L3_exp:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Todays Production child device (" ..self.id ..") to production")
  end
end
function L3_exp:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.L3_exp)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.L3_exp)))
  self:updateProperty("unit", "kW")
  self:updateProperty("log", " ")
end

-- EOF