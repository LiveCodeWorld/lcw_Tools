﻿script "lib_DisplayProjectLibrary"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: lib_DisplayProjectLibrary
type: library
version: 0.3

/*
This library is for displaying and editing LCW project library stacks.

Should rename it to "lib_DisplayProjectLibrary"
Key handler =  "project_CreateStack"
*/


--> Working on
-
function project_GetStackNameArray projectName, pRepoFolder
   -- arrays for node_Modules crash
   
   put env_ConstructProjectFolder (projectName, pRepoFolder) into projectFolder
   put directory_NestedArray (projectFolder) into stackNameArray
   return stackNameArray
   
   /*
   repeat for each item shortFolder in "libraries,models,controllers,views,behaviors,stacks"
      put folder_AddShort (projectFolder, shortFolder) into sFolder
      get folder_GetStackNameArray (sFolder)
      if it is an array then
         put text_InitialCaps (shortFolder) into shortLabel
         put it into stackNameArray [shortLabel]
      end if
   end repeat
   
   put project_ListModuleFolders (projectName) into moduleFolders
   repeat for each line moduleFolder in moduleFolders
      put project_PathFromFolder (moduleFolder) into moduleHomeStackPath
      if exists (stack moduleHomeStackPath) is false then next repeat
      
      put the short name of stack moduleHomeStackPath into stackName
      put empty into stackNameArray ["Modules"][stackName]
   end repeat
   */
   
   -- seems to be crashing?
   # Fix ModuleArray (nested display not working?)
   put stackNameArray ["modules"] into moduleArray
   delete variable stackNameArray ["modules"]
   --
   repeat for each key shortModuleFolder in moduleArray
      put module_GetHomeStackPath (shortModuleFolder, projectName) into moduleHomeStackPath
      if exists (stack moduleHomeStackPath) is false then next repeat
      
      put the short name of stack moduleHomeStackPath into stackName
      put empty into stackNameArray ["Modules"][stackName] -- bug: modules as a key does not display
   end repeat   
   return stackNameArray
end project_GetStackNameArray

function project_DisplayMenuTitles projectName
   -- used by display local Environment 
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


--> Ask

command ask_CreateModuleBehavior moduleStackName, dView, pDefaultBehaviorName
   if exists (stack moduleStackName) is false then
      put merge ("Error, behavior stack [[moduleStackName]] does not exist") into someError
      lcw_AnswerWarning someError
      return moduleStackName
   end if
   --
   if pDefaultBehaviorName is empty then
      put the module_DevBehaviorName of stack moduleStackName into pDefaultBehaviorName
   end if
   --
   put the module_Folder of stack moduleStackName into moduleFolder
   
   # New Behavior short file
   put lcw_Ask ("What name do you want to give this new behavior?", pDefaultBehaviorName, dView) into newBehaviorName
   if there is a stack newBehaviorName then
      lcw_AnswerWarning "A stack named '[[newBehaviorName]]' already exists!", dView, newBehaviorName
   end if
   put newBehaviorName & ".livecodescript" into bShortFile
   
   # New behavior file
   put module_ConstructBehaviorPath (newBehaviorName, moduleFolder, bShortFile) into newBehaviorStackPath
   if there is a stack newBehaviorStackPath then
      put newBehaviorStackPath
      lcw_AnswerWarning "A stack at this path already exists!", dView
   end if
   
   # Create
   module_CreateBehavior moduleFolder, newBehaviorName
   put the result into newBehaviorStackPath
   --
   display_ModuleTools moduleStackName
   --
   return newBehaviorStackPath
end ask_CreateModuleBehavior

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


--> Ask
-
command ask_TrashProjectStack stackObject
   --  was ""ask_DeleteProjectStack""
   switch
      case word 1 of stackObject is not "stack"
         lcw_AnswerWarning "Not a stack" && stackObject
         break
      case exists (stackObject) is false
         display_DebugHistory pDisplayTitle, pAlsoArray
         lcw_AnswerWarning "Stack does not exist!"
         break
      default
         -- good stackObject
   end switch
   
   # Ask Question
   -- put "Delete model '[[stackName]]'?" into someQuestion
   -- put ask_Question (someQuestion, stackName, "Rename Model", stackName) into newStackName
   put merge ("Are you sure you want to delete the file, and remove the [[stackObject]] from all projects?") into someQuestion
   lcw_Answer someQuestion
   
   # Trash Stack
   project_TrashStack stackObject
   put the result into trashedStackFile
   
   # Display Result
   put the project_Name of stackObject into projectName
   display_ProjectLibs projectName
end ask_TrashProjectStack

command ask_CreateProjectLibrary projectName, pQuestion, pSuggestedAnswer
   if pSuggestedAnswer is empty then put "lib_XXX" into pSuggestedAnswer
   put lcw_GetAuthor() into authorName
   --
   if pQuestion is empty then
      put merge ("Create a new library in project '[[projectName]]'?") into pQuestion
      replace "'" with quote in pQuestion
   end if
   put lcw_Ask (pQuestion, pSuggestedAnswer) into libStackName
   
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
   put the result into sPath
   
   start using stack libStackName
   lcw_Notify ("Stack" && kwote (libStackName) && "is now known and used!")
   edit the script of stack libStackName
   --
   display_Project projectName
   -- finder_Reveal projectFolder
   --
   return libStackName
end ask_CreateProjectLibrary


--> Mouse
-
on mDoubleUp_ProjectArray displayView, someLine
   breakpoint
   put the title_Text of displayView into someTitle
end mDoubleUp_ProjectArray


--> Display | Project
-
on display_UpdateProjectArray projectName
   project_UpdateArray projectName
   put the result into projectArray
   --
   display_ProjectArray projectName
   display_Project projectName
   display_EnvironmentMenus true
   display_GitRefreshProjectName projectName
end display_UpdateProjectArray

command display_ScriptDiff scriptObject, pContextLineNums
   put the script_Diff [pContextLineNums] of scriptObject into uDiff
   --
   put the name of scriptObject into sTitle
   display_Data uDiff, sTitle, "UnifiedDiff"
   display_Text uDiff, sTitle, "UnifiedDiff"
   return the result
end display_ScriptDiff

command display_ScriptIsDifferent scriptObject, pDiffAlso
   if pDiffAlso is true then
      display_ScriptDiff scriptObject
   end if
   --
   put the script of scriptObject into controlScript
   put the exported_Script of scriptObject into exportedScript
   terminal_Diff exportedScript, controlScript, "exported.txt", "control.txt"
   return the result
end display_ScriptIsDifferent

command project_CreateBehavior bName, projectName
   put project_GetFolder (projectName) into projectFolder
   put scaffold_Get ("View Behavior Template") into tScript
   put merge (tScript) into tScript
   --
   project_CreateStack projectFolder, bName, "behaviors", "behavior", tScript
   put the result into sPath
   return sPath
end project_CreateBehavior


--> Display | Project
-
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


--> Project | Display
-
function project_GetFolderArray projectName, pRepoFolder
   put env_ConstructProjectFolder (projectName, pRepoFolder) into projectFolder
   put directory_NestedArray (projectFolder) into stackNameArray
   
   # Should export here
   return stackNameArray
end project_GetFolderArray

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
