# iungo_monitor
This Quickapp retrieves power consumption, power production and gas usage from the (Iungo Monitor) energy and gas meter. 
All power consumption of all HomeCenter devices is summerized. 
The difference between the total power consumption and the power consumption of the HomeCenter devices is put in a unused device (unless the powerID = 0 or empty). 
In the QuickApp labels power consumption, power production and gas usage is shown. 
The net consumption is also shown in de log (under the icon). 


Version 0.4 (20th January 2021)
- Initial version


Variables (mandatory and automaticaly generated): 
- IPaddress = IP address of your Iungo Monitor
- Path = Path, normally "/iungo/api_request" (don't changes unless you know what you are doing)
- Method = Method, normally '{"seq":1,"method":"object_list_props_values","arguments":{"oid":"538d72d9"}}' (don't changes unless you know what you are doing)
- Interval = Number in seconds, the Lungo Monitor normally is updated every 10 seconds
- powerID = ID of the device where you want to capture the 'delta' power, use 0 if you don't want to store the energy consumption
- debugLevel = Number (1=some, 2=few, 3=all, 4=simulation mode) (default = 1)

Example content Json table
{"ok":true,"type":"response","time":0.0026875899638981,"rv":{"propsval":[{"id":"name","value":"EnergieDirect"},{"id":"metertype","value":"XMX"},{"id":"version","value":"5"},{"id":"serial_e","value":"4999999999999999999999999999999996"},{"id":"usage","value":516},{"id":"T1","value":10817.833},{"id":"T2","value":5398.875},{"id":"-T1","value":4379.797},{"id":"-T2","value":9959.182},{"id":"L1I","value":1},{"id":"L2I","value":1},{"id":"L3I","value":2},{"id":"L1Pimp","value":0.054},{"id":"L2Pimp","value":0.125},{"id":"L3Pimp","value":0.336},{"id":"L1Pexp","value":0},{"id":"L2Pexp","value":0},{"id":"L3Pexp","value":0},{"id":"c_tariff","value":2},{"id":"serial_g","value":"4999999999999999999999999999999995"},{"id":"gas_usage","value":0},{"id":"gas","value":3903.388},{"id":"Cost-T1","value":0.20721},{"id":"Cost-T2","value":0.22921},{"id":"Cost-nT1","value":0.20721},{"id":"Cost-nT2","value":0.22921},{"id":"Cost-gas","value":0.7711},{"id":"Gas-interval","value":3600},{"id":"Client-blob","value":""},{"id":"available","value":true}]},"systime":1610986159,"seq":1,"error":false}
