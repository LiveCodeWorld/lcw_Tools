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

private command _SetChoice menuChoice, @mainChoice, @secondChoice
   put line 1 of menuChoice into menuChoice
   set the itemdelimiter to "|"
   put item 1 of menuChoice into mainChoice
   put item 2 to -1 of menuChoice into secondChoice
end _SetChoice

-- getprop hierarchyObject_Params
put library_ListUsedStacks() into libStacks
return libStacks
end hierarchyObject_Params

getprop hierarchyObject_Params [mTarget]
   return BehaviorObjectMenu
end hierarchyObject_Params

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
on menu_GoToView scriptObject
   put the object_MetaData ["name"] of scriptObject into viewName
   put view_GetTemplateObject (viewName) into templateObject
   switch
      case templateObject = empty
         answer warning merge ("The view '[[viewName]]' is not in the database!")
         break
      case exists (templateObject) is false
         put templateObject
         answer warning merge ("I cannot find the view template for view '[[viewName]]'")
         break
      default
         object_GoTo templateObject
   end switch
end menu_GoToView

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

on _
end _

on menu_HierarchyObject mTarget, someThing
   menu_SetChoice someThing, scriptObject, someType
   -- put ObjectDictionary [scriptObject] into scriptObject
   if someType is "behavior" then
      put the behavior of scriptObject into scriptObject
   end if
   edit the script of scriptObject
end menu_HierarchyObject
