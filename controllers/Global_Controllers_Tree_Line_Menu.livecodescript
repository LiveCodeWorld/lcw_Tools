script "Global | Controllers | Tree | Line | Menu"
--> MetaData
-
license: GPLv3
name: Global | Controllers | Tree | Line | Menu
type: controller
target: indexView
version: 0.3


--> Menu | Init
-
getprop menu_Target [fieldObject]
   put the index_View of fieldObject into indexView
   return indexView
end menu_Target

command mDoubleUp_EditHkey indexView, hName
   put the title_Text of indexView into gMenuTitle
   put menu_GetGlobalController (gMenuTitle) into mController
   put hkey_Construct (hName, "M", mController) into hKey
   hkey_Edit hKey
end mDoubleUp_EditHkey

getprop moveController_Param [indexView]
   put the selected_Index of indexView into stackName
   put the project_Name of stack stackName into projectName
   return projectName
end moveController_Param

getprop moveController_Params
   return library_ListProjectNames()
end moveController_Params

getprop disabled_MoveController [indexView]
   put the selected_Index of indexView into stackName
   --
   if exists (stack stackName) is false then
      return "delete"
   else
      return false
   end if
end disabled_MoveController

getprop disabled_EditController [indexView]
   put _GetControllerPath (indexView) into stackPath -- loads stack into memory
   if exists (stack stackPath) is false then
      return "delete"
   else
      return false
   end if
end disabled_EditController

function _GetControllerPath indexView
   -- loads the stack into memory
   put the title_Text of indexView into projectName
   put the project_Folder of stack projectName into projectFolder
   --
   put the selected_Index of indexView into gMenuTitle
   put project_ConstructStandardFile (gMenuTitle, projectFolder, "controllers") into controllerPath
   put there is a stack controllerPath into someBoolean
   if someBoolean is false then return empty
   return controllerPath
end _GetControllerPath

function _SelectedMenuController indexView
   put the selected_Index of indexView into gMenuTitle
   put the name of stack gMenuTitle into mController
   return mController
end _SelectedMenuController

private command _CloseSelectedScriptTab indexView
   put _SelectedMenuController (indexView) into mController
   scriptEditor_CloseTab mController
   return mController
end _CloseSelectedScriptTab


--> Global | Controllers | Tree | Line | Menu
-
on menu_EditController indexView
   -- loads stack into memory
   put _GetControllerPath (indexView) into controllerPath
   edit the script of stack controllerPath
end menu_EditController

on _
end _

on menu_RenameController indexView
   put the selected_Index of indexView into gMenuTitle
   _CloseSelectedScriptTab indexView
   put the result into mController
   --
   controller_AskFixMenuName mController
   put the result into newStackName
   --
   put the project_Name of stack gMenuTitle into projectName
   display_ProjectControllers projectName
   --
   edit the script of stack newStackName
end menu_RenameController

on menu_MoveController indexView, newProjectName
   put the selected_Index of indexView into gMenuTitle
   _CloseSelectedScriptTab indexView
   put the result into mController
   --
   put the project_Name of mController into oldProjectName
   if oldProjectName is empty then
      put merge ("Stack '[[gMenuTitle]]' does not have a project name. Please correct the metadata first!") into someQuestion
      lcw_AnswerWarning someQuestion, indexView
   end if
   
   if oldProjectName = newProjectName then
      put merge ("Stack is already in project '[[newProjectName]]'. Choose a new project to move this library to!") into someQuestion
      lcw_AnswerWarning someQuestion
   end if
   
   put merge ("Do you want to move the controller [[mController]] to the new project '[[newProjectName]]'?") into someQuestion
   text_PrettyQuote someQuestion
   lcw_Answer someQuestion, indexView 
   
   -- moves the stack realtively
   -- as it is a controller it moves the stack to the controller folder in the new project folder
   project_MoveStackRelative gMenuTitle, newProjectName
   
   display_ProjectControllers newProjectName
   display_ProjectControllers oldProjectName
end menu_MoveController

on menu_DeleteController indexView
   put the selected_Index of indexView into gMenuTitle
   _CloseSelectedScriptTab indexView
   put the result into mController
   --
   if exists (stack gMenuTitle) is false then
      put merge ("Stack '[[gMenuTitle]]' does not exist!") into someQuestion
      lcw_AnswerWarning someQuestion, indexView
   end if
   
   put the hilited_Lines of indexView into lineNum
   put the displayed_Index of indexView into stackNames
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
   lcw_Answer "Are you sure you want to delete the controller '[[shortControllerFile]]'?", indexView, shortControllerFile
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

on menu_CloseScriptTab indexView
   _CloseSelectedScriptTab indexView
end menu_CloseScriptTab

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_RevealFolder indexView
   put the title_Text of indexView into projectName
   put library_FetchProjectFolder (projectName) into projectFolder
   put project_ConstructFolder ("controllers", projectFolder) into controllerFolder
   finder_Reveal controllerFolder
end menu_RevealFolder

on _
end _

on menu_DisplayMenuItems indexView
   put the selected_Index of indexView into stackName
   put the name of stack stackName into mController
   --
   put stackName into gMenuTitle
   mTitle_Normalize gMenuTitle
   --
   display_MenuHandlers gMenuTitle
end menu_DisplayMenuItems

on menu_TestController indexView
   put the selected_Index of indexView into stackName
   put the menu_GlobalTitle of stack stackName into mTitles
   
   put the stack_Folder of stack stackName & CR & the project_Folder of stack stackName
   
   put line 1 of mTitles into mTitle
   put stackName & comma & "the menu_GlobalTitle of stack" into displayTitle
   display_Index mTitles, displayTitle, mTitle
end menu_TestController
