script "Global | View | Behavior | Dev | Menu"
--> MetaData
-
license: GPLv3
name: Global | View | Behavior | Dev | Menu
type: controller
author: David Bovill
version: 0.1

/*
Here you can describe this developer menu.
Full help text should be provided on the linked wiki.

Consider improving by creating with same menu_Target as no-developer menu is is based on.
*/

--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   -- return display_MenuTarget(tObject)
   return the display_View of tObject
end menu_Target

getprop menu_CheckTarget [mTarget]
   return exists (mTarget)
end menu_CheckTarget


--> Global | View | Behavior | Dev | Menu
-
on menu_ModuleBehaviorFolder viewObject
   put LocalArray ["moduleFolder"] into moduleFolder
   put project_ConstructFolder ("behaviors", moduleFolder) into moduleBehaviorFolder
   finder_Reveal moduleBehaviorFolder
end menu_ModuleBehaviorFolder

on menu_ModuleFolder viewObject
   put LocalArray ["moduleFolder"] into moduleFolder
   finder_Reveal moduleFolder
end menu_ModuleFolder

on menu_ProjectFolder viewObject
   put LocalArray ["projectFolder"] into projectFolder
   finder_Reveal projectFolder
end menu_ProjectFolder

private on _
end _

on menu_ImportScriptOnlyBehaviors viewObject, someBoolean
   set the imported_ViewBehaviors [true] of viewObject to someBoolean
end menu_ImportScriptOnlyBehaviors

on menu_DeleteBehaviorGroup viewObject
   view_DeleteBehaviorGroup viewObject
end menu_DeleteBehaviorGroup

on menu_DeleteBehaviorCard viewObject
   view_DeleteBehaviorCard viewObject
end menu_DeleteBehaviorCard

private on __
end __

on menu_ChooseViewBehavior viewObject
   breakpoint
   put LocalArray ["moduleFolder"] into moduleFolder
   answer file "Select a behavior for this view..." with moduleFolder -- with type "LiveCode Stacks|rev|RSTK"
   if it is empty then exit to top
   put it into stackPath
   put the name of stack stackPath into bObject
   set the behavior of viewObject to bObject
   
   _refresh viewObject
end menu_ChooseViewBehavior

private on ___
end ___

on menu_AddViewBehavior viewObject
   breakpoint
   view_AddBehavior viewObject
end menu_AddViewBehavior

on menu_ResetViewBehavior viewObject
   put the behavior of viewObject into bStackObject
   set the behavior of viewObject to bStackObject
end menu_ResetViewBehavior

on menu_FixBrokenBehaviors viewObject, menuChoice
   switch menuChoice
      case "Fix broken behaviors"
         display_BrokenBehaviors viewObject, true
         return the result
      case "Fix view behaviors"
         put the behavior_Objects of mTarget into someObjects
         break
      case "Fix all view behavors"
         put view_WithBehaviorIndex() into someObjects
         break
   end switch
   
   repeat for each line someObject in someObjects
      set the cursor to busy
      set the behavior of someObject to the behavior of someObject
   end repeat
   put someObjects
end menu_FixBrokenBehaviors

private on ____
end ____


/*
These look like an old way of using the cardscript for the view
Now we use "the imported_ViewBehaviors"
and store the behaviors in buttons in a group
*/

on _ConvertViewBehavior scriptObject
   breakpoint
   put "Choose a name for your script only menu stack...." into pQuestion
   put "Global_Example_Menu" into suggestedAnswer
   
   put the script of scriptObject into bScript
   lcw_CreateLibrary "controller", pQuestion, suggestedAnswer
end _ConvertViewBehavior

on _MobileBehavior viewObject, someBoolean
   breakpoint
   -- adds or removes
   _SetMobileCardBehavior viewObject, someBoolean
end _MobileBehavior

on _ImportMobileBehavior viewObject, someBoolean
   breakpoint
   -- should close or refresh the script editor tab
   put the card_Object of viewObject into viewCardObject
   
   if someBoolean is true then
      -- put the object_MetaData of viewCardObject into uRipArray
      put the view_Name of viewObject into vName
      put metadata_ConstructArray (vName, "card") into uRipArray
      
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
end _ImportMobileBehavior

on _ImportViewBehavior viewObject, someBoolean
   breakpoint
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
end _ImportViewBehavior

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

getprop disabled_AddViewBehavior [mTarget]
   if exists (the behavior of mTarget) then
      return "delete"
   else
      return false
   end if
end disabled_AddViewBehavior


