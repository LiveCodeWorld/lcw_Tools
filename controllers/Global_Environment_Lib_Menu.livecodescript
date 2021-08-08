script "Global | Environment | Lib | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | Environment | Lib | Menu
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

getprop checked_Filtered [displayView]
   return _IsFiltered (displayView)
end checked_Filtered

private function _IsFiltered displayView
   if word 1 of the title_Text of displayView = "Filtered" then
      return true
   else
      return false
   end if
end _IsFiltered


--> Global | Environment | Lib | Menu
-
on menu_Filtered displayView
   if _IsFiltered (displayView) then
      display_EnvironmentLibs empty, displayView
   else
      put lcw_Ask ("Filter models and libs using", "", displayView) into filterItems
      display_EnvironmentLibs filterItems, displayView
   end if
end menu_Filtered

on _
end _

on insert_Env
   return "Global | Environment | Menu" into mTitle
end insert_Env
