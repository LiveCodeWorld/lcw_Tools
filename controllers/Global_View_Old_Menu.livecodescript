script "Global | View | Old | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | View | Old | Menu
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


--> Global | View | Old | Menu
-
on menu_Refresh displayView
   display_OldViewFiles
end menu_Refresh
