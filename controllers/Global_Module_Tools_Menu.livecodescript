﻿script "Global | Module | Tools | Menu"
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
on submenu_DefaultMenu
   return LocalArray ["moduleMenu"]
end submenu_DefaultMenu

on menu_ModuleHelp moduleView
   put the view_Name of moduleView into moduleName
   --
   draft_ModuleHelp moduleName
end menu_ModuleHelp

private on _
end _

on submenu_Module
   return "Global | Module | Tree | Menu"
end submenu_Module

on submenu_ModuleAssets
   return "Global | Module | Assets | Menu"
end submenu_ModuleAssets

private on __
end __

on submenu_Geometry
   return "Global | View | Geometry | Menu"
end submenu_Geometry

on submenu_Property
   return "Global | View | Property | Menu"
end submenu_Property

on submenu_Menu
   return "Global | Menu | Group | Menu"
end submenu_Menu

private on ___
end ___

on submenu_Update
   return "Global | View | Update | Menu"
end submenu_Update

on submenu_Version
   return "Global | Stack | Tidy | Menu"
end submenu_Version

private on ____
end ____

on submenu_Script
   return "Global | View | Script | Menu"
end submenu_Script

on submenu_Card
   return "Global | Card | Menu"
end submenu_Card

on submenu_Stack
   return "Global | Stack | Menu"
end submenu_Stack

private on _____
end _____

on submenu_MoreTests
   return "Global | View | Test | Geometry | Menu"
end submenu_MoreTests

on menu_Refresh dView
   put the view_Name of dView into moduleName
   display_ModuleTools moduleName
end menu_Refresh

on submenu_Dev
   return menu_DevTitle ("Global | Module | Tools | Menu")
end submenu_Dev
