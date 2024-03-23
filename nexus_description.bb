[size=5][b]Overview[/b][/size]
[b]Auto Send Read Books To Camp is a mod designed to streamline inventory management by automatically sending read books to the camp chest, [u]since they will remain 'memorized' by your character/party with regards to dialogue options[/u][/b]. Why edit their weight if you can play as Larian intended?
It supports configurable options via a JSON file but also works out of the box. Multiplayer should work, but feel free to report any issues.

Players can choose to enable instant transfer of read books (right after closing the book UI); [b]by default, they are only sent upon entering camp. Quest books are ignored by default and aren't sent to camp[/b]. See the settings breakdown in the Configuration section below for more details.
[line][b][size=5][b]
Installation[/b][/size][/b]
[list=1]
[*]Download the .zip file and install using BG3MM.

[/list][b][size=4]Requirements
[/size][/b][size=2]- [b][url=https://www.nexusmods.com/baldursgate3/mods/7676]Volition Cabinet[/url][/b][/size]
[size=2]- [url=https://www.nexusmods.com/baldursgate3/mods/3682]Mark books as read[/url]﻿[/size][size=2]
- [url=https://github.com/Norbyte/bg3se]BG3 Script Extender[/url] [size=2](you can easily install it with BG3MM through its [i]Tools[/i] tab or by pressing CTRL+SHIFT+ALT+T while its window is focused)
[line]
[/size][/size][size=5][b]Configuration[/b][/size][size=2][size=2]
When you load a save with the mod for the first time, it will automatically create an auto_send_read_books_to_camp_config.json file with default options.

You can easily navigate to it on Windows by pressing WIN+R and entering
[quote][size=2][size=2][code]explorer %LocalAppData%\Larian Studios\Baldur's Gate 3\Script Extender\AutoSendReadBooksToCamp
[/code][/size][/size][/quote]
Open the JSON file with any text editor, even regular Notepad will work. Here's what each option inside does (order doesn't matter):

[size=2][size=2][font=Courier New]"GENERAL"[/font]: General settings for the mod.[font=Courier New]
   ﻿"enabled"[/font]: Set to [font=Courier New]true[/font] to activate the mod or [font=Courier New]false[/font] to disable it without uninstalling. [/size][/size]Enabled by default.

[font=Courier New]"FEATURES"[/font]: Controls various mod features.
[font=Courier New]   "instantly"[/font]:
    [font=Courier New]   - "enabled"[/font]: Set to [font=Courier New]true[/font] to send books to camp/mark as ware right after reading them (instead of waiting for teleport to camp). [size=2]Disabled by default.[/size]
[font=Courier New]   ﻿"mark_as_ware_instead"[/font]:
   ﻿   ﻿[font=Courier New]- "enabled"[/font]: Set to [font=Courier New]true[/font] to mark as wares instead of sending to camp. Enabled [size=2]by default (see below).[/size]
   ﻿   ﻿[size=2][size=2][font=Courier New]- "only_duplicates"[/font]: Set to [font=Courier New]true[/font] to only mark as ware if they are duplicates (otherwise, send to camp). Enabled [size=2]by default.[/size][/size][/size]
[font=Courier New]   "ignore"[/font]: Settings to ignore specific types of items.
    [font=Courier New]   - "quest"[/font]: Set to [font=Courier New]true[/font] to ignore quest books. [size=2]Enabled by default.[/size]
    [font=Courier New]   - "wares"[/font]: Set to [font=Courier New]true[/font] to ignore books marked as wares. [size=2]Enabled by default.[/size]
   [size=2][size=2]    [font=Courier New]- "nested"[/font]: Set to [font=Courier New]true[/font] to ignore books inside containers. [size=2]Enabled by default.[/size][/size][/size]

[size=2][font=Courier New]"DEBUG"[/font]: Adjusts the level of debugging information.
[font=Courier New]   "level"[/font]: Set this to 0 for no debug logs, 1 for basic logs, or 2 for detailed logs. Non-developers typically don't need to modify this setting. [size=2]0 by default.[/size]

[size=2][size=2][size=2][size=2][size=2][size=2]After making changes, load a save to reflect your changes[/size][/size][/size][/size][/size][/size][/size][/size][/size][size=2][size=2][size=2][size=2][size=2][size=2][size=2][size=2][size=2] or run [font=Courier New]!asrbtc_reload[/font] in the SE console.[/size][/size][/size][/size][/size][/size][/size][/size][/size][size=2][size=2][size=2]
[/size][/size][line][size=4][b]
[/b][/size][/size][size=5][b]Compatibility[/b][/size]
- This mod should be compatible with most game versions and other mods, as it mostly just listens to game events and does not edit existing game data.
   ﻿- Mods that edit book items should be affected as expected.
   ﻿- Mods that affect the camp chest should be compatible.
   ﻿- Mods that auto-sort items may conflict with this mod's functionality: since both types of mods manipulate inventory items, there could be unpredictable behavior when they try to move the same items, and I don't know if load order can dictate this. I can only guarantee that my mod by itself will not create duplicates of book items. Feel free to report any issues, but I can't guarantee a fix.
[line][size=4][b]
Special Thanks[/b][/size]
Thanks to [url=https://www.nexusmods.com/baldursgate3/users/64167336?tab=user+files]Fararagi[/url] for [url=https://www.nexusmods.com/baldursgate3/mods/3682]Mark books as read[/url] (go check their mods and help a frenchie out[url=https://emojipedia.org/flag-france] 🇫🇷[/url]), to Caites for [url=https://www.nexusmods.com/baldursgate3/mods/4597?tab=files]Better Inventory UI[/url] (these three pair up really well (I mean the authors)); to [url=https://www.nexusmods.com/baldursgate3/users/21094599?tab=user+files]FocusBG3[/url] for some inventory helper functions, and to [url=https://github.com/Norbyte]Norbyte[/url], for the Script Extender.

[size=4][b]Source Code
[/b][/size]The source code is available on [url=https://github.com/AtilioA/BG3-auto-send-food-to-camp]GitHub[/url] or by unpacking the .pak file. Endorse on Nexus and give it a star on GitHub if you liked it!
[line]
[center][b][size=4][/size][/b][b][size=4][/size][/b][b][size=4][/size][/b][/center][center][b][size=4][/size][/b][center][b][size=4]My mods[/size][/b][size=2]
[url=https://www.nexusmods.com/baldursgate3/mods/6995]Waypoint Inside Emerald Grove[/url] - 'adds' a waypoint inside Emerald Grove
[b][size=4][url=https://www.nexusmods.com/baldursgate3/mods/7035][size=4][size=2]Auto Send Read Books To Camp[/size][/size][/url]﻿[size=4][size=2] [/size][/size][/size][/b][size=4][size=4][size=2]- [/size][/size][/size][size=2]send read books to camp chest automatically[/size]
[url=https://www.nexusmods.com/baldursgate3/mods/6880]Auto Use Soap[/url]﻿ - automatically use soap after combat/entering camp
[url=https://www.nexusmods.com/baldursgate3/mods/6540]Send Wares To Trader[/url]﻿[b] [/b]- automatically send all party members' wares to a character that initiates a trade[b]
[/b][b][url=https://www.nexusmods.com/baldursgate3/mods/6313]Preemptively Label Containers[/url]﻿[/b] - automatically tag nearby containers with 'Empty' or their item count[b]
[/b][url=https://www.nexusmods.com/baldursgate3/mods/5899]Smart Autosaving[/url] - create conditional autosaves at set intervals
[url=https://www.nexusmods.com/baldursgate3/mods/6086]Auto Send Food To Camp[/url] - send food to camp chest automatically
[url=https://www.nexusmods.com/baldursgate3/mods/6188]Auto Lockpicking[/url] - initiate lockpicking automatically
[size=2]
[/size][url=https://ko-fi.com/volitio][img]https://raw.githubusercontent.com/doodlum/nexusmods-widgets/main/Ko-fi_40px_60fps.png[/img][/url]﻿﻿[/size][/center][/center][url=https://www.nexusmods.com/baldursgate3/mods/7294][center][/center][center][img]https://i.imgur.com/hOoJ9Yl.png[/img]﻿[/center][/url][center][/center]
