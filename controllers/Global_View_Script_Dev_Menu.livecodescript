script "Global | View | Script | Dev | Menu"
--> MetaData
-
license: GPLv3
name: Global | View | Script | Dev | Menu
type: controller
author: David Bovill
version: 0.1

/*
Here you can describe this menu.
Full help text should be provided on the linked wiki.
*/

--> Variables
-
local LocalArray
local BehaviorObjectMenu, ObjectDictionary

--> Menu | Props
-
getprop menu_Target [tObject]
   -- return display_MenuTarget(tObject)
   return the display_View of tObject
end menu_Target

getprop hierarchyObject_Params [mTarget]
   return BehaviorObjectMenu
end hierarchyObject_Params

getprop disabled_EditViewScript [viewObject]
   if the shiftkey is "Down" then return false
   -- put the view_Template of viewObject into viewTemplate
   put the revAvailableHandlers of viewObject into hTable
   if hTable is empty then
      return true
   else
      return false
   end if
end disabled_EditViewScript

getprop disabled_SetViewMetadata [viewObject]
   put the view_Name of viewObject into viewName
   if viewName is empty then
      return false
   else
      return "delete"
   end if
end disabled_SetViewMetadata

getprop disabled_HierarchyObject [mTarget]
   local longObjects, shortObjects, shortNames
   put the object_BehaviorHierarchyArray of mTarget into hierarchyArray
   
   put hierarchyArray ["menu"] into BehaviorObjectMenu
   put hierarchyArray ["longObjects"] into longObjects
   -- put hierarchyArray ["shortObjects"] into shortObjects
   -- put hierarchyArray ["shortNames"] into shortNames
   
   put hierarchyArray ["dictionary"] into ObjectDictionary
   
   if longObjects is empty then
      return "delete"
   else
      return false
   end if
end disabled_HierarchyObject


--> Global | View | Script | Dev | Menu
-
on menu_DisplayViewBehaviors viewObject
   display_ViewBehaviors viewObject
end menu_DisplayViewBehaviors

on menu_EditModuleBehaviors mView
   put the module_Behaviors of mView into moduleBehaviors
   if moduleBehaviors is empty then
      answer "there are no behaviors for this module!"
      exit to top
   end if
   repeat for each line moduleBehavior in moduleBehaviors
      edit the script of moduleBehavior
   end repeat
end menu_EditModuleBehaviors

private on _
end _

on menu_SetMenuButtonScript viewObject
   put menu_GetGlobalButton() into viewTemplate
   put the menu_Button of viewObject into mButton
   --
   set the script of mButton to the script of viewTemplate
   edit the script of mButton
end menu_SetMenuButtonScript

on menu_EditMenuButtonTemplate viewObject
   put menu_GetGlobalButton() into viewTemplate
   edit the script of viewTemplate
end menu_EditMenuButtonTemplate

private on ___
end ___

on menu_CreateView scriptObject
   breakpoint
   -- template_ConstructCloneStack
   template_ConstructStackFromObject scriptObject
end menu_CreateView

on menu_EditToolMenu mTarget
   put the menu_ToolTitle of mTarget into mTitle
   menu_Edit mTitle
end menu_EditToolMenu

on menu_BehaviorsOfView mTarget
   put the object_Behaviors of mTarget
end menu_BehaviorsOfView

on ___
end ___

on menu_HierarchyObject mTarget, someThing
   menu_SetChoice someThing, scriptObject, someType
   -- put ObjectDictionary [scriptObject] into scriptObject
   if someType is "behavior" then
      put the behavior of scriptObject into scriptObject
   end if
   edit the script of scriptObject
end menu_HierarchyObject
