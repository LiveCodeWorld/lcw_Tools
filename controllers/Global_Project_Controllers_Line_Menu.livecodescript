script "Global | Project | Controllers | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Project | Controllers | Line | Menu
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
   put the display_View of tObject into dView
   --
   put _GetGlobalController (dView) into mController
   put mController into LocalArray ["mController"]
   put exists (mController) into LocalArray ["menuExists"]
   --
   put _GetControllerPath (dView) into stackPath -- loads stack into memory
   put stackPath into LocalArray ["stackPath"]
   put exists (stack stackPath) into LocalArray ["stackPathExists"]
   --
   return dView
end menu_Target

getprop menu_CheckTarget [dView]
   put LocalArray ["mController"] into mController
   return exists (mController)
end menu_CheckTarget


--> Private
-
private function _GoodShortFile dView
   put _GetStackName (dView) into gMenuTitle
   put project_ConstructShortFile (gMenuTitle) into goodShortFile
   return goodShortFile
end _GoodShortFile

private function _SelectedShortFile dView
   put the selected_Line of dView into goodShortFile
   return goodShortFile
end _SelectedShortFile

private function _GetProjectFolder dView
   put the title_Text of dView into projectName
   --
   put env_ProjectFolder (projectName) into projectFolder
   return projectFolder
end _GetProjectFolder

private function _GetRelPath dView
   put the selected_Path of dView into sPath
   replace comma with slash in sPath
   return sPath
end _GetRelPath

private function _GetStackPath dView
   put _GetRelPath (dView) into sPath
   put _GetProjectFolder(dView) into projectFolder
   put projectFolder & sPath into stackPath
   if exists (stack stackPath) is true then
      return stackPath
   else
      return empty
   end if
end _GetStackPath

private function _GetStackName dView
   put _GetStackPath (dView) into stackPath
   if stackPath is empty then return empty
   --
   put the short name of stack stackPath into stackName
   return stackName
end _GetStackName

private function _GetControllerPath dView
   put _GetStackName (dView) into gMenuTitle
   if exists (stack gMenuTitle) then
      put the filename of stack gMenuTitle into sPath
      return sPath
   else
      breakpoint
      return _GetStandardControllerPath (dView)
   end if
end _GetControllerPath

private function _GetGlobalController dView
   put _GetStackName (dView) into gMenuTitle
   if exists (stack gMenuTitle) then
      return the name of stack gMenuTitle
   else
      breakpoint
      put menu_GetGlobalController (gMenuTitle) into mController
      return mController
   end if
end _GetGlobalController

private function _MenuController dView
   put _GetControllerPath (dView) into cPath
   if exists (stack cPath) is false then
      put _GetStackName (dView) into gMenuTitle
      put "mController path:" && cPath
      lcw_AnswerWarning "Cannot locate file for global menu '[[gMenuTitle]]'!", dView, gMenuTitle
   end if
   
   put the name of stack cPath into mController
   return mController
end _MenuController

private function _SelectedMenuController dView
   put _GetStackName (dView) into gMenuTitle
   --
   put the name of stack gMenuTitle into mController
   return mController
end _SelectedMenuController

private function _GetStandardControllerPath dView
   put _GetStackName (dView) into gMenuTitle
   
   put the title_Text of dView into projectName
   put the project_Folder of stack projectName into projectFolder
   put project_ConstructStandardFile (gMenuTitle, projectFolder, "controllers") into controllerPath
   put there is a stack controllerPath into someBoolean
   if someBoolean is false then return empty
   return controllerPath
end _GetStandardControllerPath

private command _CloseSelectedScriptTab dView
   put _SelectedMenuController (dView) into mController
   scriptEditor_CloseTab mController
   return mController
end _CloseSelectedScriptTab

getprop moveController_Param [dView]
   put _GetStackName (dView) into gMenuTitle
   put the project_Name of stack gMenuTitle into projectName
   return projectName
end moveController_Param

getprop moveController_Params
   return library_ListProjectNames()
end moveController_Params

getprop disabled_EditController [dView]
   return LocalArray ["stackPathExists"] is false
end disabled_EditController

getprop disabled_FixShortFile [dView]
   return LocalArray ["menuExists"] is false
end disabled_FixShortFile

-- getprop disabled_RenameController
return LocalArray ["menuExists"] is false
end disabled_RenameController

-- getprop disabled_ReindexMenu [dView]
return LocalArray ["menuExists"] is true
end disabled_ReindexMenu

getprop disabled_DeleteController
   return LocalArray ["menuExists"] is false
end disabled_DeleteController

getprop disabled_MoveController [dView]
   return LocalArray ["menuExists"] is false
end disabled_MoveController

getprop disabled_FixShortFile [dView]
   put _GetStackName (dView) into gMenuTitle
   put _GoodShortFile (dView) into goodShortFile
   put the short_File of stack gMenuTitle into oldShortFile
   
   switch
      case exists (stack gMenuTitle) is false
         return true
      case oldShortFile = goodShortFile
         return true
      default
         return false
   end switch
end disabled_FixShortFile


--> Global | Project | Controllers | Line | Menu
-
on menu_EditController dView
   -- loads stack into memory
   put _GetControllerPath (dView) into controllerPath
   edit the script of stack controllerPath
end menu_EditController

on menu_MenuTools dView
   put _GetStackName (dView) into gMenuTitle
   --
   display_MenuTool gMenuTitle
end menu_MenuTools

on menu_ReindexMenu dView
   put _MenuController (dView) into mController
   --
   menu_ReIndexController mController
   --
   put the project_Name of mController into projectName
   display_Project projectName
   --
   put the menu_GlobalTitle of mController into gMenuTitle
   put menu_ConstructFilter (gMenuTitle, 2) into sFilter
   display_EnvironmentMenus true, sFilter
end menu_ReindexMenu

on _
end _

on menu_FixControllerName dView
   put _MenuController (dView) into mController
   --
   ask_FixMenuControllerStackName mController
   put the result into newStackName
end menu_FixControllerName

on menu_FixShortFile dView   
   put _GetStackName (dView) into gMenuTitle
   put _GoodShortFile(dView) into goodShortFile
   put the project_Name of stack gMenuTitle into projectName
   --
   lcw_Answer "Fix controllers filename (change to '[[goodShortFile]]')?", dView, goodShortFile
   --
   _CloseSelectedScriptTab dView
   --
   project_ChangeStackShortFileName gMenuTitle, goodShortFile
   put the result into newStackPath
   put the name of stack newStackPath into mController
   menu_ReIndexController mController
   --
   display_Project projectName
end menu_FixShortFile

private on __
end __

on menu_MoveController dView, newProjectName
   put _GetStackName (dView) into gMenuTitle
   put _SelectedMenuController (dView) into mController
   --
   ask_MoveMenu mController, gMenuTitle, newProjectName, dView
end menu_MoveController

on menu_MoveToModule dView, toModuleName
   put _GetStackName (dView) into gMenuTitle
   put the project_Name of stack gMenuTitle into toProjectName
   --
   project_MoveControllerToModule gMenutitle, toModuleName, toProjectName
   get the result
   if item 1 of it = "Error"  then
      breakpoint
   else
      put the result into toPath
      display_Project toProjectName
   end if
end menu_MoveToModule

getprop moveToModule_Params [dView] 
   put _SelectedMenuController (dView) into mController
   put the module_Names of mController into moduleNames
   return moduleNames
end moveToModule_Params

on menu_DeleteController dView
   put _GetStackName (dView) into mStackName
   --
   _CloseSelectedScriptTab dView
   put the result into mController
   --
   if exists (stack mStackName) is false then
      put merge ("Stack '[[mStackName]]' does not exist!") into someQuestion
      lcw_AnswerWarning someQuestion, dView
   end if
   
   -- put the hilited_Line of dView into lineNum
   put the displayed_Index of dView into stackNames
   --
   put the fileName of stack mStackName into controllerFile
   put the project_Name of stack mStackName into projectName
   
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
   lcw_Answer "Are you sure you want to delete the controller '[[shortControllerFile]]'?", dView, shortControllerFile
   --
   delete stack mStackName
   --
   set the stackFile_RemovePaths of stack projectName to controllerFile -- need to do this before deleting file
   delete file controllerFile
   --
   display_ProjectControllers projectName
   display_Project projectName
end menu_DeleteController

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on _CloseScriptTab dView
   _CloseSelectedScriptTab dView
end _CloseScriptTab

on _RevealFolder dView
   put the title_Text of dView into projectName
   put library_FetchProjectFolder (projectName) into projectFolder
   put folder_AddShort (projectFolder, "controllers") into controllerFolder
   finder_Reveal controllerFolder
end _RevealFolder

on _
end _

on _DisplayMenuItems dView
   put _GetStackName (dView) into gMenuTitle
   --
   display_MenuHandlers gMenuTitle
end _DisplayMenuItems

on _TestController dView
   put _GetStackName (dView) into gMenuTitle
   --   
   put the menu_GlobalTitle of stack gMenuTitle into mTitles
   put the stack_Folder of stack gMenuTitle & CR & the project_Folder of stack stackName
   put line 1 of mTitles into mTitle
   put gMenuTitle & comma & "the menu_GlobalTitle of stack" into displayTitle
   display_Index mTitles, displayTitle, mTitle
end _TestController
