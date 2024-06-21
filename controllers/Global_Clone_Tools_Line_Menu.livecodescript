script "Global | Clone | Tools | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Clone | Tools | Line | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Events
-
on mDoubleUp_CloneTools dView, someLine
   put the selected_Path of dView into sPath
   put the title_Text of dView into stackName
   
   put the displayed_Object of dView into clonedView
   put the original_View of dView into originalView
   put the displayed_ModuleFolder of dView into moduleFolder
   
   replace comma with slash in sPath
   put moduleFolder & sPath into sFile
   if there is not a file sFile then breakpoint
   
   edit the script of stack sFile
end mDoubleUp_CloneTools


--> Menu | Props
-
getprop menu_Target [tObject]
   -- put display_MenuTarget (tObject) into dView
   put the display_View of tObject into dView
   return dView
end menu_Target

getprop menu_CheckTarget [dView]
   return exists (dView)
end menu_CheckTarget


--> Global | Clone | Tools | Line | Menu
-
on menu_CloneToolsLine dView
   put the params
end menu_CloneToolsLine

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
   return menu_DevTitle ("Global | Clone | Tools | Line | Menu")
end submenu_Dev
