script "Global | Project | Lib | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Project | Lib | Line | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

command display_AskProjectTrashStack stackObject
   if exists (stackObject) is false then
      display_DebugHistory pDisplayTitle, pAlsoArray
      lcw_AnswerWarning "Stack does not exist!"
   end if
   put merge ("Are you sure you want to delete the file, and remove the [[stackObject]] from all projects?") into someQuestion
   lcw_Answer someQuestion
   --
   put the project_Name of stackObject into projectName
   --
   project_TrashStack stackObject
   put the result into trashedStackFile
   --
   display_ProjectLibs projectName
end display_AskProjectTrashStack


--> Display | ScriptCall
-
private command display_ScriptCallArray libraryStack
   put the script_CallArray [true] of libraryStack into scriptCallArray
   --
   display_Array scriptCallArray, "the script_CallArray", libraryStack
   put the result into displayView
   display_SetInteractions displayView, "HkeyArray | Tree | Deps", "checkCall"
   set the displayed_Object of displayView to libraryStack
   return displayView
end display_ScriptCallArray

command checkCall treeView, hObject, treePath
   if the optionKey is "Down" then breakpoint
   
   set the itemdelimiter to slash
   put item 1 of treePath into shortCall
   put item 2 of treePath into shortParent
   put the selected_Value of treeView into parentObject
   put shortParent & CR & shortCall & comma & parentObject
end checkCall


--> Menu | Props
-
getprop menu_Target [tObject]
   -- get mArray_GetActiveTitle()
   --
   put tObject into LocalArray ["tObject"]
   put the title_Text of tObject into oProjectName
   put oProjectName into LocalArray ["oProjectName"]
   put _GetLibraryStack (tObject) into libraryStack
   --
   return libraryStack
end menu_Target

getprop moveToModuleBehavior_Params [libraryStack]
   put the project_Name of libraryStack into projectName
   -- return project_ListModules (projectName) -- stackNames
   return project_ListModuleShortFolders (projectName)
end moveToModuleBehavior_Params

private function _GetLibraryStack tObject
   put the top_Line of tObject into shortFolder
   --
   switch shortFolder
      case "Libraries"
      case "Models"
         put the selected_Line of tObject into libStackName
         put libStackName into LocalArray ["libStackName"]
         if exists (stack libStackName) is false then return empty
         
         put the name of stack libStackName into libraryStack
         return libraryStack
      default
         return empty
   end switch
end _GetLibraryStack

getprop moveUsed_Param [libraryStack]
   put the project_Name of libraryStack into projectName
   return projectName
end moveUsed_Param

getprop moveUsed_Params [libraryStack]
   put LocalArray ["oProjectName"] into oProjectName
   put library_ListProjectNames() into projectNames
   
   -- don't move the library to the project it is already index_ConstructUnique(someIndex)
   line_Delete oProjectName, projectNames
   return projectNames
end moveUsed_Params

getprop stackIsUsed_Param [libraryStack]
   put the short name of libraryStack into stackName
   put stackName is among the lines of the stacksinuse into someBoolean
   return someBoolean
end stackIsUsed_Param

getprop stackIsUsed_Params
   return "true,false"
end stackIsUsed_Params

getprop displayModelData_ShortFiles [libraryStack]
   put the model_Names of libraryStack into shortFiles
   return shortFiles
end displayModelData_ShortFiles

getprop disabled_DisplayModelData [libraryStack]
   put the short name of libraryStack into modelName
   set the itemdelimiter to "_"
   if item 1 of modelName is "model" then
      return false
   else
      return "delete"
   end if
end disabled_DisplayModelData


--> Global | Project | Lib | Line | Menu
-
on menu_LibraryHelp libraryStack
   display_HelpDraft libraryStack
end menu_LibraryHelp

on menu_DisplayProject libraryStack
   put the project_Name of libraryStack into projectName
   --
   display_ProjectLibs projectName
end menu_DisplayProject

on submenu_Controller
   return "Global | Project | Controllers | Line | Menu"
end submenu_Controller

on submenu_ProjectStack
   return "Global | Project | Stack | Menu"
end submenu_ProjectStack

on _
end _

on menu_MoveUsed libraryStack, newProjectName
   put the project_Name of libraryStack into oProjectName
   put the short name of libraryStack into libStackName
   --
   put LocalArray ["libStackName"] into libStackName
   put LocalArray ["oProjectName"] into oProjectName
   --
   switch
      case newProjectName is empty
         lcw_AnswerWarning "Something went wront with script. This menu item is supposed to list new project names?"
      case oProjectName = newProjectName
         lcw_AnswerWarning merge ("Stack is already in project '[[newProjectName]]'. Choose a new project to move this library to!")
   end switch
   
   project_MoveStackRelative libStackName, newProjectName
   --
   lcw_Notify merge ("Moved library to new project '[[newProjectName]]'!")
   --
   -- display_ProjectLibs oProjectName
   -- display_ProjectLibs newProjectName
   display_Project oProjectName
   display_Project newProjectName
end menu_MoveUsed

on menu_MoveToModuleBehavior libraryStack, moduleShortFolder
   put the project_Name of libraryStack into projectName
   put the project_Folder of libraryStack into projectFolder
   
   # Move
   project_MoveLibraryToModuleBehavior libraryStack, moduleShortFolder
   put the result into newBehaviorPath
   
   # Refresh Project display
   display_Project projectName
   
   # Refresh Module Tools display
   put module_GetFolder (moduleShortFolder, projectFolder) into moduleFolder
   put project_PathFromFolder (moduleFolder) into moduleHomeStackPath
   display_ModuleTools moduleHomeStackPath
end menu_MoveToModuleBehavior

on menu_StackIsUsed libraryStack, someBoolean
   if someBoolean is true then
      start using libraryStack 
   else
      stop using libraryStack
   end if
end menu_StackIsUsed

on _
end _

on menu_TrashStack libraryStack
   display_AskProjectTrashStack libraryStack
end menu_TrashStack

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on _DisplayScriptObject libraryStack
   display_ScriptObject libraryStack
end _DisplayScriptObject

on _DisplayStackDeps libraryStack
   display_StackDeps libraryStack
end _DisplayStackDeps

on _
end _

on _DisplayModelData libraryStack, modelShortFile
   put the short name of libraryStack into modelName
   put the model_Array [modelShortFile] of libraryStack into modelArray
   
   put "model_Array" & comma & modelName into someTitle
   display_Array modelArray, someTitle
end _DisplayModelData

on _ModelDataFolder libraryStack
   put the model_DataFolder of libraryStack into modelDataFolder
   finder_Reveal modelDataFolder
end _ModelDataFolder

on _
end _

on _DisplayScriptCallArray libraryStack
   display_ScriptCallArray libraryStack
end _DisplayScriptCallArray

on _ScriptCalls libraryStack
   put the script_Calls of libraryStack into scriptCalls
   put merge ("the script_Calls,[[libraryStack]]") into someTitle
   display_Index scriptCalls, someTitle, "Global | Handler | Calls | Menu"
   put the result into displayView
   set the multiple_Hilites of displayView to true
end _ScriptCalls

on _
end _

on _ExportHandlersAndCalls libraryStack
   script_ExportHandlersAndCalls libraryStack, true
   
   menu_ShortHkeyArray libraryStack
end _ExportHandlersAndCalls

