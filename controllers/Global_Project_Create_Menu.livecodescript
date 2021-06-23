script "Global_Project_Create_Menu"
--> MetaData
-
license: GPLv3
name: Global_Project_Create_Menu
type: controller
version: 0.2

/*
This controller is sometimes called by the Script Editor,
and sometimes by a (project) displayView.
*/


--. Menu | Init
-
local LocalArray

getprop menu_Target [tObject]
   put display_GetObject (tObject) into sObject
   if sObject is empty then
      -- should make more robust with a specific property?
      put the title_Text of tObject into projectName
   else
      put sObject into LocalArray ["ScriptEditorObject"]
      put the project_Name of sObject into projectName
      return projectName
   end if
end menu_Target

getprop disabled_CreateMenu [projectName]
   if LocalArray ["ScriptEditorObject"] is empty then
      return "delete"
   else
      return false
   end if
end disabled_CreateMenu

getprop disabled_CreateProjectMenu [projectName]
   if LocalArray ["ScriptEditorObject"] is empty then
      return false
   else
      return "delete"
   end if
end disabled_CreateProjectMenu


--> Global | Project | Create | Menu
-
on menu_CreateMenu projectName
   put scriptEditor_GetSelectedText() into gMenuTitle
   --
   display_AskCreateMenu projectName, gMenuTitle
   put the result into controllerStackObject
   edit the script of controllerStackObject
end menu_CreateMenu

on menu_CreateProjectMenu projectName
   display_AskCreateMenu projectName
   put the result into controllerStackObject
   edit the script of controllerStackObject
end menu_CreateProjectMenu

on _
end _

on menu_CreateModule projectName
   put lcw_Ask ("What name would you like for this module?", "View|Something") into moduleName
   module_CreateWithObject moduleName, projectName
end menu_CreateModule

on menu_CreateProjectLibrary projectName
   display_AskCreateProjectLibrary projectName
end menu_CreateProjectLibrary

on menu_CreateProjectModel projectName
   put "Choose a name for your script only model stack...." into someQuestion
   put "model_XXX" into suggestedAnswer
   project_CreateScriptOnlyStack "models", someQuestion, suggestedAnswer, projectName
end menu_CreateProjectModel

on _
end _

on menu_CreateNewProject
   project_AskCreate
end menu_CreateNewProject

on menu_ExportMenusAndStackFiles projectName
   put project_GetFolder (projectName) into projectFolder
   project_ExportMenusAndStackFiles projectFolder
   --
   display_ProjectLibs projectName
   display_GitRefreshProjectName projectName
end menu_ExportMenusAndStackFiles

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_CreateProjectBehavior projectName
   put "Choose a name for your script-only behavior stack...." into someQuestion
   put "behavior_XXX" into suggestedAnswer
   project_CreateScriptOnlyStack "behaviors", someQuestion, suggestedAnswer, projectName
end menu_CreateProjectBehavior

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

on _
end _

on menu_CreateRecentMenu projectName
   put lcw_Ask ("What short name do you want for the Recent menu?", projectName) into shortName
   put ide_ConstructMenuTitle ("Recent", shortName) into gMenuTitle
   
   display_AskCreateMenu projectName, gMenuTitle
   put the result into controllerStackObject
   --
   edit the script of controllerStackObject
end menu_CreateRecentMenu

on menu_CreateHandlerMenu projectName
   put lcw_Ask ("What short name do you want for the Handler menu?", projectName) into shortName
   put ide_ConstructMenuTitle ("List", shortName) into gMenuTitle
   
   display_AskCreateMenu projectName, gMenuTitle
   put the result into controllerStackObject
   edit the script of controllerStackObject
end menu_CreateHandlerMenu
