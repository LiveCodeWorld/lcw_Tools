script "Global | Script | Dev | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Script | Dev | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   -- called once for each menu
   return the display_View of tObject
end menu_Target


--> Global | Script | Dev | Menu
-
on menu_AboutScriptDevMenu dView
   launch_MenuHelp "Global | Script | Dev | Menu"
end menu_AboutScriptDevMenu

on submenu_StackHistory
   return "Global | Git | Stack | History | Menu"
end submenu_StackHistory

-- on submenu_ScriptHistory
return "Global | Script | History | Menu"
end submenu_ScriptHistory

on submenu_ScriptDeps
   return "Global | Script | Dep | Menu"
end submenu_ScriptDeps

on submenu_Overlay
   return "Global | Overlay | Menu"
end submenu_Overlay

on submenu_ScriptExport
   return "Global | Script | Exported | Menu"
end submenu_ScriptExport

on submenu_TestExport
   return "Global | Object | Export | Test | Menu"
end submenu_TestExport

on _
end _

-- on submenu_Project
return "Global | Project | Stack | Menu"
end submenu_Project

-- on submenu_ScriptMainstack
return "Global | Script | Mainstack | Menu"
end submenu_ScriptMainstack

on submenu_Rig
   return "Global | Rig | Files | Menu"
end submenu_Rig

on submenu_Gist
   return "Global | Gist | Menu"
end submenu_Gist
