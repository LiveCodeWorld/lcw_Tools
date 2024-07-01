script "Global | Rename | Menu | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Rename | Menu | Line | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Events
-
on mDoubleUp_RenameMenu dView, someLine
   put the selected_Path of dView into sKey
   put the displayed_Data of dView into dData
   --
   put dData ["mController"] into mController
   put dData [sKey] into sValue
   
   if exists (mController) is false then
      put sKey & ":" && sValue
      breakpoint
   end if
   
   switch sKey
      case "mTitle"
         put sKey & ":" && sValue
         menu_Edit sValue
         break
      case "mController"
         edit the script of mController
         break
      default
         put sKey & ":" && sValue
   end switch
end mDoubleUp_RenameMenu


--> Menu | Props
-
getprop menu_Target [tObject]
   put the display_View of tObject into LocalArray ["dView"]
   put the displayed_Object of tObject into sObject
   return sObject
end menu_Target

private function _dView
   return LocalArray ["dView"]
end _dView

getprop menu_CheckTarget [dView]
   return exists (dView)
end menu_CheckTarget


--> Global | Rename | Menu | Line | Menu
-
on menu_RenameMenuLine dView
   put the params
end menu_RenameMenuLine

private on _
end _

on menu_Behavior dView
   put the behavior of dView into bObject
   edit the script of bObject
end menu_Behavior

on menu_ModuleTools dView
   put the view_Name of dView into viewName
   display_ModuleTools viewName
end menu_ModuleTools

private on __
end __

on submenu_Dev
   return menu_DevTitle ("Global | Rename | Menu | Line | Menu")
end submenu_Dev
