script "Global | Display | View | Line | Menu"
--> MetaData
-
license: GPLv3
name: Global | Display | View | Line | Menu
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
getprop disabled_Show [displayView]
   put the selected_Value of displayView into sDisplayView
   --
   if exists (sDisplayView) is false then
      return true
   else
      put the stack_Name of sDisplayView into dStackName
      if the visible of stack dStackName is false then
         return true
      else
         return false
      end if
   end if
end disabled_Show


--> Global | Display | View | Line | Menu
-
on menu_Show displayView
   put the selected_Value of displayView into sDisplayView
   --
   put the stack_Name of sDisplayView into dStackName
   show stack dStackName
end menu_Show

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
