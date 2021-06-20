script "Global | Display | View | Menu"
--> MetaData
-
license: GPLv3
name: Global | Display | View | Menu
type: controller
version: 0.1

/*
Here you can describe this menu.
Full help text should be provided on the linked wiki.
*/

--> Variables
-
local LocalArray


--> Menu | Init
-
on test_Me treeWidget, displayView, pathItems
   object_GoTo displayView, true
   --
   put the clickloc into sLoc
   put the globalLoc of sLoc into gLoc
   put the stack_Name of displayView into stackName
   --
   set the topleft of stack stackName to gLoc
end test_Me


--> Global | Display | View | Menu
-
on menu_Refresh
   display_ListDataViews
end menu_Refresh

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_Experiment mTarget
   put mTarget
end menu_Experiment


--> Deps
-
