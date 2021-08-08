script "Global | Module | List | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Module | List | Line | Menu
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
   put the display_View of tObject into LocalArray ["displayView"]
   put the selected_Line of tObject into shortModuleFolder
   --
   return shortModuleFolder
end menu_Target


--> Global | Module | List | Line | Menu
-
on menu_DisplayModule shortModuleFolder
   display_ModuleFromShortModuleFolder shortModuleFolder
end menu_DisplayModule

on menu_ModuleTools shortModuleFolder
   put env_GetModuleHomePath (shortModuleFolder) into moduleStackPath
end menu_ModuleTools

on menu_ShowModule shortModuleFolder
   put env_GetModuleHomePath (shortModuleFolder) into moduleStackPath
   -- 
   toplevel stack moduleStackPath
   show stack moduleStackPath
   --
   put LocalArray ["displayView"] into displayView
   put globalLoc (the loc of displayView) into gLoc
   set the loc of stack moduleStackPath to gLoc
end menu_ShowModule

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on _Experiment displayView
   put displayView
end _Experiment
