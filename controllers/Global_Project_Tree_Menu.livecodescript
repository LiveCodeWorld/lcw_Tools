script "Global_Project_Tree_Menu"
--> MetaData
-
license: GPLv3
name: Global_Project_Tree_Menu
type: controllers
version: 0.2


--> Menu | Props
-
getprop menu_Target
   put menu_GetTargetObject() into tObject
   put the title_Text of tObject into projectName
   return projectName
end menu_Target

command _SetIndex stackNames, stackLabel
   lock screen
   put menu_GetTargetObject() into tObject
   put the index_View of tObject into indexView
   
   set the view_Index of indexView to stackNames
   put the stack_Object of indexView into stackObject
   set the label of stackObject to stackLabel
   unlock screen
end _SetIndex


--> Global | Project | Tree | Menu
-
on menu_DisplayViews projectName
   display_ProjectViews projectName
   return empty
end menu_DisplayViews

on menu_DisplayModules projectName
   display_ProjectViews projectName
   return empty
end menu_DisplayModules

on menu_DisplayControllers projectName
   put library_FetchProjectFolder (projectName) into projectFolder
   put project_ListStackPaths ("controllers", projectFolder) into controllerPaths
   put stack_PathsToNames (controllerPaths) into stackNames
   
   put merge ("[[projectName]],Controllers") into someTitle
   display_Index stackNames, someTitle,"Global | View | Tree | Menu"
end menu_DisplayControllers

on _
end _

on menu_CreateView projectName
   -- template_ConstructCloneStack
   template_ConstructStackFromObject scriptObject
end menu_CreateView

on menu_CreateMenuStack projectName
   put "Choose a name for your script only menu stack...." into pQuestion
   put the clipboarddata ["text"] into maybeMenuTitle
   if word -1 of maybeMenuTitle = "Menu" then
      replace " | " with "_" in maybeMenuTitle
      put maybeMenuTitle into suggestedAnswer
   else
      put "Global_Example_Menu" into suggestedAnswer
   end if
   project_CreateScriptOnlyStack "controllers", pQuestion, suggestedAnswer, projectName
end menu_CreateMenuStack

on menu_CreateModel projectName
   put "Choose a name for your script only model stack...." into someQuestion
   put the script_MetaData ["name"] of scriptObject into scriptName
   if scriptName is empty then put "Example" into scriptName
   put "model_" & scriptName into suggestedAnswer
   
   project_CreateScriptOnlyStack "models", someQuestion, suggestedAnswer, projectName
end menu_CreateModel

on menu_CreateBehavior projectName
   put "Choose a name for your script-only behavior stack...." into someQuestion
   put the script_MetaData ["name"] of scriptObject into scriptName
   if scriptName is empty then put "Example" into scriptName
   put "behavior_" & scriptName into suggestedAnswer
   
   project_CreateScriptOnlyStack "behaviors", someQuestion, suggestedAnswer, projectName
end menu_CreateBehavior

on menu_CreateLibrary projectName
   put "Choose a name for your script-only library stack...." into someQuestion
   put the script_MetaData ["name"] of scriptObject into scriptName
   if scriptName is empty then put "Example" into scriptName
   if char 1 to 4 of scriptName is not "lib_" then
      put "lib_" & scriptName into suggestedAnswer
   else
      put scriptName into suggestedAnswer
   end if
   
   project_CreateScriptOnlyStack "libraries", someQuestion, suggestedAnswer, projectName
end menu_CreateLibrary

on _
end _

on menu_ExportAndIndexProject projectName
   put merge ("Do you want to export and index project '[[projectName]]'?") into someComment
   opn_Answer someComment
   project_ExportAndIndex projectName, true
end menu_ExportAndIndexProject

on menu_StartProject projectName, someBoolean
   put library_FetchProjectHomeStackObject (projectName) into homeStackObject
   set the project_Start of homeStackObject to someBoolean
   
   if someBoolean is true then
      put merge ("Started using project '[[projectName]]'!") into someComment
   else
      put merge ("Stopped using project '[[projectName]]'!") into someComment
   end if
   opn_Notify someComment
end menu_StartProject

on _
end _

on menu_CreateNewProject
   project_Create
end menu_CreateNewProject

on menu_ChangeProject projectName, projectChoice
   put library_FetchProjectHomeStackPath (projectChoice) into homeStackPath
   put the project_UsedStackNames of stack homeStackPath into stackNames
   
   lock screen
   put menu_GettargetObject() into tObject
   put the index_View of tObject into indexView
   
   set the view_Index of indexView to stackNames
   set the title_Text of indexView to projectChoice
   put the stack_Object of indexView into stackObject
   set the label of stackObject to "Model and Libraries"
   unlock screen
end menu_ChangeProject


--> Global | Project | Tree | Menu | Props
-
getprop start_Project [projectName]
   return project_IsActive (projectName) is true
end start_Project

getprop project_Choice [indexView]
   put menu_GettargetObject() into tObject
   put the index_View of tObject into indexView
   
   put the title_Text of indexView into displayedProjectName
   return displayedProjectName
end project_Choice

getprop project_Choices
   return library_ListProjectNames()
end project_Choices


