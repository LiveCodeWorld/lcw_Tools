script "Global | Module | Controllers | Line | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | Module | Controllers | Line | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
on menu_Init tObject
   -- called only once for top menu
  pass menu_Init
end menu_Init

getprop menu_Target [tObject]
   -- called once for each menu
   return the display_View of tObject
end menu_Target

getprop menu_CheckTarget [mTarget]
   -- use to do initialisation
   pass menu_CheckTarget
end menu_CheckTarget

getprop test_Param [mTarget]
  return "b"
end test_Param

getprop test_Params [mTarget]
   return "a,b,c"
end test_Params

getprop checked_TestChecked
   return true
end checked_TestChecked

getprop disabled_Test
  return false -- true, "delete"
end disabled_Test


--> Global | Module | Controllers | Line | Menu
-
on menu_EditScript displayView
   put item 1 of the selected_Path of displayView into shortFolder
   put item 2 of the selected_Path of displayView into shortFile
   put the displayed_ModuleFolder of displayView into moduleFolder
   --
   put moduleFolder & shortFolder & slash & shortFile into stackPath
   --
   edit the script of stack stackPath
end menu_EditScript

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_Experiment displayView
   put displayView
end menu_Experiment


--> Deps
-
