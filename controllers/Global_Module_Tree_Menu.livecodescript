script "Global | Module | Tree | Menu"
--> MetaData
-
license: GPLv3
name: Global | Module | Tree | Menu
target: indexView
type: controller
version: 0.2


--> Menu | Init
-
local LocalArray

getprop menu_Target [tObject]
   put the display_View of tObject into displayView
   put the displayed_Object of displayView into viewObject
   --
   put the displayed_ModuleName of displayView into moduleName
   put the title_Text of displayView into moduleName
   
   # Some Tests
   if there is not a stack moduleName then return empty
   if exists (control 1 of cd 1 of stack moduleName) is false then return empty
   put the long id of control 1 of cd 1 of stack moduleName into testViewObject
   if testViewObject is not viewObject then
      breakpoint
      return empty
   end if
   --
   put the displayed_ModuleFolder of displayView into moduleFolder
   put _GetClonedStackNames (viewObject) into clonedStackNames
   put clonedStackNames into LocalArray ["clonedStackNames"]
   --
   put moduleName into LocalArray ["moduleName"]
   put moduleFolder into LocalArray ["moduleFolder"]
   put displayView into LocalArray ["displayView"]
   --
   return viewObject
end menu_Target

getprop disabled_CloseModuleStack
   if LocalArray ["clonedStackNames"] is empty then
      return true
   else
      return false
   end if
end disabled_CloseModuleStack

getprop closeModuleStack_Params
   return LocalArray ["clonedStackNames"]
end closeModuleStack_Params

getprop disabled_ModuleStackTools
   if LocalArray ["clonedStackNames"] is empty then
      return "delete"
   else
      return false
   end if
end disabled_ModuleStackTools

getprop moduleStackTools_Params
   return LocalArray ["clonedStackNames"]
end moduleStackTools_Params

command _importMenus viewObject
   put the module_Controllers of viewObject into cObjects
   repeat for each line cObject in cObjects
      if exists (cObject) is false then 
         breakpoint
         next repeat
      end if
      
      if word 1 of cObject is not "stack" then
         breakpoint
         next repeat
      end if
      
      put the stack_Name of cObject into cStackName
      put cStackName && "Dep"
      
      clone cObject
      put it into clonedBehaviorStack
      set the name of clonedBehaviorStack to newName
   end repeat
end _importMenus

private function _GetClonedStackNames viewObject
   put the openstacks into sNames
   put the stack_Name of viewObject into stackName
   put stackName && "*" into someFilter
   filter sNames with someFilter
   --
   replace "|" with ":" in sNames
   return sNames
end _GetClonedStackNames

getprop disabled_SelectModule
   if the selobj is empty then
      return false
   else
      return "delete"
   end if
end disabled_SelectModule

getprop disabled_DeselectModule
   if the selobj is empty then
      return "delete"
   else
      return false
   end if
end disabled_DeselectModule


--> Global | Module | Tree | Menu
-
on menu_CreateModuleMenu viewObject
   put LocalArray ["moduleName"] into moduleName
   put LocalArray ["displayView"] into displayView
   --
   ask_CreateModuleMenu moduleName, displayView
   --
   -- module_CreateMenu moduleStackName, pGlobalMenuTitle, pControllerScript
end menu_CreateModuleMenu

private on _
end _

on menu_ModuleStackTools viewObject, moduleStackName
   replace ":" with "|" in moduleStackName
   --
   display_ModuleTools moduleStackName
end menu_ModuleStackTools

on menu_CloneModule viewObject
   put LocalArray ["moduleName"] into moduleName
   if exists (stack moduleName) is false then lcw_AnswerWarning "No such stack!"
   --
   stack_Clone moduleName
   put the result into clonedStack
   set the original_ModuleName of clonedStack to moduleName
   --
   put the stack_Name of clonedStack into moduleStackName
   display_ModuleTools moduleStackName
end menu_CloneModule

on menu_CloseModuleStack viewObject, moduleStackName
   replace ":" with "|" in moduleStackName
   --
   module_CloseStackAndTools moduleStackName
end menu_CloseModuleStack

private on __
end __

on menu_RememberModuleStacks viewObject
   set the cursor to watch
   --
   put the module_Name of viewObject into shortModuleFolder
   put the view_Name of viewObject into moduleStackName
   if exists (stack moduleStackName) is false then
      put LocalArray ["displayView"] into displayView
      lcw_AnswerWarning "Cannot local module stack '[[moduleStackName]]!", displayView, moduleStackName
   end if
   put the module_Folder of viewObject into moduleFolder
   
   # Set module stackfiles
   put the folder_StackFileArray of viewObject into stackFileArray
   set the stackFile_Array of viewObject to stackFileArray
   save stack moduleStackName
   --
   module_ExportMenusAndStackFiles moduleFolder
   put the result into moduleArray
   
   # Check
   put project_FetchArray (moduleFolder) into moduleArray
   display_Data moduleArray, moduleStackName, "Module Array"  
end menu_RememberModuleStacks

on menu_RememberProjectStacks viewObject
   put the project_Name of viewObject into projectName
   put project_GetFolder (projectName) into projectFolder
   if there is not a folder projectFolder then
      lcw_AnswerWarning "Cannot find a project folder for project:" && projectName
   end if
   --
   project_ExportMenusAndStackFiles projectFolder
   put the result into projectArray
   --
   display_ProjectLibs projectName
   display_GitRefreshProjectName projectName
end menu_RememberProjectStacks

on menu_RevealModuleFolder
   put LocalArray ["moduleFolder"] into moduleFolder
   finder_Reveal moduleFolder
end menu_RevealModuleFolder

private on ___
end ___

on menu_Refresh viewObject
   put the view_Name of viewObject into moduleStackName
   display_ModuleTools moduleStackName
end menu_Refresh

on _SelectModule viewObject
   select viewObject
end _SelectModule

on _DeselectModule viewObject
   select empty
end _DeselectModule

on _ModuleInfo viewObject
   put the module_Array of viewObject into moduleArray
   put moduleArray ["moduleName"] into moduleName
   put merge ("[[moduleName]],Module Array") into someTitle
   display_Array moduleArray, someTitle
end _ModuleInfo

on _DisplayToolMenuTitles viewObject
   put view_ConstructToolMenu (viewObject)
end _DisplayToolMenuTitles

on _EditViewMenuFunction
   -- find the function that creates the menu table for the tree
   
   hkey_Edit "F view_ConstructToolMenu"
   --
   if the result is empty then 
      edit the script of stack "lib_DisplayView"
   end if
end _EditViewMenuFunction

on _EditDisplayModuleTools
   hkey_Edit "M display_ModuleTools"
   --
   if the result is empty then 
      edit the script of stack "lib_DisplayModule"
   end if
end _EditDisplayModuleTools

on _
end _

on _ResetMenus viewObject
   put LocalArray ["displayView"] into displayView
   --
   put view_ConstructToolMenu (viewObject) into mTitles
   set the title_Menu of displayView to mTitles
end _ResetMenus

on _
end _

on _CreateStandAlone viewObject
   put LocalArray ["displayView"] into displayView
   --
   put the view_Name of viewObject into vName
   put view_GetTemplateObject (vName) into templateObject
   if exists (templateObject) is false then
      breakpoint
   end if
   
   put the stack_Name of templateObject into stackName
   clone stack stackName
   put it into clonedStack
   set the destroyStack of clonedStack to true
   set the destroyWindow of clonedStack to true
   
   put the long id of cd 1 of clonedStack into clonedTemplateCard
   put the long id of control 1 of clonedTemplateCard into clonedView
   
   -- put the module_Behaviors of viewObject into bObjects
   set the imported_ViewBehaviors of clonedView to true
   
   -- set the behavior of clonedTemplateCard to empty
   
   display_ViewBehaviors clonedView, empty, clonedStack
end _CreateStandAlone
