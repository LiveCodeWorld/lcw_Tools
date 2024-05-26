script "lib_DisplayControllers"
--> MetaData
-
license: GPLv3
name: lib_DisplayControllers
type: library
version: 0.2


--> Ask | Module
-
command ask_CreateModuleMenu moduleStackName, pDisplayView, pGlobalMenuTitle, pControllerScript
   if pGlobalMenuTitle is empty then
      put module_ConstructGlobalMenuTitle (moduleStackName) into pGlobalMenuTitle
   end if
   
   # Ask
   put "What is the name of your new Modules menu?" into someQuestion
   put lcw_Ask (someQuestion, pGlobalMenuTitle) into pGlobalMenuTitle
   if menu_Exists (pGlobalMenuTitle) then
      lcw_AnswerWarning "Menu [[pGlobalMenuTitle]] already exists!", pDisplayView, pGlobalMenuTitle
   end if
   --
   module_CreateMenu moduleStackName, pGlobalMenuTitle, pControllerScript
   put the result into mController
   --
   display_ModuleTools moduleStackName
   --
   return mController
end ask_CreateModuleMenu


--> Working on
-
private function _AskMenuTitle projectName, pGlobalMenuTitle, pDisplayView
   # Use clipboard if empty
   if pGlobalMenuTitle is empty then
      put line 1 of the clipboarddata ["text"] into maybeMenuTitle
   else
      put pGlobalMenuTitle into maybeMenuTitle
   end if
   
   # Guess gMenuTitle
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
   
   # Ask
   put "Give the menu for project '[[var]]' a name...." into someQuestion
   put lcw_Ask (someQuestion, suggestedAnswer, pDisplayView, projectName) into gMenuTitle
   --
   if menu_Exists (gMenuTitle) then
      lcw_AnswerWarning "Menu [[gMenuTitle]] already exists!", pDisplayView, gMenuTitle
   end if
   --
   return gMenuTitle
end _AskMenuTitle

command ask_CreateProjectMenu projectName, pGlobalMenuTitle, pDontAsk, pControllerScript
   # Check we can find a project foldeer
   put project_GetFolder (projectName) into projectFolder
   if there is not a folder projectFolder then lcw_AnswerWarning "Project folder does not exists!"
   
   # Ask about gMenuTitle
   if pDontAsk is not true then
      put _AskMenuTitle (projectName, pGlobalMenuTitle) into pGlobalMenuTitle
   end if
   
   # Create and index
   project_CreateMenuFromFolder projectFolder, pGlobalMenuTitle, pControllerScript
   put the result into mController
   
   # Update Project controllers or project display if needed
   display_ProjectControllers projectName, true
   display_Project projectName, true
   --
   return mController
end ask_CreateProjectMenu

command ask_CreateMenuFromObject gMenuTitle, libName, pControllerScript, pDisplay
   -- as this handler is called for most display creation code 
   -- we are careful and do a lot of checks before creating
   -- but we need to be fast in rejecting searches where we know that we dont need to create a menu as it already exists
   
   # Return mController (fast)
   if there is a stack gMenuTitle then return merge ("Error, not creating menu as stack '[[gMenuTitle]]' already exits!")
   put menu_GetGlobalController (gMenuTitle) into mController -- usually a stackObject
   if exists (mController) then return merge ("Error, not creating menu as '[[mController]]' already exits!")
   
   # Project name from library name
   if exists (stack libName) is false then
      -- put debug_CallingObject (1) into libObject
      -- put the project_Name of libObject into projectName
      put "lcw_Tools" into projectName
   else
      put the project_Name of stack libName into projectName
   end if
   
   # Check path in case file not loaded
   put the project_Folder of stack projectName into projectFolder
   if there is not a folder projectFolder then return "Error, no project_Folder:" && projectFolder
   put project_ConstructStandardFile (gMenuTitle, projectFolder, "controllers") into controllerPath
   --
   if there is a file controllerPath then
      put the short name of stack controllerPath into stackName
      if stackName = gMenuTitle then
         return empty
      end if
   end if
   
   # Ask Create
   ask_CreateProjectMenu projectName, gMenuTitle, pControllerScript, pDisplay
   put the result into mController
   
   # Edit the script
   if pDisplay is true then
      edit the script of mController
   end if
   
   return mController
end ask_CreateMenuFromObject

command ask_MoveMenu mController, gMenuTitle, newProjectName, pDisplayView 
   scriptEditor_CloseTab mController
   
   # Checks
   put the project_Name of mController into oldProjectName
   if oldProjectName is empty then
      put merge ("Stack '[[gMenuTitle]]' does not have a project name. Please correct the metadata first!") into someQuestion
      lcw_AnswerWarning someQuestion, pDisplayView
   end if
   if oldProjectName = newProjectName then
      put merge ("Stack is already in project '[[newProjectName]]'. Choose a new project to move this library to!") into someQuestion
      lcw_AnswerWarning someQuestion, pDisplayView
   end if
   
   # Ask
   put merge ("Do you want to move the controller [[mController]] to the new project '[[newProjectName]]'?") into someQuestion
   text_PrettyQuote someQuestion
   lcw_Answer someQuestion, pDisplayView 
   
   # Move
   -- as it is a controller it moves the stack to the controller folder in the new project folder
   project_MoveStackRelative gMenuTitle, newProjectName
   
   # Update displays
   display_Project newProjectName
   display_Project oldProjectName
   put menu_ConstructFilter (gMenuTitle, 2) into sFilter
   display_EnvironmentMenus true, sFilter
end ask_MoveMenu

command ask_FixMenuControllerStackName mController, pEditScript
   # Make sure the metadata is correct
   put the stack_Name of mController into mControllerStackName
   put the menu_Name of stack mControllerStackName into mName
   if mName is empty then
      put merge ("The menu controller '[[mControllerStackName]]' has faulty metadata! Please check the script.") into someQuestion
      lcw_AnswerWarning someQuestion
   end if
   
   # Get the first gMenuTitle
   put the script_GlobalMenuTitles of stack mControllerStackName into mTitles
   put line 1 of mTitles into gMenuTitle
   
   # Ask
   put merge ("Rename the controller for stack '[[mControllerStackName]]'...") into someQuestion
   put lcw_Ask (someQuestion, gMenuTitle) into newStackName
   --
   if there is a stack newStackName then
      put merge ("The is already a stack '[[newStackName]]'. Please choose another name!") into someQuestion
      lcw_AnswerWarning someQuestion
   end if
   
   # Close script editor tab
   scriptEditor_CloseTab mController
   if pEditScript is empty then put the result into pEditScript
   
   # Remove old menu model
   menu_RemoveGlobalController gMenuTitle
   
   # Set script metadata and fix first global menu title
   _FixMenuScript mControllerStackName, newStackName
   
   # Rename stack
   set lockmessages to true
   set the name of stack mControllerStackName to newStackName
   
   # Fix short file
   put project_NameToShortFolder (newStackName) & ".livecodescript" into goodShortFile
   project_ChangeStackShortFileName newStackName, goodShortFile
   put the result into newStackPath -- not renamed if short file is the same
   
   # Save and unlock
   save stack newStackName
   set lockmessages to false
   
   # Update global menu dictionary
   put the name of stack newStackName into newMenuController
   menu_ReIndexController newMenuController
   
   # Refresh displays if open
   put the project_Name of newMenuController into projectName
   if display_FindView ("Project", projectName, "Display Array") is not empty then
      display_Project projectName
   end if
   if display_FindView ("Global menus", "", "Display Array") is not empty then
      display_EnvironmentMenus
   end if
   
   # Re-edit script if needed
   if pEditScript is true then
      edit the script of stack newStackName
   end if
   return newStackName
end ask_FixMenuControllerStackName


--> Menu | Create
-
function menu_Create gMenuTitle, pProjectName
   # Return gMenuTitle if exists
   put menu_GetGlobalController (gMenuTitle) into mController
   if exists (mController) then return gMenuTitle
   
   # Get a default pProjectName
   if pProjectName is empty then
      put debug_CallingObject() into cObject
      put the project_Name of cObject into pProjectName
      if pProjectName is empty then
         put "lcw_Tools" into pProjectName
      end if
   end if
   
   # Otherwise create menu 
   ask_CreateProjectMenu pProjectName, gMenuTitle
   put the result into mController
   return mController
end menu_Create


--> Display | Menu
-
command display_MenuTool gMenuTitle, pDisplayArray
   if pDisplayArray is true then
      put the menu_Array of stack gMenuTitle into handerNames
   else
      put the menu_Handlers of stack gMenuTitle into handerNames
   end if
   --
   display_Tools handerNames, gMenuTitle, "Display | Menu | Help", "Help"
   return the result
end display_MenuTool

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
command display_ProjectControllers projectName, pRefreshOnly
   if display_ViewExists ("Project", projectName) then
      display_Project projectName, pRefreshOnly
      put the result & CR after displayViews
   end if
   put project_ListMenus (projectName) into gMenuTitles
   
   # If refreshing return
   if pRefreshOnly is true AND display_FindIndexView ("Project Controllers", projectName) is empty then
      delete char -1 of displayViews
      return displayViews
   end if
   
   # Display Controllers
   display_Data gMenuTitles, projectName, "Project Controllers"
   put the result into displayView
   set the tool_MenuBit of displayView to "Controllers | Tree" 
   --
   put displayView & CR after displayViews
   delete char -1 of displayViews
   return displayViews
end display_ProjectControllers

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


--> Display | mDoubleUp
-
on mDoubleUp_DisplayMenuHelp displayView, hName
   breakpoint
   put hName
end mDoubleUp_DisplayMenuHelp DisplayHelp

command mDoubleUp_CheckRigControllers
   displayView, shortFile
   put the folder_Path of displayView into folderPath
   put server_GetURL() into serverURL
   put server_GetSshUser() into sshUser
   put server_GetSshKeyPath() into sshKeyPath
   --
   put shortFile
end mDoubleUp_CheckRigControllers

command mDoubleUp_EditHkey displayView, hName
   -- put the title_Text of displayView into gMenuTitle
   put _GetStackName (displayView) into gMenuTitle
   --
   put menu_GetGlobalController (gMenuTitle) into mController
   put hkey_Construct (hName, "M", mController) into hKey
   hkey_Edit hKey
end mDoubleUp_EditHkey

on mDouble_ControllersTree displayView, someLine
   put the title_Text of displayView into projectName
   put the selected_Line of displayView into gMenuTitle
   --
   edit the script of stack gMenuTitle
end mDouble_ControllersTree


--> Private
-
private command _FixMenuScript oldMenuStackName, newGlobalMenuTitle
   -- set the menu_Name of mController to newGlobalMenuTitle
   put the name of stack oldMenuStackName into mController
   put the script of mController into someScript
   
   # Fix metadata
   put script_GetMetadataArray (someScript) into sMetaData
   put newGlobalMenuTitle into sMetaData ["name"]
   put "controller" into sMetaData ["type"]
   script_SetMetadataArray someScript, sMetaData
   
   # Fix menu suite title (assume it si the first global menu title)
   put script_GetGlobalMenuTitles (someScript) into gMenuTitles
   put line 1 of gMenuTitles into oldGlobalMenuTitle
   script_RenameSuite someScript, oldGlobalMenuTitle, newGlobalMenuTitle
   --
   set the script of mController to someScript
end _FixMenuScript
