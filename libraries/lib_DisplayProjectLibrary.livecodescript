script "lib_DisplayProjectLibrary"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: lib_DisplayProjectLibrary
type: library
version: 0.2

/*
This library is for displaying and editing LCW project library stacks.

Should rename it to "lib_DisplayProjectLibrary"
Key handler =  "project_CreateStack"
*/


--> Working on
-
command ask_CreateProjectLibrary projectName
   put lcw_GetAuthor() into authorName
   --
   put merge ("Create a new library in project '[[projectName]]'?") into someQuestion
   replace "'" with quote in someQuestion
   put lcw_Ask (someQuestion, "lib_XXX") into libStackName
   
   put project_GetFolder (projectName) into projectFolder
   put scaffold_GetTemplate ("LCW Library") into libTemplateScript
   --
   put _DefaultScriptSectionTitle (libStackName) into defaultScriptSectionTitle
   put merge (libTemplateScript) into libScript
   --
   project_CreateStack projectFolder, libStackName, "libraries", "library", libScript
   put the result into homeStackPath
   
   start using stack libStackName
   lcw_Notify ("Stack" && kwote (libStackName) && "is now known and used!")
   edit the script of stack libStackName
   --
   display_Project projectName
   -- finder_Reveal projectFolder
end ask_CreateProjectLibrary


--> Display | Project
-
command display_Project projectName, pExpandedItems, pRepoFolder
   local foldedArray
   if pExpandedItems is empty then put "Modules" into pExpandedItems
   put project_GetStackNameArray (projectName, pRepoFolder) into stackNameArray
   --
   -- if pExpandedItems is empty then put "modules" into pExpandedItems
   -- put project_GetFolderArray (projectName, pRepoFolder) into stackNameArray
   -- 
   put display_ConstructFoldState (pExpandedItems) into foldedArray
   display_Array stackNameArray, projectName, "Project", foldedArray
   put the result into displayView
   --
   put project_DisplayMenuTitles (projectName) into titleMenuTable
   set the title_Menu of displayView to titleMenuTable
   --
   set the line_Menu of displayView to "Global | Project | Line | Menu"
   set the mouse_DoubleUp of displayView to "mDouble_DisplayProjectTree"
   --
   return displayView
end display_Project

command display_ProjectArray projectName, pConstruct
   put project_GetFolder (projectName) into projectFolder
   if pConstruct is true then
      put project_ConstructArray (projectFolder) into projectArray
      display_Data projectArray, projectName, "Constructed Project Array"
   else
      put project_FetchArray (projectFolder) into projectArray
      display_Data projectArray, projectName, "Project Array"
   end if
   put the result into displayView
   --
   return displayView
end display_ProjectArray

function display_FindProjectView projectName
   -- this is the new array based view
   put display_FindView ("Project", projectName) into displayView
   return displayView
end display_FindProjectView

on mDouble_DisplayProjectTree displayView, stackName
   if the optionkey is "Down" then breakpoint
   --
   if the scriptonly of stack stackName is true then
      edit the script of stack stackName
   else
      go to stack stackName
   end if
   --
   if the shiftKey is "Down" then
      put the name of stack stackName into stackObject
      display_StackDeps stackObject
   end if
end mDouble_DisplayProjectTree

function project_GetFolderArray projectName, pRepoFolder
   put env_ConstructProjectFolder (projectName, pRepoFolder) into projectFolder
   put directory_NestedArray (projectFolder) into stackNameArray
   
   # Should export here
   return stackNameArray
end project_GetFolderArray

function project_GetStackNameArray projectName, pRepoFolder
   put env_ConstructProjectFolder (projectName, pRepoFolder) into projectFolder
   --
   repeat for each item shortFolder in "libraries,models,controllers,views,behaviors"
      put folder_AddShort (projectFolder, shortFolder) into sFolder
      get folder_GetStackNameArray (sFolder)
      if it is an array then
         put text_InitialCaps (shortFolder) into shortLabel
         put it into stackNameArray [shortLabel]
      end if
   end repeat
   --
   put project_ListModuleFolders (projectName) into moduleFolders
   repeat for each line moduleFolder in moduleFolders
      put project_ConstructHomeStackPath (moduleFolder) into moduleHomeStackPath
      if exists (stack moduleHomeStackPath) is false then next repeat
      
      put the short name of stack moduleHomeStackPath into stackName
      put empty into stackNameArray ["Modules"][stackName]
   end repeat
   
   return stackNameArray
end project_GetStackNameArray

command display_ProjectLibs projectName, pRefreshOnly
   display_Project projectName
   put the result into displayView
   if pRefreshOnly is true and exists (display_FindView (projectName, "Model and Libraries")) then
      return displayView
   end if
   
   put the project_UsedStackNames of stack projectName into projectLibNames
   display_Data projectLibNames, projectName, "Model and Libraries"
   put the result into displayView
   
   put project_DisplayMenuTitles (projectName) into titleMenuTable
   set the title_Menu of displayView to titleMenuTable
   --   
   set the field_Style of displayView to "click"
   set the line_Menu of displayView to "Global | Project | Line | Menu"
   set the mouse_DoubleUp of displayView to "mDouble_DisplayStackDeps"
   --
   _SafeStartProject projectName
   --
   return displayView
end display_ProjectLibs

private command _SafeStartProject projectName
   if exists (stack projectName) is false then
      project_Start projectName, true
      put the result into homeStackObject
      if homeStackObject is empty then
         put merge ("Cannot find home stack for project '[[projectName]]'") into someComment
         lcw_AnswerWarning someComment
      end if
   end if
   return homeStackObject
end _SafeStartProject


--> Display
-
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

command project_TrashStack stackObject
   -- dangerous
   put the filename of stackObject into longStackFile
   --
   stop using stackObject
   set the stack_IsKnow of stackObject to false -- do this for all projects ?
   --
   delete stackObject
   revDeleteFile longStackFile -- bug: not in the dictionary
   -- delete file longStackFile
   --
   return longStackFile
end project_TrashStack

private function _DefaultScriptSectionTitle libStackName
   set the itemdelimiter to "_"
   delete item 1 of libStackName
   put text_MakePipeTitle (libStackName) into defaultScriptSectionTitle
   return defaultScriptSectionTitle
end _DefaultScriptSectionTitle


--> Display | Library
-
function project_DisplayMenuTitles projectName
   put project_ConstructMenuTitle (projectName) & tab & "submenu" after projectMenuTitles
   --
   put CR & "-" after projectMenuTitles
   if "Global | Project | Display | Menu" is not among the lines of projectMenuTitles then
      put CR & "Global | Project | Display | Menu" & tab & "submenu" after projectMenuTitles
   end if
   if "Global | Project | Create | Menu" is not among the lines of projectMenuTitles then
      put CR & "Global | Project | Create | Menu" & tab & "submenu" after projectMenuTitles
   end if
   if "Global | Project | Tree | Menu" is not among the lines of projectMenuTitles then
      put CR & "-" after projectMenuTitles
      put CR & "Global | Project | Tree | Menu" after projectMenuTitles
   end if
   return projectMenuTitles
end project_DisplayMenuTitles
