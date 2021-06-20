script "lib_DisplayControllers"
--> MetaData
-
license: GPLv3
name: lib_DisplayControllers
type: library
version: 0.2


--> Working on
-
on mDouble_EditMenuController displayView, someLine
   put the title_Text of displayView into projectName
   put the selected_Line of displayView into gMenuTitle
   --
   edit the script of stack gMenuTitle
end mDouble_EditMenuController

command display_ProjectControllers projectName
   put project_ListMenus (projectName) into gMenuTitles
   --
   display_Data gMenuTitles, projectName, "Project Controllers"
   put the result into displayView
   display_SetInteractions displayView, "Controllers | Tree", "mDouble_EditMenuController" 
   --
   return displayView
end display_ProjectControllers

command controller_AskFixMenuName mController
   put the stack_Name of mController into mControllerStackName
   
   -- this can be tricky as it renames live stacks
   put the menu_Name of stack mControllerStackName into mName
   if mName is empty then
      put merge ("The menu controller '[[mControllerStackName]]' has faulty metadata! Please check the script.") into someQuestion
      lcw_AnswerWarning someQuestion
   end if
   
   -- first let's close any tab that is editing the mController script
   scriptEditor_CloseTab mController
   put the result into didClose
   
   -- get the first gMenuTitle
   put the script_GlobalMenuTitles of stack mControllerStackName into mTitles
   put line 1 of mTitles into gMenuTitle
   --
   put merge ("Rename the controller for stack '[[mControllerStackName]]'...") into someQuestion
   put lcw_Ask (someQuestion, gMenuTitle) into newStackName
   --
   if there is a stack newStackName then
      put merge ("The is already a stack '[[newStackName]]'. Please choose another name!") into someQuestion
      lcw_AnswerWarning someQuestion
   end if
   --
   set the menu_Name of stack mControllerStackName to newStackName
   put the result into scriptMetaData
   if scriptMetaData is not an array then
      put merge ("The menu controller '[[mControllerStackName]]' has faulty metadata! Please check the script.") into someQuestion
      lcw_AnswerWarning someQuestion
   end if
   
   -- now we've succesfully set the scripts metadata
   -- we can rename the stack and save
   set lockmessages to true
   set the name of stack mControllerStackName to newStackName
   save stack newStackName -- safe in testing
   set lockmessages to false
   --
   if didClose is true then
      edit the script of stack newStackName
   end if
   return newStackName
end controller_AskFixMenuName

command project_CreateMenu moduleOrProjectFolder, controllerStackName, pControllerScript
   project_CreateStack moduleOrProjectFolder, controllerStackName, "controllers", "controller", pControllerScript, false
   put the result into controllerStackPath
   --
   set the menu_Update of stack controllerStackPath to true
   put the name of stack controllerStackPath into controllerStackObject
   --
   return controllerStackObject
end project_CreateMenu

command display_AskCreateMenu projectName, pGlobalMenuTitle, pControllerScript
   -- renamed was "project_CreateMenuX"
   
   put project_GetFolder (projectName) into projectFolder
   if there is not a folder projectFolder then
      put projectFolder
      lcw_AnswerWarning "Project folder does not exists!"
   end if
   
   put _askMenuTitle (projectName, pGlobalMenuTitle) into gMenuTitle
   
   if pControllerScript is empty then
      put controller_ConstructMenuScript (gMenuTitle) into pControllerScript
   end if
   
   put controller_FolderNameFromTitle (gMenuTitle) into controllerStackName
   --
   project_CreateMenu projectFolder, controllerStackName, pControllerScript
   put the result into controllerStackObject
   --
   put display_FindView ("Project Controllers", projectName) into displayView
   if exists (displayView) then
      display_ProjectControllers projectName
   end if
   return controllerStackObject
end display_AskCreateMenu

private function _askMenuTitle projectName, pGlobalMenuTitle
   if pGlobalMenuTitle is empty then
      put line 1 of the clipboarddata ["text"] into maybeMenuTitle
   else
      put pGlobalMenuTitle into maybeMenuTitle
   end if
   
   switch
      case word 1 of maybeMenuTitle = "-->"
         put word 2 to -1 of maybeMenuTitle into suggestedAnswer
         break
      case word -1 of maybeMenuTitle = "Menu"
         put maybeMenuTitle into suggestedAnswer
         break
      default
         set the itemdelimiter to "_"
         put "Global |" && item -1 of projectName && "| Menu" into suggestedAnswer
   end switch
   
   put "What is the name of your global menu...." into someQuestion
   put lcw_Ask (someQuestion, suggestedAnswer) into gMenuTitle
   
   return gMenuTitle
end _askMenuTitle


--> Display | Events
-
command rigController_DownloadAndEdit indexView, shortFile   
   rig_EditController shortFile
end rigController_DownloadAndEdit

command mDoubleUp_CheckRigControllers
   displayView, shortFile
   put the folder_Path of displayView into folderPath
   put server_GetURL() into serverURL
   put server_GetSshUser() into sshUser
   put server_GetSshKeyPath() into sshKeyPath
   --
   put shortFile
end mDoubleUp_CheckRigControllers


--> Display | Menu
-
command display_MenuHandlers gMenuTitle
   put menu_GetGlobalController (gMenuTitle) into mController
   if exists (mController) is false then
      put merge ("Cannot locate global menu 'gMenuTitle'!") into someQuestion
      put gMenuTitle
      lcw_AnswerWarning someQuestion
   end if
   
   put the menu_Array [gMenuTitle] of mController into mArray
   put mArray_ListHandlerNames (mArray, true) into hNames
   --
   display_Lines hNames, gMenuTitle, "mDoubleUp_EditHkey", "Menu Handlers", true
   put the result into indexView
   set the field_Style of indexView to "click"
   --
   set the drop_Command of indexView to "menuItem_Drag"
   --
   return indexView
end display_MenuHandlers


--> Display | Project | Controllers
-
command display_Controllers pIndexView
   put env_ListControllerStackNames() into activeControllerStackNames
   --
   put empty into mUp
   put "mDouble_DisplayStack" into mDoubleClick
   put "Active Controllers,Environment" into stackTitle
   --
   put "Global | Environment | Menu" into mTitle
   put "Global | Project | Tree | Line | Menu" into mLineTitle
   --
   if exists (pIndexView) is false then
      display_Index activeControllerStackNames, stackTitle, mTitle, mLineTitle, mUp, mDoubleClick
      put the result into pIndexView
   else
      lock screen
      set the view_Index of pIndexView to activeControllerStackNames
      set the stack_Title of pIndexView to stackTitle
      unlock screen
   end if
   --
   set the mouse_DoubleUp of pIndexView to mDoubleClick
   set the title_Menu of pIndexView to mTitle
   set the line_Menu of pIndexView to mLineTitle
   set the field_Style of pIndexView to "click"
   --
   return pIndexView
end display_Controllers
