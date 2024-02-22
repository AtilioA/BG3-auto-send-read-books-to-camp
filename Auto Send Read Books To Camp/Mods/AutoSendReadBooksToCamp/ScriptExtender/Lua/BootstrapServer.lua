Ext.Require("Server/_Init.lua")

FALLENS_MARK_BOOK_AS_READ = "c72d9f6a-a6e4-48b1-98c0-0ecdc7c31cf7"

if (Ext.Mod.IsModLoaded(FALLENS_MARK_BOOK_AS_READ)) then
  -- _D("AutoSendReadBooksToCamp: MarkBookAsRead mod is loaded")
  FMBRVars = Ext.Vars.GetModVariables(FALLENS_MARK_BOOK_AS_READ)
else
  _D("[Auto Send Read Books To Camp][ERROR]: MarkBookAsRead mod is not loaded, mayhem will ensue")
end
