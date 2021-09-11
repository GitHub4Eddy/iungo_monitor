# iungo_monitor

This Quickapp (for the Fibaro Homecenter 3) retrieves power consumption, solar production, gas usage and water flow from the Iungo Monitor, Solarpanel and Watermeter

(Child) Devices for Consumption, Production, Solar Power, Water Flow, Consumption High, Consumption Low, Production High, Production Low, Total Gas and Total Water FLow

Version 1.1 (11th September 2021)
- Changed the Child Devices Consumption High, Consumption Low, Production High and Production Low to device type energyMeter to facilitate the new Energy Panel
- Added automaticaly change rateType interface of Child device Consumption High and Low to "consumption" and Production High and Low to "production"
- Changed the Main Device to device type powerSensor to show the power graphs
- Added Net Consumption to the value of the Main Device 
- Changed the Child Devices Consumption, Production and Solar Power to device type powerSensor to show the power graphs 
- Changed the Water Flow unit text from m³ to Litre
- Added the amount of m2 Solar Panels to the log text ot the Child Device Solar Power and to the labels
- Changed meterreading to automatically kWh, MWh of GWh
- Moved tarif informatie to main device log text
- Added Meter measurement for Consumption High, Consumption Low, Production High, Production Low, Gas and Water to reset the measurements
- Added Meter measurement Date for Consumption High, Consumption Low, Production High, Production Low, Gas and Water
- Removed Refresh button
- Added some extra debug information when debug level = 3

Version 1.0 (6th February 2021)
- Now also supports Iungo Solarpanel and Iungo Watermeter
- Added a lot of Child devices
- Added QuickApp Variable for user defined icon Mother Device
- Added QuickApp Variable for Solar Power m2
- Removed calculation and storage of energy consumption of Fibaro devices

Version 0.6 (22nd January 2021)
- Now also supports Iungo basic version

Version 0.5 (21 January 2021)
- Initial version

Variables (mandatory and automaticaly generated): 
- IPaddress = IP address of your Iungo Monitor
- solarPanel = true or false for use of the SolarPanel module (default is false)
- waterMeter = true or false for use of the Watermeter module (default is false)
- interval = Number in seconds, the Lungo Monitor normally is updated every 10 seconds
- solarM2 = The amount of m2 Solar Panels (use . for decimals) for calculating Solar Power m2
- debugLevel = Number (1=some, 2=few, 3=all, 4=simulation mode) (default = 1)
- meterConsHigh = Last meter measurement Consumption High
- meterConsLow = Last meter measurement Consumption Low
- meterProdHigh = Last meter measurement Production High 
- meterProdLow = Last meter measurement Production Low 
- meterGas = Last meter measurement Gas 
- meterWater = Last meter measurement Water 
- meterConsHighD = Date last meter measurement Consumption High
- meterConsLowD = Date last meter measurement Consumption Low
- meterProdHighD = Date last meter measurement Production High 
- meterProdLowD = Date last meter measurement Production Low 
- meterGasD = Date last meter measurement Gas 
- meterWaterD = Date last meter measurement Water 
