# iungo_monitor

This Quickapp retrieves power consumption, solar production, gas usage and water flow from the Iungo Monitor, Solarpanel and Watermeter

(Child) Devices for Net Consumption, House Consumption, Solar Production, Solar Power, Water Flow, Consumption High, Consumption Low, Production High, Production Low, Total Gas and Total Water FLow

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
- icon = User defined icon number (add the icon via an other device and lookup the number, like 1020)
