script "Global | ViewData | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | ViewData | Menu
type: controller
version: 0.2

/*
-- put view_ConstructToolMenu (viewObject, true) into mTitleTable

Global | Guide | Menu	submenu
-
Global | Module | Menu	submenu
Global | View | Assets | Menu	submenu
-
Global | View | Script | Menu	submenu
Global | View | Property | Menu	submenu
Global | View | Geometry | Menu	submenu
Global | View | Update | Menu	submenu
*/




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


--> Global | ViewData | Menu
-
on menu_ListCardBehaviorNames viewObject
   put the cardBehavior_StackNames of viewObject into bNames
   replace CR with comma in bNames
   put bNames
   --
end menu_ListCardBehaviorNames

on menu_ListNestedBehaviors viewObject
   put the cardBehavior_Objects of viewObject into viewCardBehaviors
   --
   put _dView() into dView
   set the displayed_Data ["the cardBehavior_Objects"] of dView to viewCardBehaviors
end menu_ListNestedBehaviors

on menu_AddBehaviorsToStackfiles viewObject
   lcw_Answer "Add all dependency bahviors of this card to the stackfiles of this stack?", viewObject
   --
   put the cardBehavior_Deps of viewObject into cardBehaviorDeps
   set the module_AddBehaviorObjects of viewObject to cardBehaviorDeps
end menu_AddBehaviorsToStackfiles

on menu_ViewData viewObject
   put _dView() into dView
   put the cardBehavior_NestedData of viewObject into viewCardNestedData
   --
   set the displayed_Data ["the cardBehavior_NestedData"] of dView to viewCardNestedData
end menu_ViewData

private on _
end _

on submenu_DefaultMenu viewObject
   -- return "Global | Guide | Menu"
   -- put line 1 of view_ConstructToolMenu (viewObject, true) into mTitle
   put the view_MenuTitle [true] of viewObject into mTitle
   return mTitle
end submenu_DefaultMenu

on submenu_Module
   return "Global | Module | Menu"
end submenu_Module

on submenu_ModuleProperty
   return "Global | View | Property | Menu"
end submenu_ModuleProperty

on submenu_Update
   return "Global | View | Update | Menu"
end submenu_Update

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
   return menu_DevTitle ("Global | ViewData | Menu")
end submenu_Dev
