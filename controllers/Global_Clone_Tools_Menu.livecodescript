script "Global | Clone | Tools | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Clone | Tools | Menu
type: controller
version: 0.2

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   put display_MenuTarget (tObject) into moduleView
   --
   put moduleView into LocalArray ["moduleView"]
   put the module_MenuTitle of moduleView into moduleMenu
   put moduleMenu into LocalArray ["moduleMenu"]
   --
   return moduleView
end menu_Target

getprop menu_CheckTarget [moduleView]
   return exists (moduleView)
end menu_CheckTarget


--> Global | Clone | Tools | Menu
-
on menu_CloneTools moduleView
   put the long name of moduleView
end menu_CloneTools

private on _
end _

on submenu_DefaultMenu
   return LocalArray ["moduleMenu"]
end submenu_DefaultMenu

-- on insert_Menu
return "Global | Module | Tools | Menu"
end insert_Menu

on submenu_Module
   return "Global | Module | Tree | Menu"
end submenu_Module
