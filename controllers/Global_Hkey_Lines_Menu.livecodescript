script "Global | Hkey | Lines | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Hkey | Lines | Menu
type: controller
version: 0.1


--> Variables
-
local LocalArray

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


--> Global | Hkey | Lines | Menu
-
on menu_GraphHkeyArray sObject, graphStyle
   put _dView() into dView
   put the hkey_Array of dView into hkeyArray
   
   # Draw and Display Graph
   displayGraph_HkeyArray hkeyArray, sObject, graphStyle
end menu_GraphHkeyArray

getprop graphHkeyArray_Params
   return dot_ListGraphStyles()
end graphHkeyArray_Params

private on _
end _

on menu_SortDisplayedHkeys sObject
   put _dView() into dView
   --
   put the displayed_Lines of dView into hKeys
   hkey_SortIndex hKeys
   
   # Extract privateHkeys
   filter hKeys with "P*" into privateHkeys
   filter hKeys without "P*"
   
   # Extract privateHkeys
   put "^(G|S) .+" into wildcardPattern
   filter hKeys with regex pattern wildcardPattern into propHandlers
   filter hKeys without regex pattern wildcardPattern
   sort lines of propHandlers by word 2 of each
   
   put propHandlers & CR & hKeys & CR & privateHkeys into sortedHkeys
   
   # To Display custom sort we need an index field display
   set the displayed_Lines of dView to sortedHkeys
end menu_SortDisplayedHkeys

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
   return menu_DevTitle ("Global | Hkey | Lines | Menu")
end submenu_Dev
