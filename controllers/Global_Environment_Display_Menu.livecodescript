script "Global | Environment | Display | Menu"
--> MetaData
-
license: GPLv3
name: Global | Environment | Display | Menu
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
on menu_Init tObject   
   -- do something when the menu first loads
end menu_Init


--> Global | Environment | Display | Menu
-
on display_ListAllProjects
   put library_ListProjectNames() into projectNames
   --
   display_LcwProjectList projectNames
end display_ListAllProjects

on display_ListAllControllers indexView
   if the shiftKey is "Down" then
      display_Controllers
   else
      display_Controllers indexView
   end if
end display_ListAllControllers

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-


--> Deps
-
