script "lib_DisplayControllers"
--> MetaData
-
license: GPLv3
name: lib_DisplayControllers
type: library
version: 0.2


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
   put the menu_Array [gMenuTitle] of mController into mArray
   put mArray_ListHandlerNames (mArray, true) into hNames
   --
   display_Lines hNames, gMenuTitle, "mDoubleUp_EditHkey", "Menu Handlers", true
   put the result into indexView
   set the field_Style of indexView to "click"
   --
   -- set the menu_Target of indexView to projectName
   set the drag_Command of indexView to "menuItem_Drag"
   --
   return indexView
end display_MenuHandlers


--> Display | Rig | Server | Controllers
-
command display_RigControllers
   put "rest.livecode.world" into serverURL
   put "revIgniter Controllers" into stackLabel
   --
   put rig_ListControllerFiles() into shortFiles
   --
   put display_FindView (stackLabel, serverURL) into displayView
   if exists (displayView) then
      set the displayed_Lines of displayView to shortFiles
   else
      put serverURL & comma & stackLabel into displayTitle
      display_Lines shortFiles, serverURL, "rigController_DownloadAndEdit", stackLabel, true
      put the result into displayView
      set the title_Menu of displayView to "Global | Revigniter | Display | Controller | Menu"
      set the line_Menu of displayView to "Global | Revigniter | Display | Controller | Line | Menu"
   end if
   return displayView
end display_RigControllers

command display_RigControllerArray
   put "rest.livecode.world" into serverURL
   put "revIgniter Controller Array" into stackLabel
   --
   put rig_FetchControllerPathArray() into controllerPathArray
   --
   put display_FindView (stackLabel, serverURL) into displayView
   if exists (displayView) then
      set the displayed_Data of displayView to controllerPathArray
   else
      put "Global | Revigniter | Display | Controller | Menu" into treeMenuTitle
      put "Global | Revigniter | Display | Controller | Line | Menu" into lineMenuTitle
      --
      put serverURL & comma & stackLabel into displayTitle
      display_Array controllerPathArray, displayTitle, treeMenuTitle, lineMenuTitle
      put the result into displayView
   end if
   return displayView
end display_RigControllerArray


--> Display | Rig | Controller | Handlers
-
command display_ControllerHandlers controllerScript, pControllerShortFile, serverTLD
   server_SetURL "rest.livecode.world"
   --
   put rig_ListControllerFiles() into shortStackFiles
   display_Lines shortStackFiles, "Rig Controllers", "mDoubleUp_CheckRigControllers"
   put the result into displayView
   set the title_Menu of displayView to "Global | Revigniter | Display | Controller | Menu"
   set the line_Menu of displayView to "Global | Revigniter | Display | Controller | Line | Menu"
   --
   put rig_GetFolder ("controllers") into folderPath
   set the folder_Path of displayView to folderPath
end display_ControllerHandlers


--> Display | Project | Controllers
-
command display_ProjectControllers projectName
   put project_ListMenus (projectName) into stackNames
   --
   put "Project Controllers" into stackLabel 
   put display_FindView (stackLabel, projectName) into indexView
   
   if exists (indexView) is false then
      put empty into mUp
      put "mDouble_DisplayStack" into mDoubleUp
      put merge ("[[projectName]],[[stackLabel]]") into someTitle
      put "Global | Controllers | Tree | Menu" into mTitle
      put "Global | Controllers | Tree | Line | Menu" into mLineTitle
      put empty into pDragCommand
      
      display_Index stackNames, someTitle, mTitle, mLineTitle, mUp, mDoubleUp, pDragCommand, true
      put the result into indexView
      --
      set the menu_Target of indexView to projectName
      set the drag_Command of indexView to "menu_Drag"
      set the field_Style of indexView to "click"
      -- put the event_Target of indexView
   else
      set the displayed_Index of indexView to stackNames
   end if
   return indexView
end display_ProjectControllers

command display_Controllers pIndexView
   put env_ListControllerStackNames() into activeControllerStackNames
   --
   put empty into mUp
   put "mDouble_DisplayStack" into mDoubleUp
   put "Active Controllers,Environment" into stackTitle
   --
   put "Global | Environment | Menu" into mTitle
   put "Global | Project | Tree | Line | Menu" into mLineTitle
   --
   if exists (pIndexView) is false then
      display_Index activeControllerStackNames, stackTitle, mTitle, mLineTitle, mUp, mDoubleUp
      put the result into pIndexView
   else
      lock screen
      set the view_Index of pIndexView to activeControllerStackNames
      set the stack_Title of pIndexView to stackTitle
      unlock screen
   end if
   --
   set the mouse_DoubleUpEvent of pIndexView to mDoubleUp
   set the title_Menu of pIndexView to mTitle
   set the line_Menu of pIndexView to mLineTitle
   set the drag_Command of indexView to "test_Drag"
   set the field_Style of indexView to "click"
   return pIndexView
end display_Controllers
