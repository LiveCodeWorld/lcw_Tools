script "Global_Project_Tree_Line_Menu"
--> MetaData
-
license: GPLv3
name: Global_Project_Tree_Line_Menu
type: controller
version: 0.2


--> Private
-
private command refreshDisplay projectName
   lock screen
   put LocalArray ["indexView"] into indexView   
   put project_ListUsedStackNames (projectName) into usedStackNames
   set the view_Index of indexView to usedStackNames
   set the title_Text of indexView to projectName
   unlock screen
end refreshDisplay


--> Global | Project | Tree | Line | Menu
-
on menu_MoveUsed indexView, newProjectName
   put the selected_Index of indexView into stackName
   put the name of stack stackName into stackObject
   
   put the project_Name of stackObject into oProjectName
   if oProjectName = newProjectName then
      answer warning merge ("Stack is already in project '[[newProjectName]]'. Choose a new project to move this library to!")
      exit to top
   end if
   
   project_MoveLibrary stackObject, newProjectName
   
   lcw_Notify merge ("Moved library to new project '[[newProjectName]]'!")
   
   breakpoint
   -- refreshDisplay newProjectName
   menu_Do "menu_DisplayActive", "Global | Project | Line | Menu", indexView, "libraries"
end menu_MoveUsed

on menu_ConvertToModule indexView, newProjectName
   put the selected_Index of indexView into moduleStackName
   if exists (stack moduleStackName) is false then
      breakpoint
      exit to top
   end if
   
   put the filename of stack moduleStackName into oStackPath
   -- put the module_Folder [newProjectName] of stack moduleStackName into moduleFolder
   put project_GetFolder (newProjectName) into projectFolder
   put project_ConstructFolder ("modules", projectFolder) into rootModuleFolder
   
   project_CreateModule moduleStackName, rootModuleFolder, oStackPath
end menu_ConvertToModule

on menu_StartProject indexView, someBoolean
   put the selected_Index of indexView into projectName
   if someBoolean is true then
      project_Start projectName
   else
      project_Stop projectName
   end if
end menu_StartProject

on _
end _

on menu_GitStatus indexView
   put the selected_Index of indexView into projectName
   put library_FetchProjectFolder (projectName) into projectFolder
   put git_GetCheckoutFolder (projectFolder) into gitCheckoutFolder
   
   display_GitFolderStatus gitCheckoutFolder
end menu_GitStatus

on menu_InitialiseGit indexView
   put the selected_Index of indexView into projectName
   put library_FetchProjectFolder (projectName) into projectFolder
   put git_GetCheckoutFolder (projectFolder) into gitCheckoutFolder
   
   git_InitFolder projectFolder
   
   display_GitFolderStatus gitCheckoutFolder
end menu_InitialiseGit

on menu_AddEverythingToGit indexView
   put the selected_Index of indexView into gitProjectName
   put library_FetchProjectFolder (gitProjectName) into projectFolder
   put git_GetCheckoutFolder (projectFolder) into gitCheckoutFolder
   
   breakpoint
   git_AddEverything gitCheckoutFolder
   put the result into shellResult
   
   display_GitFolderStatus gitCheckoutFolder
end menu_AddEverythingToGit

on _
end _

on menu_GoToHomeStack indexView
   put the selected_Index of indexView into projectName
   put library_FetchProjectHomeStackPath (projectName) into homeStackPath
   if exists (stack homeStackPath) is false then breakpoint
   
   go to stack homeStackPath
end menu_GoToHomeStack

on menu_EditStackScript indexView
   put the selected_Index of indexView into projectName
   put library_FetchProjectHomeStackPath (projectName) into homeStackPath
   if exists (stack homeStackPath) is false then breakpoint
   
   edit the script of stack homeStackPath
end menu_EditStackScript

on _
end _

on menu_RevealProjectFolder indexView
   put the selected_Index of indexView into projectName
   put project_GetFolder (projectName) into projectFolder
   finder_Reveal projectFolder
end menu_RevealProjectFolder

on menu_RemoveProjectFromLibrary indexView
   put the selected_Index of indexView into projectName
   answer warning merge ("Are you sure you want to remove the project '[[projectName]]' from the project library?") with "Cancel" or "OK"
   if it is "Cancel" then exit to top
   
   library_DeleteProjectArray projectName
   
   put library_ListProjectNames() into projectNames
   set the view_Index ["List of Projects"] of indexView to projectNames
end menu_RemoveProjectFromLibrary

on menu_DisplayProject indexView
   put the selected_Index of indexView into projectName
   display_Project projectName, true
   
   put library_ListProjectNames() into projectNames
   set the view_Index ["List of Projects"] of indexView to projectNames
end menu_DisplayProject

on _
end _

on menu_TrashProject indexView
   put the selected_Index of indexView into projectName
   answer warning merge ("Are you sure you want to close project '[[projectName]]' and move all files to the trash?") with "Cancel" or "OK"
   if it is "Cancel" then exit to top
   
   project_Trash projectName
end menu_TrashProject


--> Global | Project | Tree | Line | Menu | Props
-
getprop new_ProjectName [indexView]
   put the selected_Index of indexView into stackName
   put the project_Name of stack stackName into projectName
   return projectName
end new_ProjectName

getprop new_ProjectNames
   return library_ListProjectNames()
end new_ProjectNames

getprop start_Project [indexView]
   put the selected_Index of indexView into projectName
   return project_IsActive (projectName) is true
end start_Project


--> Global | Project | Tree | Line | Menu | Disabled
-
getprop disabled_ConvertToModule [indexView]
   put the title_Text of indexView into displayedTitle
   switch displayedTitle
      case "Active Views"
         return false
      default
         return "delete"
   end switch
end disabled_ConvertToModule

getprop disabled_MoveUsed [indexView]
   put the title_Text of indexView into displayedTitle
   switch displayedTitle
      case "Active Libraries"
         return false
      default
         return "delete"
   end switch
end disabled_MoveUsed

getprop disabled_GitStatus [indexView]
   put the selected_Index of indexView into projectName
   put library_FetchProjectFolder (projectName) into projectFolder
   put git_GetCheckoutFolder (projectFolder) into gitCheckoutFolder
   if there is a folder gitCheckoutFolder then
      return false
   else
      return "delete"
   end if
end disabled_GitStatus

getprop disabled_InitialiseGit [indexView]
   -- put the git_WithinCheckoutFolder of stack stackPath into someBoolean
   put the selected_Index of indexView into projectName
   put project_GetHomeStackPath (projectName) into stackPath
   put git_GetCheckoutFolder (stackPath) into gitCheckoutFolder
   if there is a folder gitCheckoutFolder then
      return "delete"
   else
      return false
   end if
end disabled_InitialiseGit

getprop disabled_StartProject [indexView]
   put the title_Text of indexView into listType
   if listType contains "Projects" then
      return false
   else
      return "delete"
   end if
end disabled_StartProject

