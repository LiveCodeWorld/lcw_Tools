script "Global | Hkey | Find | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | Hkey | Find | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray


--> Menu | Init
-
on menu_Init tObject   
   -- do something when the menu first loads
   
   put the display_View of tObject into displayView
   --
   put the data_Array of displayView into LocalArray ["dataArray"]
end menu_Init


--> Global | Hkey | Find | Menu
-
on menu_Test displayView
   put the name of stack "lib_FindHkey" into libObject
   display_MouseDoubleUpHandler "mDoubleUp_FoundLib", libObject
   if the result is empty then
      lcw_AnswerWarning "Already created handler for [[libObject]]", displayView, libObject
   end if
end menu_Test

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
