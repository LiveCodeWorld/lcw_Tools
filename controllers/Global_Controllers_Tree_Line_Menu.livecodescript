script "Global | Controllers | Tree | Line | Menu"
--> MetaData
-
license: GPLv3
name: Global | Controllers | Tree | Line | Menu
type: controller
target: displayView
version: 0.3


--> Menu | Init
-
getprop menu_Target [tObject]
   put the display_View of tObject into displayView
   return displayView
end menu_Target

command mDoubleUp_EditHkey displayView, hName
   -- put the title_Text of displayView into gMenuTitle
   put _GetStackName (displayView) into gMenuTitle
   --
   put menu_GetGlobalController (gMenuTitle) into mController
   put hkey_Construct (hName, "M", mController) into hKey
   hkey_Edit hKey
end mDoubleUp_EditHkey

getprop moveController_Param [displayView]
   put _GetStackName (displayView) into gMenuTitle
   --
   put the project_Name of stack gMenuTitle into projectName
   return projectName
end moveController_Param

getprop moveController_Params
   return library_ListProjectNames()
end moveController_Params

getprop disabled_MoveController [displayView]
   put _GetStackName (displayView) into stackName
   --
   if exists (stack stackName) is false then
      return true
   else
      return false
   end if
end disabled_MoveController

getprop disabled_EditController [displayView]
   put _GetControllerPath (displayView) into stackPath -- loads stack into memory
   if exists (stack stackPath) is false then
      return true
   else
      return false
   end if
end disabled_EditController

private function _GetStackName displayView
   -- put the selected_Index of displayView into stackName
   put the selected_Line of displayView into stackName
   -- mTitle_Normalize gMenuTitle
   return stackName
end _GetStackName

private function _GetControllerPath displayView
   -- loads the stack into memory
   put _GetStackName (displayView) into gMenuTitle
   put the title_Text of displayView into projectName
   --
   put the project_Folder of stack projectName into projectFolder
   put project_ConstructStandardFile (gMenuTitle, projectFolder, "controllers") into controllerPath
   put there is a stack controllerPath into someBoolean
   if someBoolean is false then return empty
   return controllerPath
end _GetControllerPath

private function _SelectedMenuController displayView
   put _GetStackName (displayView) into gMenuTitle
   --
   put the name of stack gMenuTitle into mController
   return mController
end _SelectedMenuController

private command _CloseSelectedScriptTab displayView
   put _SelectedMenuController (displayView) into mController
   scriptEditor_CloseTab mController
   return mController
end _CloseSelectedScriptTab


--> Global | Controllers | Tree | Line | Menu
-
on menu_EditController displayView
   -- loads stack into memory
   put _GetControllerPath (displayView) into controllerPath
   edit the script of stack controllerPath
end menu_EditController

on _
end _

on menu_RenameController displayView
   put _GetStackName (displayView) into gMenuTitle
   --
   _CloseSelectedScriptTab displayView
   put the result into mController
   --
   ask_FixMenuControllerStackName mController
   put the result into newStackName
   --
   put the project_Name of stack gMenuTitle into projectName
   display_ProjectControllers projectName
   --
   edit the script of stack newStackName
end menu_RenameController

on menu_MoveController displayView, newProjectName
   put _GetStackName (displayView) into gMenuTitle
   put _SelectedMenuController (displayView) into mController
   --
   ask_MoveMenu mController, gMenuTitle, newProjectName, displayView
end menu_MoveController

on menu_DeleteController displayView
   put _GetStackName (displayView) into gMenuTitle
   --
   _CloseSelectedScriptTab displayView
   put the result into mController
   --
   if exists (stack gMenuTitle) is false then
      put merge ("Stack '[[gMenuTitle]]' does not exist!") into someQuestion
      lcw_AnswerWarning someQuestion, displayView
   end if
   
   put the hilited_Lines of displayView into lineNum
   put the displayed_Index of displayView into stackNames
   --
   put the fileName of stack gMenuTitle into controllerFile
   put the project_Name of stack gMenuTitle into projectName
   
   if controllerFile is empty then
      set the stackFile_RemovePaths of stack projectName to controllerFile
      put library_FetchProjectFolder (projectName) into projectFolder
      put project_ConstructFolder ("controllers", projectFolder) into controllerFolder
      
      put controllerFolder & stackName & "livecodescript" into controllerFile
      breakpoint
      exit to top
   end if
   
   set the itemdelimiter to slash
   put item -1 of controllerFile into shortControllerFile
   --
   lcw_Answer "Are you sure you want to delete the controller '[[shortControllerFile]]'?", displayView, shortControllerFile
   --
   delete stack gMenuTitle
   --
   set the stackFile_RemovePaths of stack projectName to controllerFile -- need to do this before deleting file
   delete file controllerFile
   --
   display_ProjectControllers projectName
end menu_DeleteController

on _
end _

on menu_CloseScriptTab displayView
   _CloseSelectedScriptTab displayView
end menu_CloseScriptTab

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_RevealFolder displayView
   put the title_Text of displayView into projectName
   put library_FetchProjectFolder (projectName) into projectFolder
   put project_ConstructFolder ("controllers", projectFolder) into controllerFolder
   finder_Reveal controllerFolder
end menu_RevealFolder

on _
end _

on menu_DisplayMenuItems displayView
   put _GetStackName (displayView) into gMenuTitle
   --
   display_MenuHandlers gMenuTitle
end menu_DisplayMenuItems

on menu_TestController displayView
   put _GetStackName (displayView) into gMenuTitle
   --   
   put the menu_GlobalTitle of stack gMenuTitle into mTitles
   put the stack_Folder of stack gMenuTitle & CR & the project_Folder of stack stackName
   put line 1 of mTitles into mTitle
   put gMenuTitle & comma & "the menu_GlobalTitle of stack" into displayTitle
   display_Index mTitles, displayTitle, mTitle
end menu_TestController
