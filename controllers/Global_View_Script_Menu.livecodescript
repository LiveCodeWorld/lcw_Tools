script "Global_View_Script_Menu"
--> MetaData
-
license: GPLv3
name: Global_View_Script_Menu
type: controller
version: 0.2


--> Menu | Target
-


--> Global | View | Script | Menu
-
on menu_ImportedBehaviors viewObject, someBoolean
   set the imported_Behaviors of viewObject to someBoolean
end menu_ImportedBehaviors

on menu_ExportBehaviors viewObject
   put the view_Name of viewObject into viewName
   breakpoint
   view_ExportTemplateBehaviorCardScripts viewName
end menu_ExportBehaviors

on _
end _
   
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

getprop disabled_EditCardScript [viewObject]
   put the card_Object of viewObject into cardObject
   put the revAvailableHandlers of cardObject into hTable
   put hTable is empty into noHandlers
   return noHandlers
end disabled_EditCardScript

on _
end _

on menu_MobileBehavior viewObject, someBoolean
   -- adds or removes
   _SetMobileCardBehavior viewObject, someBoolean
end menu_MobileBehavior

private command _SetMobileCardBehavior viewObject, someBoolean
   put the card_Object of viewObject into viewCardObject
   put the behavior_Objects of viewCardObject into bObjects
   put the name of stack "behavior_LayoutMobileOrientation" into mobileBehaviorObject
   if someBoolean is true then
      line_Add mobileBehaviorObject, bObjects
   else
      line_Delete mobileBehaviorObject, bObjects
   end if
   set the behavior_Objects of viewCardObject to bObjects
end _SetMobileCardBehavior

on menu_ImportMobileBehavior viewObject, someBoolean
   -- should close or refresh the script editor tab
   put the card_Object of viewObject into viewCardObject
   
   if someBoolean is true then
      -- put the object_MetaData of viewCardObject into uRipArray
      put the view_Name of viewObject into vName
      put metadata_ConstructUripArray (vName, "card") into uRipArray
      
      -- should be empty
      put the script of viewCardObject into viewCardScript
      
      breakpoint
      
      set the view_StoredScript of viewCardObject to viewCardScript
      
      put the behavior_Objects of viewCardObject into bObjects
      put the name of stack "behavior_ViewTemplateCard" into viewTemplateBehavior
      line_Delete viewTemplateBehavior, bObjects
      
      repeat for each line bObject in bObjects
         put word 1 to -1 of the script of bObject into bScript
         put script_DeleteSuite ("Metadata", bScript) into someScript
         put word 1 to -1 of someScript & CR & CR after bScripts
      end repeat
      delete char -2 to -1 of bScripts
      
      breakpoint
      set the script of viewCardObject to bScripts
      set the object_MetaData of viewCardObject to uRipArray
      
      _SetMobileCardBehavior viewObject, false
   else
      breakpoint
      put the view_StoredScript of viewCardObject into viewCardScript
      set the script of viewCardObject to viewCardScript -- should be empty
      set the view_StoredScript of viewCardObject to empty
      
      _SetMobileCardBehavior viewObject, true
   end if
   edit the script of viewCardObject
end menu_ImportMobileBehavior

on _
end _

on menu_ImportViewBehavior viewObject, someBoolean
   -- should close or refresh the script editor tab
   if someBoolean is true then
      put the object_MetaData of viewObject into uRipArray
      put the script of viewObject into viewScript
      set the view_StoredScript of viewObject to viewScript
      put the script of the behavior of viewObject into bScript
      set the script of viewObject to bScript
      set the object_MetaData of viewObject to uRipArray
   else
      put the view_StoredScript of viewObject into viewScript
      set the script of viewObject to viewScript
      set the view_StoredScript of viewObject to empty
   end if
   edit the script of viewObject
end menu_ImportViewBehavior

on _
end _

on menu_SetModuleBehavior scriptObject
   put the module_Behaviors of scriptObject into moduleBehaviors
   set the behavior_Objects of scriptObject to moduleBehaviors
   
   repeat for each line someObject in moduleBehaviors
      put the short name of someObject into bName
      put "Set the view behavior of" && the mobile_Name of scriptObject && "to" && kwote (bName) into someMessage
      lcw_Notify someMessage
      
      edit the script of someObject
   end repeat
end menu_SetModuleBehavior

on menu_EditModuleBehavior scriptObject
   put the module_Behaviors of scriptObject into moduleBehaviors
   if moduleBehaviors is empty then
      answer "there are no behaviors for this module!"
      exit to top
   end if
   repeat for each line moduleBehavior in moduleBehaviors
      edit the script of moduleBehavior
   end repeat
end menu_EditModuleBehavior

on _
end _

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

on _
end _

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

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Global | Behavior | View | Menu | Props
-
getprop disabled_ExportBehaviors [viewObject]
   put the imported_Behaviors of viewObject into someBoolean
   if someBoolean is true then
      return false
   else
      return true
   end if
end disabled_ExportBehaviors

getprop imported_Behaviors [viewObject]
   put the imported_Behaviors of viewObject into someBoolean
   return someBoolean
end imported_Behaviors

getprop import_MobileBehavior [viewObject]
   put the card_object of viewObject into viewCardObject
   put the revAvailableHandlers of viewCardObject into hTable
   put hTable is empty into scriptIsEmpty
   if scriptIsEmpty then
      return false
   else
      return true
   end if
end import_MobileBehavior

getprop import_ViewBehavior [viewObject]
   put the revAvailableHandlers of viewObject into hTable
   return hTable is not empty
end import_ViewBehavior

getprop mobile_Behavior [viewObject]
   put the card_Object of viewObject into viewCardObject
   put the behavior_Objects of viewCardObject into bObjects
   put the name of stack "behavior_LayoutMobileOrientation" into mobileBehaviorObject
   
   put mobileBehaviorObject is among the lines of bObjects into someBoolean
   return someBoolean
end mobile_Behavior



--> Global | Behavior | View | Menu | Disabled
-
getprop disabled_ImportMobileBehavior [viewObject]
   put the card_Object of viewObject into viewCardObject
   
   put the behavior_Objects of viewCardObject into bObjects
   put the name of stack "behavior_ViewTemplateCard" into viewTemplateBehavior
   line_Delete viewTemplateBehavior, bObjects
   
   if bObjects is empty then
      return true
   else
      return false
   end if
end disabled_ImportMobileBehavior

getprop disabled_EditViewBehavior [viewObject]
   put the behavior of viewObject into bObject
   put exists (bObject) into bExists
   if bExists is true then
      return false
   else
      return true
   end if
end disabled_EditViewBehavior

getprop disabled_SetViewCardBehavior [viewObject]
   put the card_Object of viewObject into templateCardObject
   put the behavior of templateCardObject into bObject
   put bObject = the name of stack "behavior_ViewTemplateCard" into behaviorIsSet
   return behaviorIsSet
end disabled_SetViewCardBehavior

getprop disabled_SetModuleBehavior [viewObject]
   put the behavior_Objects of viewObject into bObjects
   put the module_Behaviors of viewObject into mObjects
   return bObjects = mObjects
end disabled_SetModuleBehavior

getprop disabled_GoToView [scriptObject]
   put the object_MetaData ["type"] of scriptObject into mObectType
   put mObectType contains "view" into viewOrViewBehavior
   return viewOrViewBehavior is false
end disabled_GoToView

getprop disabled_ConvertViewBehavior [scriptObject]
   put the object_IsOldBehavior of scriptObject into isOldBehavior
   return isOldBehavior is false
end disabled_ConvertViewBehavior

on submenu_Development
   return "Dev | Menu"
end submenu_Development


--> Global | View | Script | Menu | Props
-


--> Global | View | Script | Menu | Disabled
-
getprop disabled_AddViewBehavior [mTarget]
   if exists (the behavior of mTarget) then
      return "delete"
   else
      return false
   end if
end disabled_AddViewBehavior

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


--> Dev | Menu
-
on menu_CreateView scriptObject
   breakpoint
   -- template_ConstructCloneStack
   template_ConstructStackFromObject scriptObject
end menu_CreateView

on menu_AddViewBehavior viewObject
   breakpoint
   view_AddBehavior viewObject
end menu_AddViewBehavior

on _
end _

on menu_ResetViewBehavior viewObject
   put the behavior of viewObject into bStackObject
   set the behavior of viewObject to bStackObject
end menu_ResetViewBehavior

on menu_FixViewBehaviors viewObject
   put the card_Object of viewObject into cardObject
   display_BrokenBehaviors cardObject, true
end menu_FixViewBehaviors

on _
end _

on menu_ConvertViewBehavior scriptObject
   put "Choose a name for your script only menu stack...." into pQuestion
   put "Global_Example_Menu" into suggestedAnswer
   
   put the script of scriptObject into bScript
   lcw_CreateLibrary "controller", pQuestion, suggestedAnswer
end menu_ConvertViewBehavior

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

command menu_SetChoice menuChoice, @mainChoice, @secondChoice
   put line 1 of menuChoice into menuChoice
   set the itemdelimiter to "|"
   put item 1 of menuChoice into mainChoice
   put item 2 to -1 of menuChoice into secondChoice
end menu_SetChoice

on menu_SetTemplateStack mTarget, libStack
   set the view_TemplateStack of mTarget to libStack
end menu_SetTemplateStack


--> Dev | Menu | Props
-
getprop lib_Stacks
   put library_ListUsedStacks() into libStacks
   return libStacks
end lib_Stacks

local BehaviorObjectMenu, ObjectDictionary

getprop some_Things [mTarget]
   return BehaviorObjectMenu
end some_Things

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


--> Deps
-
