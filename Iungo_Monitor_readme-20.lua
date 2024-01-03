--[[ Iungo Monitor readme

This QuickApp retrieves power consumption, solar production, energy usage, gas and water usage from the Iungo Monitor, Solarpanel Analog Gasmeter and Watermeter. 
(Child) Devices for Consumption, Production, Solar Power, Gas usage, Water Flow, Consumption High, Consumption Low, Production High, Production Low, Total Netting, Total Gas, Total Water FLow, Ampere L1-L2-L3, Voltage L1-L2-L3, Import L1-L2-L3 (in kW) and Export L1-L2-L3 (in kW). 

The QuickApp works with the standalone Iungo or Iungo with BreakOutBox (max. extra 3 devices for Solar, Water and Gas analog). 


Iungo OIDs:
- Monitor: 538d72d9 (default)
- Solar: 95778a43 (default)
- Water: 82ec52ad (default) or 40c3afff
- Gas analog: 06e869e1
- Modbus: 06f6c748
- Not effective smd220-Modbus 88a7d1ea or sdm630-Modbus 64904b93


Tested with Iungo version 1.5, revision 4444, date Nov 17 2023 with the help of Twanve (thanks) from the Fibaro forum. 


Version 2.0 (3rd January 2024)
- Added support for the newest API
- Changed device types to the newest powerSensor --> powerMeter, multilevelSensor --> gasMeter or waterMeter
- Added Child devices for Total Netting, Gas usage, Ampere L1-L2-L3, Voltage L1-L2-L3, Import L1-L2-L3 (kW), Export L1-L2-L3 (kW)
- Added extra values to the labels: Total Netting, Ampere L1-L2-L3, Voltage L1-L2-L3, Import L1-L2-L3 kW, Export L1-L2-L3 kW, Cost consumption low and high, Cost production low and high, Cost gast, metername, type, version and serial number
- Improved the calculations of grid consumption and house consumption
- Changed the Gas en Water labels to L/min
- Changed to multi-file
- Added translations for English, Dutch, French and Polish
- Added a separate Gas analog meter for those who have an Analog Gas Meter and Iungo addon
- Added support for the Iungo Modbus addon
- Added the ability to change the OID's
- Meter measurement now can also be used for adding up the readings for Consumption High and Low, Production High and Low, Gas and Water to reset the measurements also upwards 


Version 1.1 (11th September 2021)
- Changed the Child Devices Consumption High, Consumption Low, Production High and Production Low to device type energyMeter to facilitate the new Energy Panel
- Added automaticaly change rateType interface of Child device Consumption High and Low to "consumption" and Production High and Low to "production"
- Changed the Main Device to device type powerSensor to show the power graphs
- Added Net Consumption to the value of the Main Device 
- Changed the Child Devices Consumption, Production and Solar Power to device type powerSensor to show the power graphs 
- Changed the Water Flow unit text from m³ to Litre
- Added the amount of m² Solar Panels to the log text ot the Child Device Solar Power and to the labels
- Changed meterreading to automatically kWh, MWh of GWh
- Moved tarif informatie to main device log text
- Added Meter measurement for Consumption High, Consumption Low, Production High, Production Low, Gas and Water to reset the measurements
- Added Meter measurement Date for Consumption High, Consumption Low, Production High, Production Low, Gas and Water
- Removed Refresh button
- Added some extra debug information for debug level = 3

Version 1.0 (6th February 2021)
- Now also supports Iungo Solarpanel and Iungo Watermeter
- Added a lot of Child devices
- Added QuickApp Variable for user defined icon Mother Device
- Added QuickApp Variable for Solar Power m²
- Removed calculation and storage of energy consumption of Fibaro devices

Version 0.6 (22th January 2021)
- Now also supports Iungo basic version

Version 0.5 (21th January 2021)
- Initial version


Variables (mandatory and automaticaly generated): 
- IPaddress = IP address of your Iungo Monitor
- interval = Number in seconds, the Lungo Monitor normally is updated every 10 seconds (the interval gets devided by the amount of addons you have (next to the Iungo monitor, solarpanel, gasmeter analog or water meter))
- debugLevel = Number (1=some, 2=few, 3=all, 4=simulation mode) (default = 1)
- language = Preferred language (default = en) (supported languages are Engish (en), French (fr), Polish (pl) and Dutch (nl))
- solarPanel = true or false for use of the SolarPanel module (default is false)
- gasMeterAnalog = true or false for use of the analog Gasmeter module (default is false)
- waterMeter = true or false for use of the Watermeter module (default is false)
- monitorOID = monitor objectID (default is 538d72d9 or if you have the Modbus version: 06f6c748)
- solarOID = solar objectID (default is 95778a43)
- gasAnalogOID = analog gas meter objectID (default is 0, but if you have one, use 06e869e1)
- waterOID = water meter objectID (default is 82ec52ad or use 40c3afff)
- solarM2 = The amount of m² Solar Panels (use . (dot) for decimals) for calculating Solar Power m²
- meterConsHigh = Last meter measurement Consumption High (kWh)
- meterConsLow = Last meter measurement Consumption Low (kWh)
- meterProdHigh = Last meter measurement Production High (kWh)
- meterProdLow = Last meter measurement Production Low (kWh)
- meterGas = Last meter measurement Gas (m³)
- meterWater = Last meter measurement Water (L/min)
- meterEnergyD = Date last Energy meter measurement
- meterGasD = Date last Gas meter measurement  
- meterWaterD = Date last Water meter measurement  
]]

-- EOF