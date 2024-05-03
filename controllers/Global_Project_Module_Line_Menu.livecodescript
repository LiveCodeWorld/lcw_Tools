script "Global | Project | Module | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Project | Module | Line | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   _Init tObject
   return LocalArray ["moduleName"]
end menu_Target

command _Init tObject
   put the display_View of tObject into displayView
   put the selected_Line of displayView into moduleName
   put the title_Text of displayView into projectName
   
   if exists (stack moduleName) is false then
      breakpoint
      return empty
   end if
   
   put the stack_Folder of stack moduleName into moduleFolder
   put project_PathFromFolder (moduleFolder) into moduleHomeStackPath
   
   put the project_Folder of stack moduleName into LocalArray ["projectFolder"]
   put displayView into LocalArray ["displayView"]
   put moduleName into LocalArray ["moduleName"]
   put moduleFolder into LocalArray ["moduleFolder"]
   put moduleHomeStackPath into LocalArray ["moduleHomeStackPath"]
   put projectName into LocalArray ["projectName"]
end _Init

private function _GetProjectFolder
   return LocalArray ["projectFolder"]
end _GetProjectFolder

private function _GetModuleFolder
   return LocalArray ["moduleFolder"]
end _GetModuleFolder

private function _GetStackName
   return LocalArray ["moduleName"]
end _GetStackName

private function _GetModuleStackPath
   return LocalArray ["moduleHomeStackPath"]
end _GetModuleStackPath

getprop moveModule_Param
   return LocalArray ["projectName"]
end moveModule_Param

getprop moveModule_Params
   return env_ListActiveProjects()
   return library_ListProjectNames()
end moveModule_Params


--> Global | Project | Module | Line | Menu
-
on menu_DisplayModule
   put _GetModuleStackPath() into stackPath
   --
   show stack stackPath
   toplevel stack stackPath
   --
   put LocalArray ["displayView"] into displayView
   set the loc of stack stackPath to the loc of displayView
end menu_DisplayModule

on menu_DisplayModuleTools
   put _GetModuleStackPath() into stackPath
   --
   display_ModuleTools stackPath
end menu_DisplayModuleTools

private on _
end _

on menu_CreateModule
   put lcw_Ask ("What name would you like for this module?", "View|Something") into moduleName
   --
   put LocalArray ["projectName"] into projectName
   module_CreateWithObject moduleName, projectName
end menu_CreateModule

on menu_CreateModuleMenu moduleStackName
   put module_ConstructGlobalMenuTitle (moduleStackName) into gMenuTitle
   breakpoint
   --
   put menu_GetGlobalController (gMenuTitle) into mController
   if exists (mController) then
      put module_ConstructGlobalMenuTitle (moduleStackName & "|Test") into gMenuTitle
      ask_CreateModuleMenu moduleStackName, displayView, gMenuTitle
   else
      ask_CreateModuleMenu moduleStackName, displayView
   end if
   put the result into mController
   --
   if exists (mController) then
      edit the script of mController
   end if
end menu_CreateModuleMenu

private on __
end __

on menu_EditModuleBehavior moduleName
   put view_GetTemplateObject (moduleName) into viewObject
   put the behavior of viewObject into bObject
   edit the script of bObject
end menu_EditModuleBehavior

on menu_ExportModuleJson
   put _GetModuleFolder() into moduleFolder
   if there is not a folder moduleFolder then
      breakpoint
      exit to top
   end if
   
   project_ExportMenusAndStackFiles moduleFolder
   put the result into projectArray
   --
   put _GetStackName (displayView) into moduleName
   display_Data projectArray, moduleName, "Module Array"  
end menu_ExportModuleJson

on menu_EditModuleHome moduleName
   put _GetStackName (displayView) into mStackName
   --
   go to stack mStackName
   edit the script of stack mStackName
end menu_EditModuleHome

private on ___
end ___

on menu_MoveModule oldModuleName, newProjectName
   module_Move oldModuleName, newProjectName
end menu_MoveModule

on menu_TrashModule moduleName
   put LocalArray ["displayView"] into displayView
   --
   lcw_Answer "Move module folder '[[moduleName]]' to the Trash?", displayView, moduleName
   module_Trash moduleName
   --
   display_ModuleFromStackName moduleName
end menu_TrashModule

on menu_RemoveFromMemory moduleName
   module_RemoveFromMemory moduleName
end menu_RemoveFromMemory

on submenu_Dev
   return menu_DevTitle()
end submenu_Dev

