script "Global | View | Script | Menu"
--> MetaData
-
license: GPLv3
name: Global | View | Script | Menu
type: controller
version: 0.2


--> Variables
-
local LocalArray


--> Menu | Props
-
getprop menu_Target [tObject]
   put the display_View of tObject into displayView
   --
   if exists (displayView) then
      put the displayed_Object of displayView into viewObject
   else
      put tObject viewObject 
   end if
   --
   put the behavior_StackNames of viewObject into LocalArray ["behavior_StackNames"]
   --
   return viewObject
end menu_Target

private function _NoCardBehavior viewObject
   if exists (stack "behavior_ViewTemplateCard") is false then return true
   --
   put the card_Object of viewObject into cardObject
   put the behavior of cardObject into bObject
   if exists (bObject) is false then return false
   
   put the name of stack "behavior_ViewTemplateCard" into defaultBehaviorStack
   put the name of bObject = defaultBehaviorStack into behaviorIsSet
   return behaviorIsSet
end _NoCardBehavior


--> Global | View | Script | Menu
-
on menu_ScriptTools viewObject
   put the module_Behaviors of viewObject into bObjects
   repeat for each line bObject in bObjects
      display_ScriptTools bObject
   end repeat
end menu_ScriptTools

on menu_BehaviorDeps viewObject
   -- put the module_DefaultBehavior of viewObject into bObject
   put the module_Behaviors of viewObject into bObjects
   repeat for each line bObject in bObjects
      display_ScriptDeps bObject
   end repeat
end menu_BehaviorDeps

on menu_GoToView sObject
   put the object_MetaData ["name"] of sObject into viewName
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

private on _
end _

on menu_EditViewScript viewObject
   edit the script of viewObject
end menu_EditViewScript

on menu_EditViewBehavior viewObject
   edit the script of the behavior of viewObject
end menu_EditViewBehavior

getprop disabled_EditViewBehavior [viewObject]
   put the behavior of viewObject into bObject
   put exists (bObject) into bExists
   if bExists is false then return true
   return false
end disabled_EditViewBehavior

private on __
end __

on menu_ModuleBehavior mView, stackName
   edit the script of stack stackName
end menu_ModuleBehavior

getprop moduleBehavior_Param [mView]
   return the behavior_StackNames of mView
end moduleBehavior_Param

getprop moduleBehavior_Params [mView]
   put the template_Object of mView into tObject
   put the module_BehaviorStackNames of tObject into sNames
   return sNames
end moduleBehavior_Params

on menu_SetAllModuleBehaviors viewObject
   put the view_Name of viewObject into vName
   put merge ("Set the behavior_Objects to all the module_Behaviors of '[[vName]]'") into sComment
   lcw_Answer (sComment & "?"), viewObject
   --
   -- put module_ListBehaviorStackPaths (vName) into moduleBehaviors
   breakpoint
   put the module_OrderedBehaviors of viewObject into moduleBehaviors
   set the behavior_Objects of viewObject to moduleBehaviors
   --
   lcw_Notify (sComment & "!")
end menu_SetAllModuleBehaviors

getprop checked_SetAllModuleBehaviors [viewObject]
   put the module_Behaviors of viewObject into moduleBehaviors
   sort moduleBehaviors
   --
   put the behavior_Objects of viewObject into bObjects
   sort bObjects
   --
   return bObjects = moduleBehaviors
end checked_SetAllModuleBehaviors

--getprop disabled_SetAllModuleBehaviors [viewObject]
   put the behavior_Objects of viewObject into bObjects
   put the module_Behaviors of viewObject into mObjects
   return bObjects = mObjects
end disabled_SetAllModuleBehaviors

on menu_DisplayBehaviors mView
   display_ModuleBehaviors mView
end menu_DisplayBehaviors

on menu_CreateModuleBehavior mView
   put the stack_Name of mView into moduleStackName
   --
   ask_CreateModuleBehavior moduleStackName, mView
   put the result into newBehaviorStackPath
   --
   display_ModuleTools moduleStackName
end menu_CreateModuleBehavior

private on ___
end ___

on menu_EditCardScript viewObject
   put the card_Object of viewObject into cardObject
   edit the script of cardObject
end menu_EditCardScript

getprop checked_EditCardScript [viewObject]
   put the card_Object of viewObject into cardObject
   put the revAvailableHandlers of cardObject into hTable
   return hTable is not empty
end checked_EditCardScript

on menu_EditCardBehavior viewObject
   put the card_Object of viewObject into cardObject
   put the behavior of cardObject into bObject
   edit the script of bObject
end menu_EditCardBehavior

getprop disabled_EditCardBehavior [viewObject]
   put the card_Object of viewObject into cardObject
   put the behavior of cardObject into bObject
   return exists (bObject) is false
end disabled_EditCardBehavior

on menu_RemoveCardBehavior viewObject
   lcw_Answer "Remove the behavior of the views card?"
   --
   put the card_Object of viewObject into cardObject
   set the behavior of cardObject to empty
end menu_RemoveCardBehavior

getprop disabled_RemoveCardBehavior [viewObject]
   return _NoCardBehavior (viewObject)
end disabled_RemoveCardBehavior

private on ____
end ____

on menu_SetDefaultCardBehavior viewObject
   lcw_Answer "Set the behavior of the views card to the script-only stack 'behavior_ViewTemplateCard'?", viewObject
   --
   put the card_Object of viewObject into cardObject
   set the behavior of cardObject to the long id of stack "behavior_ViewTemplateCard"
end menu_SetDefaultCardBehavior

getprop checked_SetDefaultCardBehavior [viewObject]
   put the card_Object of viewObject into cardObject
   --
   put the behavior of cardObject into bObject
   if exists (bObject) is false then return false
   
   put the long id of stack "behavior_ViewTemplateCard" into dObject
   put bObject = dObject into isDefault
   return isDefault
end checked_SetDefaultCardBehavior

on submenu_Dev
   return menu_DevTitle ("Global | View | Script | Menu")
end submenu_Dev
