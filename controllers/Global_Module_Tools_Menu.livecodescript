script "Global | Module | Tools | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Module | Tools | Menu
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
   put display_MenuTarget (tObject) into moduleView
   --
   put moduleView into LocalArray ["moduleView"]
   put the module_MenuTitle of moduleView into moduleMenu
   put moduleMenu into LocalArray ["moduleMenu"]
   --
   return moduleView
end menu_Target

getprop menu_CheckTarget [dView]
   return exists (dView)
end menu_CheckTarget

getprop disabled_Menu [moduleView]
   put the menubar_View of moduleView into mGroup
   return exists (mGroup) is false
end disabled_Menu


--> Global | Module | Tools | Menu
-
on submenu_ModuleMenu
   -- return "Global | Wiki | Future | Menu"
   return LocalArray ["moduleMenu"]
end submenu_ModuleMenu
-
on submenu_Property
   return "Global | View | Property | Menu"
end submenu_Property

on submenu_Geometry
   return "Global | View | Geometry | Menu"
end submenu_Geometry

private on _
end _

on submenu_Script
   return "Global | View | Script | Menu"
end submenu_Script

on submenu_Card
   return "Global | Card | Menu"
end submenu_Card

private on __
end __

on submenu_Update
   return "Global | View | Update | Menu"
end submenu_Update

on submenu_Menu
   return "Global | Menu | Group | Menu"
end submenu_Menu

private on ___
end ___

on submenu_Assets
   return "Global | View | Assets | Menu"
end submenu_Assets

on submenu_MoreTests
   return "Global | View | Test | Geometry | Menu"
end submenu_MoreTests

private on ____
end ____

on menu_ModuleTools dView
   put the view_Name of dView into viewName
   display_ModuleTools viewName
end menu_ModuleTools

on submenu_Dev
   return menu_DevTitle ("Global | Module | Tools | Menu")
end submenu_Dev
