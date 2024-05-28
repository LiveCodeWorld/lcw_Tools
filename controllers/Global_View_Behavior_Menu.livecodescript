script "Global | View | Behavior | Menu"
--> MetaData
-
license: GPLv3
name: Global | View | Behavior | Menu
type: controller
version: 0.1


--> Variables
-
local LocalArray


--> Working on
-
private function project_ConstructFolder shortFolder, standardFolder
   text_AddTrailing standardFolder, slash
   if shortFolder is not empty then put shortFolder & slash after standardFolder
   return standardFolder
end project_ConstructFolder


--> Menu | Props
-
getprop menu_Target [tObject]
   put the display_View of tObject into dView
   put the displayed_Object of dView into viewObject
   --
   _InitProps tObject
   --
   return viewObject
end menu_Target

command _InitProps tObject
   put the display_View of tObject into displayView
   put displayView into LocalArray ["displayView"]
   
   put the view_Index of displayView into LocalArray ["bObjects"]
   put the displayed_ProjectName of displayView into LocalArray ["projectName"]
   put the displayed_ProjectFolder of displayView into LocalArray ["projectFolder"]
   put the displayed_ModuleFolder of displayView into LocalArray ["moduleFolder"]
   put the displayed_ModuleName of displayView into LocalArray ["moduleName"]
   put the displayed_ModuleHomeStackPath of displayView into LocalArray ["moduleHomeStackPath"]   
end _InitProps

getprop editMenu_Params [viewObject]
   if viewObject is empty then return empty
   put the module_ControllerStackNames of viewObject into stackNames
   return stackNames
end editMenu_Params

getprop module_Behavior [viewObject]
   put the behavior_Objects of viewObject into bObjects
   return bObjects
end module_Behavior

getprop module_Behaviors [viewObject]
   --  put the module_Behaviors of templateView into moduleBehaviors
   put the module_Behaviors of viewObject into moduleBehaviors
   return moduleBehaviors
end module_Behaviors

getprop import_ScriptOnlyBehaviors [viewObject]
   put the imported_ViewBehaviors of viewObject into alreadyImported
   return alreadyImported
end import_ScriptOnlyBehaviors

getprop disabled_EditViewBehavior [viewObject]
   put the behavior of viewObject into bObject
   if exists (bObject) then
      return false
   else
      return true
   end if
end disabled_EditViewBehavior

getprop disabled_DeleteBehaviorGroup [viewObject]
   put the view_BehaviorGroup of viewObject into viewBehaviorGroup
   if exists (viewBehaviorGroup) then
      return false
   else
      return true
   end if
end disabled_DeleteBehaviorGroup

getprop disabled_DeleteBehaviorCard [viewObject]
   put view_GetBehaviorCard (viewObject) into bCardObject
   if exists (bCardObject) then
      return false
   else
      return true
   end if
end disabled_DeleteBehaviorCard

getprop disabled_MoveExternalBehaviors [viewObject]
   put the module_ExternalBehaviors of viewObject into bObjects
   if bObjects is empty then
      return true
   else
      return false
   end if
end disabled_MoveExternalBehaviors

getprop disabled_ModuleBehaviorFolder [viewObject]
   put LocalArray ["moduleFolder"] into moduleFolder   
   put project_ConstructFolder ("behaviors", moduleFolder) into moduleBehaviorFolder
   if there is a folder moduleBehaviorFolder then
      return false
   else
      return true
   end if
end disabled_ModuleBehaviorFolder

getprop disabled_ExportBehaviors [viewObject]
   put the imported_ViewBehaviors of viewObject into someBoolean
   if someBoolean is true then
      return false
   else
      return true
   end if
end disabled_ExportBehaviors

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

private command _refresh viewObject
   put LocalArray ["displayView"] into displayView
   display_ViewBehaviors viewObject, displayView
end _refresh

private function _ModuleBehaviorPath viewObject
   put the stack_Folder of viewObject into moduleFolder
   put module_BehaviorPathFromFolder (moduleFolder) into bPath
   if exists (stack bPath) is false then breakpoint
   
   return bPath
end _ModuleBehaviorPath

getprop menu_CheckTarget [viewObject]
   return false
   return module_CheckFirstView (viewObject)
end menu_CheckTarget

getprop checked_SetDefaultBehavior [viewObject]
   put module_BehaviorPathFromFolder (moduleFolder) into bPath
   
end checked_SetDefaultBehavior


--> Global | View | Behavior | Menu
-
on menu_SetDefaultBehavior viewObject
   
   # Get Module Behavior path
   
   # Set Behavior
   put the name of stack bPath into bObject
   set the behavior of viewObject to bObject
   
   # Display
   display_ObjectProperties viewObject
end menu_SetDefaultBehavior

private on _
end _

on menu_ListBehaviorObjects viewObject
   put the behavior_Objects of viewObject into bObjects
   --
   put LocalArray ["displayView"] into displayView
   set the displayed_Index of displayView to bObjects
end menu_ListBehaviorObjects

on menu_ListModuleBehaviors viewObject
   put the module_Behaviors of viewObject into moduleBehaviors
   /*
   put LocalArray ["projectFolder"] into projectFolder
   put LocalArray ["moduleName"] into moduleName
   put module_ListBehaviorStackNames (moduleName, projectFolder) into moduleBehaviors
   */
   --
   put LocalArray ["displayView"] into displayView
   --
   lock screen
   set the displayed_Index of displayView to moduleBehaviors
   put the behavior_Objects of viewObject into bObjects
   set the coloured_Lines ["green"] of displayView to bObjects
   unlock screen
end menu_ListModuleBehaviors

private on __
end __

on menu_EditMenu viewObject, mStackName
   edit the script of stack mStackName
end menu_EditMenu

on menu_EditViewBehavior viewObject
   put the behavior of viewObject into bObject
   edit the script of bObject
end menu_EditViewBehavior

on menu_DisplayNestedViewArray viewObject
   display_NestedViewArray viewObject
end menu_DisplayNestedViewArray

private on ___
end ___

on menu_MoveExternalBehaviors viewObject, moveWhere
   breakpoint
   put LocalArray ["projectName"] into thisProjectName
   put LocalArray ["bObjects"] into bObjects
   put LocalArray ["projectFolder"] into projectFolder
   put LocalArray ["moduleFolder"] into moduleFolder
   
   switch moveWhere
      case "project behavior"
         put project_ConstructFolder ("behaviors", projectFolder) into newBehaviorFolder
         break
      case "module behavior"
         put project_ConstructFolder ("behaviors", moduleFolder) into newBehaviorFolder
         break
   end switch
   folder_CreateNested newBehaviorFolder
   
   set the itemdelimiter to slash
   repeat for each line bObject in bObjects
      put the project_Name of bObject into otherProjectName
      if otherProjectName is not thisProjectName then
         put bObject & CR after externalBehaviors
         
         put the filename of bObject into oldBehaviorPath
         put item -1 of oldBehaviorPath into shortFile
         put newBehaviorFolder & shortFile into newBehaviorPath
         
         breakpoint
         project_MoveStack oldBehaviorPath, newBehaviorPath, true
      end if
   end repeat
   delete char -1 of externalBehaviors
   put externalBehaviors
end menu_MoveExternalBehaviors

private on ____
end ____

on menu_Refresh viewObject
   _refresh viewObject
end menu_Refresh

on submenu_Dev
   return menu_DevTitle ("Global | View | Behavior | Menu")
end submenu_Dev
