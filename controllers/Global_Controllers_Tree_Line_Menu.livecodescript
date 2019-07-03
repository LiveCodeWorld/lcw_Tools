script "Global_Controllers_Tree_Line_Menu"
--> MetaData
-
license: GPLv3
name: Global_Controllers_Tree_Line_Menu
type: controller
version: 0.2


--> Menu | Props
-
local LocalArray

on menu_Init tObject
   put the index_View of tObject into LocalArray ["indexView"]
end menu_Init

command mDoubleUp_EditHkey indexView, hName
   put the title_Text of indexView into gMenuTitle
   put menu_GetGlobalController (gMenuTitle) into mController
   put hkey_Construct (hName, "M", mController) into hKey
   hkey_Edit hKey
end mDoubleUp_EditHkey


--> Global | Controllers | Tree | Line | Menu
-
on menu_DisplayMenuItems projectName
   _SetInfo mController, gMenuTitle, tObject, indexView, stackName
   --
   display_MenuHandlers gMenuTitle
end menu_DisplayMenuItems

on _
end _

on menu_EditController projectName
   put LocalArray ["indexView"] into indexView
   put the selected_Index of indexView into stackName
   put the name of stack stackName into stackObject
   --
   edit the script of stackObject
end menu_EditController

on menu_MoveController projectName, newProjectName
   put LocalArray ["indexView"] into indexView
   put the selected_Index of indexView into stackName
   put the name of stack stackName into stackObject
   
   put the project_Name of stackObject into oldProjectName
   if oldProjectName = newProjectName then
      get merge ("Stack is already in project '[[newProjectName]]'. Choose a new project to move this library to!")
      lcw_WarnAndExit it
   end if
   
   get merge ("Do you want to move the controller '[[stackName]]' to the new project '[[newProjectName]]'?")
   text_PrettyQuote it
   dispatch "lcw_AnswerSheet" to indexView with it
   
   -- moves the stack realtively
   -- as it is a controller it moves the stack to the controller folder in the new project folder
   project_MoveStackRelative stackName, newProjectName
   
   display_ProjectControllers newProjectName
   display_ProjectControllers oldProjectName
end menu_MoveController

on _
end _

on menu_DeleteController projectName
   put LocalArray ["indexView"] into indexView
   put the selected_Index of indexView into stackName
   if exists (stack stackName) is false then
      put merge ("Stack '[[stackName]]' does not exist!") into q
      dispatch "lcw_WarnAndExit" to indexView with q
   end if
   
   put the hilited_Lines of indexView into lineNum
   put the displayed_Index of indexView into stackNames
   put the fileName of stack stackName into controllerFile
   
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
   put merge ("Are you sure you want to delete the controler '[[shortControllerFile]]'?") into q
   dispatch "lcw_AnswerWarning" to indexView with q
   --
   delete stack stackName
   --
   set the stackFile_RemovePaths of stack projectName to controllerFile -- need to do this before deleting file
   delete file controllerFile
   --
   display_ProjectControllers projectName
end menu_DeleteController

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_RevealFolder projectName
   put LocalArray ["indexView"] into indexView
   put the title_Text of indexView into projectName
   put library_FetchProjectFolder (projectName) into projectFolder
   put project_ConstructFolder ("controllers", projectFolder) into controllerFolder
   finder_Reveal controllerFolder
end menu_RevealFolder

on menu_TestMenu projectName
   put LocalArray ["indexView"] into indexView
   put the selected_Index of indexView into stackName
   -- put the menu_Titles of stack stackName
   put the menu_GlobalTitle of stack stackName into mTitles
   
   put line 1 of mTitles into mTitle
   put stackName & comma & "the menu_GlobalTitle of stack" into displayTitle
   display_Index mTitles, displayTitle, mTitle
end menu_TestMenu

on menu_StackProperties projectName
   put LocalArray ["indexView"] into indexView
   put the selected_Index of indexView into stackName
   put the name of stack stackName into stackObject
   
   revIDEInspectObjects stackObject
end menu_StackProperties


--> Menu | Props
-
getprop moveController_Param [projectName]
   put the index_View of the target into indexView
   --
   put the selected_Index of indexView into stackName
   put the project_Name of stack stackName into projectName
   return projectName
end moveController_Param

getprop moveController_Params [projectName]
   return library_ListProjectNames()
end moveController_Params


--> Menu | Props | Old
-
getprop new_ProjectName [projectName]
   put LocalArray ["indexView"] into indexView
   put the selected_Index of indexView into stackName
   put the project_Name of stack stackName into projectName
   return projectName
end new_ProjectName

getprop new_ProjectNames
   return library_ListProjectNames()
end new_ProjectNames


--> Private
-
private command _SetInfo @mController, @gMenuTitle, @tObject, @indexView, @stackName
   put the long id of the target into tObject
   put the index_View of tObject into indexView
   put the selected_Index of indexView into stackName
   put the name of stack stackName into mController
   --
   put stackName into gMenuTitle
   mTitle_Normalize gMenuTitle
end _SetInfo
