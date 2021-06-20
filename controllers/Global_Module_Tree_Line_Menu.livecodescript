script "Global | Module | Tree | Line | Menu"
--> MetaData
-
license: GPLv3
name: Global | Module | Tree | Line | Menu
type: controller
version: 0.2

/*
Here you can describe this menu.
Full help text should be provided on the linked wiki.
*/

--> Menu | Init
-
local LocalArray

on menu_Init fObject
   put the displayed_Object of fObject into LocalArray ["viewObject"]
   --
   put the displayed_View of fObject into LocalArray ["indexView"]
   put the selected_Index of fObject into LocalArray ["viewProp"]
end menu_Init


--> Global | Module | Tree | Line | Menu
-
on menu_ViewProperty viewObject 
   put LocalArray ["viewProp"] into viewProp
   --
   put the viewProp of viewObject
end menu_ViewProperty

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
