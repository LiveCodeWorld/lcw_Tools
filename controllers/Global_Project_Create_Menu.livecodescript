script "Global_Project_Create_Menu"
--> MetaData
-
license: GPLv3
name: Global_Project_Create_Menu
type: modules
version: 0.2


--. Menu | Props
-
getprop menu_CheckTarget [projectName]
   put library_FetchProjectFolder (projectName) into projectFolder
   if projectFolder is empty then
      return false
   else
      return true
   end if
end menu_CheckTarget


--> Global | Project | Create | Menu
-
on menu_TestProjectName homeStackName
   put homeStackName
end menu_TestProjectName

on _
end _

on menu_ExportAndIndexProject projectName
   put merge ("Do you want to export and index project '[[projectName]]'?") into someComment
   lcw_Answer someComment
   project_ExportAndIndex projectName, true
end menu_ExportAndIndexProject

on menu_CreateNewProject
   project_AskCreate
end menu_CreateNewProject

on _
end _

on menu_CreateModule homeStackName
   put "Choose a name for your new module...." into someQuestion
   put the clipboarddata ["text"] into suggestedAnswer
   set the itemdelimiter to "|"
   if item 1 of suggestedAnswer is not "View" then
      put "View|Test" into suggestedAnswer
   end if
   put lcw_Ask (someQuestion, suggestedAnswer) into moduleStackName
   
   put project_GetFolder (homeStackName) into projectFolder
   if projectFolder is empty then
      answer warning "Cannot locate project folder!"
      put projectFolder
      breakpoint
      exit to top
   end if
   put project_ConstructFolder ("modules", projectFolder) into rootModuleFolder
   
   project_CreateModule moduleStackName, rootModuleFolder
end menu_CreateModule

on menu_CreateProjectMenu projectName
   put _askMenuTitle (projectName) into controllerStackName
   project_CreateMenu controllerStackName, projectName
   put the result into controllerStackObject
   edit the script of controllerStackObject
end menu_CreateProjectMenu

on menu_CreateProjectLibrary projectName
   put "Choose a name for your script-only library stack...." into someQuestion
   set the itemdelimiter to "_"
   put "lib_" &  item -1 of projectName into suggestedAnswer 
   put lcw_Ask (someQuestion, suggestedAnswer) into stackName
   
   put project_GetFolder (projectName) into projectFolder
   project_CreateStack projectFolder, stackName, "libraries", "library"
   put the result into homeStackPath
   
   start using stack stackName
   lcw_Notify ("Stack" && kwote (stackName) && "is now known and used!")
   edit the script of stack stackName
   finder_Reveal projectFolder
end menu_CreateProjectLibrary

on menu_CreateView projectName
   breakpoint
   template_ConstructStackFromObject scriptObject
end menu_CreateView

on menu_CreateModel projectName
   put "Choose a name for your script only model stack...." into someQuestion
   put "model_XXX" into suggestedAnswer
   breakpoint
   project_CreateScriptOnlyStack "models", someQuestion, suggestedAnswer, projectName
end menu_CreateModel

on menu_CreateBehavior projectName
   put "Choose a name for your script-only behavior stack...." into someQuestion
   put "behavior_XXX" into suggestedAnswer
   breakpoint
   project_CreateScriptOnlyStack "behaviors", someQuestion, suggestedAnswer, projectName
end menu_CreateBehavior


--> Global | Project | Create | Menu | Props
-
--> Global | Project | Create | Menu | Disabled
-

--> Private
-
private function _askMenuTitle projectName
   put line 1 of the clipboarddata ["text"] into maybeMenuTitle
   if word -1 of maybeMenuTitle = "Menu" then
      put maybeMenuTitle into suggestedAnswer
   else
      set the itemdelimiter to "_"
      put "Global |" && item -1 of projectName && "| Menu" into suggestedAnswer
   end if
   
   put "What is the name of your global menu...." into someQuestion
   put lcw_Ask (someQuestion, suggestedAnswer) into gMenuTitle
   put module_FolderNameFromTitle (gMenuTitle) into moduleStackName
   return moduleStackName
end _askMenuTitle
