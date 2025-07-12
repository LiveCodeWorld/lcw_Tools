script "Global | Project | Module | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Project | Module | Line | Menu
type: controller
version: 0.2

/*
This used to rely on moduleStackName = the home stack name of the module
Now we use directory walking and short and long paths.
*/


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   _Init tObject
   return LocalArray ["moduleStackName"]
end menu_Target

command _Init tObject
   # dView
   put the display_View of tObject into displayView
   put displayView into LocalArray ["displayView"]
   
   # projectName
   put _GetProjectName (displayView) into projectName
   
   # projectFolder
   put the project_Folder of stack projectName into LocalArray ["projectFolder"]
   
   # moduleStackName
   put _SelectedModuleStackName (displayView) into moduleStackName
   put moduleStackName into LocalArray ["moduleStackName"]
   
   # folders
   put _SelectedModuleFolder (displayView) into moduleFolder
   put project_PathFromFolder (moduleFolder) into moduleHomeStackPath
   put moduleFolder into LocalArray ["moduleFolder"]
   put moduleHomeStackPath into LocalArray ["moduleHomeStackPath"]
end _Init

private function _GetProjectName displayView
   put the title_Text of displayView into projectName
   put projectName into LocalArray ["projectName"]
   return projectName
end _GetProjectName

private function _ModulesFolder
   put LocalArray ["projectFolder"] into projectFolder
   put projectFolder & "modules/" into mFolder
   return mFolder
end _ModulesFolder

function _ShortModuleFolder displayView
   put the selected_Path of displayView into sPath
   if item 1 of sPath is not "modules" then return empty
   return item 2 of sPath
end _ShortModuleFolder

function _SelectedModuleFolder displayView
   put _ModulesFolder() into mFolder
   put _ShortModuleFolder (displayView) into shortModuleFolder
   put mFolder & shortModuleFolder & slash into subModuleFolder
   return subModuleFolder
end _SelectedModuleFolder

private function _SelectedModuleStackName displayView
   if the stack_Label of displayView is "Project" then
      -- put _GetProjectName (displayView) into projectName
      -- put _ShortModuleFolder (displayView) into moduleFolderName
      -- put module_GetHomeStackPath (moduleFolderName, projectName) into moduleHomeStackPath
      
      -- put _SelectedModuleFolder (displayView) into moduleFolder
      -- put project_PathFromFolder (projectFolder)(moduleFolder) into moduleHomeStackPath
      
      put _SelectedModuleFolder(displayView) into moduleFolder
      put project_PathFromFolder (moduleFolder) into moduleHomeStackPath
      
      if there is a stack moduleHomeStackPath then
         return the short name of stack moduleHomeStackPath
      else
         return empty
      end if
   else
      return _ModuleStackName (displayView)
   end if
end _SelectedModuleStackName

private function _ModuleStackName displayView
   put the selected_Line of displayView into moduleStackName
   if exists (stack moduleStackName) is false then
      breakpoint
      return empty
   else
      return empty
   end if
end _ModuleStackName

private function _GetProjectFolder
   return LocalArray ["projectFolder"]
end _GetProjectFolder

private function _GetModuleFolder
   return LocalArray ["moduleFolder"]
end _GetModuleFolder

private function _GetStackName
   return LocalArray ["moduleStackName"]
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
on menu_ModuleReadme
   put LocalArray ["moduleStackName"] into moduleStackName
   display_ModuleReadme moduleStackName
end menu_ModuleReadme

getprop checked_ModuleReadme
   put _ReadmeFile() into readMeFile
   return there is a file readMeFile
end checked_ModuleReadme

private function _ReadmeFile
   put LocalArray ["moduleStackName"] into moduleStackName
   --
   put module_ConstructReadMeFile (moduleStackName) into readMeFile
   return readMeFile
end _ReadmeFile

on menu_RevealModuleReadme
   put _ReadmeFile() into readMeFile
   finder_Reveal readMeFile
end menu_RevealModuleReadme

on menu_RevealModuleFolder
   put _GetModuleFolder() into moduleFolder
   finder_Reveal moduleFolder
end menu_RevealModuleFolder

private on ____
end ____

-- on menu_ModuleHelp
put _GetModuleStackPath() into stackPath
put LocalArray ["moduleStackName"] into moduleStackName
--
draft_ModuleHelp moduleStackName
end menu_ModuleHelp

on menu_DisplayModuleTools
   put _GetModuleStackPath() into stackPath
   --
   display_ModuleTools stackPath
end menu_DisplayModuleTools

on menu_DisplayModule
   put _GetModuleStackPath() into stackPath
   --
   show stack stackPath
   toplevel stack stackPath
   --
   put LocalArray ["displayView"] into displayView
   set the loc of stack stackPath to the loc of displayView
end menu_DisplayModule

private on _
end _

on menu_CreateModule
   put lcw_Ask ("What name would you like for this module?", "View|Something") into moduleStackName
   --
   put LocalArray ["projectName"] into projectName
   module_CreateWithObject moduleStackName, projectName
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

on menu_EditModuleBehavior moduleStackName
   put view_GetTemplateObject (moduleStackName) into viewObject
   put the behavior of viewObject into bObject
   edit the script of bObject
end menu_EditModuleBehavior

on menu_ExportModuleJson moduleStackName
   -- put _GetStackName (displayView) into moduleStackName
   put _GetModuleFolder() into moduleFolder
   if there is not a folder moduleFolder then
      breakpoint
      exit to top
   end if
   
   # Create and export json
   project_ExportMenusAndStackFiles moduleFolder
   put the result into moduleArray
   put the module_Array of stack moduleStackName into moduleArray
   
   # Set stackfiles
   put moduleArray ["stackFileArray"] into sfArray
   set the stackFile_Array of stack moduleStackName to sfArray
   
   # Display Data
   display_Data moduleArray, moduleStackName, "Module Array"  
   
end menu_ExportModuleJson

on menu_EditModuleHome moduleStackName
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

on menu_TrashModule moduleStackName
   put LocalArray ["displayView"] into displayView
   lcw_Answer "Move module folder '[[moduleStackName]]' to the Trash?", displayView, moduleStackName
   
   module_Trash moduleStackName
   --
   display_ModuleFromStackName moduleStackName
end menu_TrashModule

on menu_RemoveFromMemory moduleStackName
   module_RemoveFromMemory moduleStackName
end menu_RemoveFromMemory

on submenu_Dev
   return menu_DevTitle()
end submenu_Dev
