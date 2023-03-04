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

-- getprop menu_IsSimple
return true
end menu_IsSimple

getprop menu_Target [tObject]
   put the top_Line of tObject into shortFolder
   return shortFolder
end menu_Target

getprop disabled_Library [shortFolder]
   return shortFolder is not "Libraries"
end disabled_Library

getprop disabled_Controller [shortFolder]
   return shortFolder is not "Controllers"
end disabled_Controller

getprop disabled_Module [shortFolder]
   return shortFolder is not "Modules"
end disabled_Module

getprop disabled_Model [shortFolder]
   return shortFolder is not "Models"
end disabled_Model

getprop disabled_View [shortFolder]
   return shortFolder is not "Views"
end disabled_View

getprop disabled_Behavior [shortFolder]
   return shortFolder is not "Behaviors"
end disabled_Behavior

private function _GetMenu menuBit
   put the long id of me into myController
   put merge ("Global | Module | [[menuBit]] | Line | Menu") into gMenuTitle
   return gMenuTitle
end _GetMenu


--> Global | Module | Tree | Line | Menu
-
on menu_ViewProperty viewObject 
   put LocalArray ["viewProp"] into viewProp
   --
   put the viewProp of viewObject
end menu_ViewProperty

on _
end _

on submenu_Controller
   return _GetMenu ("Controllers")
end submenu_Controller

on submenu_Library
   return _GetMenu ("Lib")
end submenu_Library

on submenu_Model
   return _GetMenu ("Model")
end submenu_Model

on submenu_View
   return _GetMenu ("View")
end submenu_View

on submenu_Behavior
   return _GetMenu ("Behavior")
end submenu_Behavior


