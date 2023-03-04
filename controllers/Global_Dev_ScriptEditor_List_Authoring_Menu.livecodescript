script "Global | Dev | ScriptEditor | List | Authoring | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | Dev | ScriptEditor | List | Authoring | Menu
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


--> Global | Dev | ScriptEditor | List | Authoring | Menu
-
on submenu_HandlerLibrary
   return "Global | Handler | Library | Menu"
end submenu_HandlerLibrary

on menu_EditOldMenu
   menu_Edit "Global | ScriptEditor | Hkey | Menu"
end menu_EditOldMenu

on _
end _

on menu_TestMergeHandler hKey
   hkey_Deconstruct hKey, hName, hType, hObject, hNum
   put the exported_Script of hObject into exportedScript
   put the script of hObject into realScript
   if realScript is not exportedScript then
      put exportedScript
      answer warning "The scripts differ. Check for duplicate handlers?"
   else
      answer "Scripts are the same!" 
   end if
end menu_TestMergeHandler
