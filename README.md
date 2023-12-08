# NoSlipCloser

1.00
- a service for closing each open position on the account after the price passing their SL/TP
- suitable for situations that sl/tp doesn't work due to no slippage or a gap in the market
- set delayPoint parameter to let the main sl/tp of the position works
- sleepMilli parameter is used so service doesn't do too excessive checks(maybe a little less pressure on Metatrader software :))
- closedCmnt is just a simple comment to know exactly which positions has been closed by this Service
- for using the service, "Algo Trading" switch on Metatrader needs to be active