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

private function _GetSelectedStackName displayView
   put _GetSelectedView (displayView) into sView
   put the stack_Name of sView into stackName
   return stackName
end _GetSelectedStackName

private function _GetSelectedView displayView
   put the selected_Value of displayView into sView
   return sView
end _GetSelectedView


--> Global | Display | View | Line | Menu
-
on menu_Show displayView
   put _GetSelectedStackName (displayView) into stackName
   --
   show stack stackName
end menu_Show

on _
end _

on menu_Gather displayView
   put _GetSelectedStackName (displayView) into stackName
   --
   set the loc of stack stackName to the screenMouseLoc
   show stack stackName
end menu_Gather
