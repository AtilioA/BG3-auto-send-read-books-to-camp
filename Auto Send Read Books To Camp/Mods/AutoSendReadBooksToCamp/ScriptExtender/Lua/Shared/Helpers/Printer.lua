ASRBTCPrinter = VolitionCabinetPrinter:New { Prefix = "Auto Send Read Books To Camp", ApplyColor = true, DebugLevel = Config:GetCurrentDebugLevel() }

function ASRBTCPrint(debugLevel, ...)
  ASRBTCPrinter:SetFontColor(0, 255, 255)
  ASRBTCPrinter:Print(debugLevel, ...)
end

function ASRBTCTest(debugLevel, ...)
  ASRBTCPrinter:SetFontColor(100, 200, 150)
  ASRBTCPrinter:PrintTest(debugLevel, ...)
end

function ASRBTCDebug(debugLevel, ...)
  ASRBTCPrinter:SetFontColor(200, 200, 0)
  ASRBTCPrinter:PrintDebug(debugLevel, ...)
end

function ASRBTCWarn(debugLevel, ...)
  ASRBTCPrinter:SetFontColor(255, 100, 50)
  ASRBTCPrinter:PrintWarning(debugLevel, ...)
end

function ASRBTCDump(debugLevel, ...)
  ASRBTCPrinter:SetFontColor(190, 150, 225)
  ASRBTCPrinter:Dump(debugLevel, ...)
end

function ASRBTCDumpArray(debugLevel, ...)
  ASRBTCPrinter:DumpArray(debugLevel, ...)
end
