script "Global | Project | Model | Line | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | Project | Model | Line | Menu
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
   put the display_View of tObject into displayView
   put displayView into LocalArray ["displayView"]
   
   put the title_Text of displayView into oProjectName
   put oProjectName into LocalArray ["oProjectName"]
   put _GetModelStack (tObject) into modelStack
   --
   return modelStack
end menu_Target

private function _GetModelStack tObject
   put the top_Line of tObject into shortFolder
   put the selected_Line of tObject into modelStackName
   if exists (stack modelStackName) is false then return empty
   
   put modelStackName into LocalArray ["modelStackName"]
   put the name of stack modelStackName into libraryStack
   return libraryStack
end _GetModelStack

-- getprop moveModel_Param [modelStack]
put the project_Name of modelStack into projectName
return projectName
end moveModel_Param

getprop moveModel_Params [modelStack]
   put LocalArray ["oProjectName"] into oProjectName
   put library_ListProjectNames() into projectNames
   line_Delete oProjectName, projectNames
   return projectNames
end moveModel_Params


--> Global | Project | Model | Line | Menu
-
on menu_ModelHelp mStack
   display_HelpDraft mStack
end menu_ModelHelp

on menu_ScriptTools modelStack
   display_ScriptTools modelStack
end menu_ScriptTools

private on _
end _

on menu_CreateProjectModel modelStack
   put the project_Name of modelStack into projectName
   ask_CreateProjectModel projectName
   display_Project projectName
end menu_CreateProjectModel

on menu_MoveModel modelStack, newProjectName
   # Collect info
   put the project_Name of modelStack into oProjectName
   put the short name of modelStack into modelStackName
   --
   put LocalArray ["oProjectName"] into oProjectName
   
   # Ask
   put LocalArray ["displayView"] into displayView
   switch
      case newProjectName is empty
         lcw_AnswerWarning "Something went wrong with script. This menu item is supposed to list new project names?", displayView
      case oProjectName = newProjectName
         -- should not be possible
         lcw_AnswerWarning merge ("Stack is already in project '[[newProjectName]]'. Choose a new project to move this library to!"), displayView
      default
         lcw_Answer "Move model '[[modelStackName]]' to project '[[newProjectName]]'?", displayView, modelStackName, newProjectName
   end switch
   
   # Move
   project_MoveStackRelative modelStackName, newProjectName
   
   # Display
   lcw_Notify merge ("Moved model to new project '[[newProjectName]]'!")
   display_Project oProjectName
   display_Project newProjectName
end menu_MoveModel

on menu_RenameModel modelStack
   put the short name of modelStack into stackName
   --
   ask_RenameProjectStack stackName
end menu_RenameModel
