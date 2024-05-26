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
   if exists (displayView) then
      put the displayed_Object of displayView into viewObject
      return viewObject
   else
      return tObject
   end if
end menu_Target

getprop disabled_EditCardScript [viewObject]
   put the card_Object of viewObject into cardObject
   put the revAvailableHandlers of cardObject into hTable
   put hTable is empty into noHandlers
   return noHandlers
end disabled_EditCardScript

getprop disabled_EditViewBehavior [viewObject]
   put the behavior of viewObject into bObject
   put exists (bObject) into bExists
   if bExists is false then return true
   
   /*
   put the module_Behaviors of viewObject into moduleBehaviors
   put the behavior_Objects of viewObject into bObjects
   if bObjects = moduleBehaviors then return true
   */
   
   return false
end disabled_EditViewBehavior

getprop disabled_SetViewCardBehavior [viewObject]
   if exists (stack "behavior_ViewTemplateCard") is false then return true
   --
   put the card_Object of viewObject into templateCardObject
   put the behavior of templateCardObject into bObject
   if exists (bObject) is false then return false
   
   put the name of stack "behavior_ViewTemplateCard" into defaultBehaviorStack
   put the name of bObject = defaultBehaviorStack into behaviorIsSet
   return behaviorIsSet
end disabled_SetViewCardBehavior

getprop disabled_SetModuleBehaviors [viewObject]
   put the behavior_Objects of viewObject into bObjects
   put the module_Behaviors of viewObject into mObjects
   return bObjects = mObjects
end disabled_SetModuleBehaviors

getprop disabled_GoToView [scriptObject]
   put the object_MetaData ["type"] of scriptObject into mObectType
   put mObectType contains "view" into viewOrViewBehavior
   return viewOrViewBehavior is false
end disabled_GoToView

getprop disabled_EditViewBehavior [mTarget]
   if exists(mTarget) is false then return true
   if the behavior of mTarget is empty then
      return "delete"
   else
      return false
   end if
end disabled_EditViewBehavior

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

getprop disabled_SetMenuButtonScript [viewObject]
   put menu_GetGlobalButton() into viewTemplate
   put the menu_Button of viewObject into mButton
   switch
      case mButton is empty
      case the long id of mButton = the long id of viewTemplate
         return true
         break
      default
         return false
   end switch 
end disabled_SetMenuButtonScript

getprop disabled_SetViewMetadata [viewObject]
   put the view_Name of viewObject into viewName
   if viewName is empty then
      return false
   else
      return "delete"
   end if
end disabled_SetViewMetadata


--> Global | View | Script | Menu
-
on menu_EditViewScript viewObject
   edit the script of viewObject
end menu_EditViewScript

on menu_EditViewBehavior viewObject
   edit the script of the behavior of viewObject
end menu_EditViewBehavior

on menu_EditCardScript viewObject
   put the card_Object of viewObject into cardObject
   edit the script of cardObject
end menu_EditCardScript

on menu_DisplayViewBehaviors viewObject
   display_ViewBehaviors viewObject
end menu_DisplayViewBehaviors

private on _
end _

on menu_SetModuleBehaviors mView
   put the module_Behaviors of mView into moduleBehaviors
   set the behavior_Objects of mView to moduleBehaviors
   --
   menu_EditModuleBehaviors mView
end menu_SetModuleBehaviors

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

private on __
end __

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

on menu_EditViewCardBehavior viewObject
   put the card_Object of viewObject into cardObject
   put the behavior of cardObject into bObject
   edit the script of bObject
end menu_EditViewCardBehavior

on menu_SetViewCardBehavior viewObject
   lcw_Answer "Set the behavior of the views card to the script-only stack 'behavior_ViewTemplateCard'?"
   put the card_Object of viewObject into cardObject
   set the behavior of cardObject to the long id of stack "behavior_ViewTemplateCard"
end menu_SetViewCardBehavior

on menu_RemoveCardBehavior viewObject
   lcw_Answer "Remove the behavior of the views card?"
   put the card_Object of viewObject into cardObject
   set the behavior of cardObject to empty
end menu_RemoveCardBehavior

private on ____
end ____

on submenu_Dev
   return menu_DevTitle()
end submenu_Dev
