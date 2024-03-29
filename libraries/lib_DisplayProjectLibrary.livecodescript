﻿script "lib_DisplayProjectLibrary"
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
command ask_CreateProjectBehavior projectName, pQuestion, pSuggestedAnswer
   if pSuggestedAnswer is empty then put "behavior_XXX" into pSuggestedAnswer
   if pQuestion is empty then
      put merge ("Create a new behavior in project '[[projectName]]'?") into pQuestion
      replace "'" with quote in pQuestion
   end if
   put lcw_GetAuthor() into authorName
   put lcw_Ask (pQuestion, pSuggestedAnswer) into bName
   --
   project_CreateBehavior bName, projectName
   put the result into sPath
   --   
   edit the script of stack bName
   display_Project projectName
   -- finder_Reveal projectFolder
   return sPath
end ask_CreateProjectBehavior

command project_CreateBehavior bName, projectName
   put project_GetFolder (projectName) into projectFolder
   put scaffold_Get ("View Behavior Template") into tScript
   put merge (tScript) into tScript
   --
   project_CreateStack projectFolder, bName, "behaviors", "behavior", tScript
   put the result into sPath
   return sPath
end project_CreateBehavior

command ask_CreateProjectLibrary projectName, pQuestion, pSuggestedAnswer
   if pSuggestedAnswer is empty then put "lib_XXX" into pSuggestedAnswer
   put lcw_GetAuthor() into authorName
   --
   if pQuestion is empty then
      put merge ("Create a new library in project '[[projectName]]'?") into pQuestion
      replace "'" with quote in someQuestion
   end if
   put lcw_Ask (someQuestion, pSuggestedAnswer) into libStackName
   
   put project_GetFolder (projectName) into projectFolder
   put scaffold_Get ("LCW Library") into libTemplateScript
   --
   set the itemdelimiter to "_"
   get item 2 to -1 of libStackName
   put text_MakePipeTitle (it) into defaultScriptSectionTitle
   --
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

command ask_TrashProjectStack stackObject
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
end ask_TrashProjectStack


--> Display | Project
-
command display_Project projectName, pRefreshOnly, pExpandedItems
   local foldedArray
   if pRefreshOnly is true AND display_FindProjectView (projectName) is empty then
      return empty -- display is not open so do nothing
   end if
   
   if pExpandedItems is empty then put "Modules" into pExpandedItems
   put project_GetStackNameArray (projectName) into stackNameArray
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
   if pConstruct is true then
      put project_ConstructArray (projectName) into projectArray
      display_Data projectArray, projectName, "Constructed Project Array"
   else
      put project_GetFolder (projectName) into projectFolder
      put project_FetchArray (projectFolder) into projectArray
      display_Data projectArray, projectName, "Project Array"
   end if
   put the result into displayView
   --
   display_SetInteractions displayView, "Project | Array", "mDoubleUp_ProjectArray", "lib_DisplayProject"
   --
   return displayView
end display_ProjectArray

on mDouble_DisplayProjectTree displayView, stackName
   if the optionkey is "Down" then breakpoint
   --
   if the scriptonly of stack stackName is true then
      edit the script of stack stackName
   else
      show stack stackName
      toplevel stack stackName
      set the loc of stack stackName to the loc of displayView
   end if
   --
   if the shiftKey is "Down" then
      put the name of stack stackName into stackObject
      display_StackDeps stackObject
   end if
end mDouble_DisplayProjectTree

command display_ProjectLibs projectName, pRefreshOnly
   display_Project projectName
   put the result into displayView
   if pRefreshOnly is true and exists (display_FindView (projectName, "Model and Libraries")) then
      return displayView
   end if
   
   if exists (stack projectName) is true then
      put the project_UsedStackNames of stack projectName into projectLibNames
      display_Data projectLibNames, projectName, "Model and Libraries"
      put the result into displayView
      
      put project_DisplayMenuTitles (projectName) into titleMenuTable
      set the title_Menu of displayView to titleMenuTable
      --   
      set the field_Style of displayView to "click"
      set the line_Menu of displayView to "Global | Project | Line | Menu"
      set the mouse_DoubleUp of displayView to "mDoubleUp_Project"
      --
      _SafeStartProject projectName
   end if
   return displayView
end display_ProjectLibs


--> Display | Utils
-
function display_FindProjectView projectName
   -- this is the new array based view
   put display_FindView ("Project", projectName) into displayView
   return displayView
end display_FindProjectView


--> Project | Display
-
function project_GetFolderArray projectName, pRepoFolder
   put env_ConstructProjectFolder (projectName, pRepoFolder) into projectFolder
   put directory_NestedArray (projectFolder) into stackNameArray
   
   # Should export here
   return stackNameArray
end project_GetFolderArray

function project_GetStackNameArray projectName, pRepoFolder
   put env_ConstructProjectFolder (projectName, pRepoFolder) into projectFolder
   --
   repeat for each item shortFolder in "libraries,models,controllers,views,behaviors,stacks"
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
      put project_PathFromFolder (moduleFolder) into moduleHomeStackPath
      if exists (stack moduleHomeStackPath) is false then next repeat
      
      put the short name of stack moduleHomeStackPath into stackName
      put empty into stackNameArray ["Modules"][stackName]
   end repeat
   
   return stackNameArray
end project_GetStackNameArray

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

function project_ConstructMenuTitle homeStackName
   set the itemdelimiter to "_"
   put item -1 of homeStackName into menuBit
   put toupper (char 1 of menuBit) into char 1 of menuBit
   put "Global |" && menuBit && "| Menu" into gMenuTitle
   return gMenuTitle
end project_ConstructMenuTitle


--> Private
-
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
