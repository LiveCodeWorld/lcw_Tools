script "lib_DisplayProjectLibrary"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: lib_DisplayProjectLibrary
type: library
version: 0.2

/*
This library is for displaying and editing LCW project library stacks.

Should rename it to "lib_DisplayProjectLibrary"
Key handler =  "project_CreateStack"
*/

getprop dep_StackNames
   return "lib_Project"
end dep_StackNames


--> Working on
-
function lcw_GetAuthor
   put pref_GetValue ("userName") into authorName
   if authorName is empty then put "Anonymous" into authorName
   return authorName
end lcw_GetAuthor

command lcw_SetAuthor authorName
   pref_SetValue "userName", authorName
end lcw_SetAuthor

command display_AskCreateProjectLibrary projectName
   put lcw_GetAuthor() into authorName
   --
   put merge ("Create a new library in project '[[projectName]]'?") into someQuestion
   replace "'" with quote in someQuestion
   --
   put the clipboardData ["text"] into suggestedAnswer
   if the number of words of suggestedAnswer > 1 or the number of chars of suggestedAnswer > 20 then
      set the itemdelimiter to "_"
      put "lib_" &  item -1 of projectName into suggestedAnswer 
   end if
   put lcw_Ask (someQuestion, suggestedAnswer) into libStackName
   
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
   display_ProjectLibs projectName
   -- finder_Reveal projectFolder
end display_AskCreateProjectLibrary

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
command display_ProjectLibs projectName
   if exists (stack projectName) is false then
      project_Start projectName, true
      put the result into homeStackObject
      if homeStackObject is empty then
         put merge ("Cannot find home stack for project '[[projectName]]'") into someComment
         lcw_AnswerWarning someComment
      end if
   end if
   --
   put the project_UsedStackNames of stack projectName into projectLibNames
   put "Model and Libraries" into stackLabel
   put display_FindView (stackLabel, projectName) into displayView
   
   if exists (displayView) is true then
      set the view_Index of displayView to projectLibNames
      go to stack projectName
   else
      put "mDouble_DisplayStackDeps" into mDoubleUp
      --
      put project_DisplayMenuTitles (projectName) into titleMenuTable
      put "Global | Project | Line | Menu" into lineMenu
      --   
      display_Data projectLibNames, projectName, stackLabel
      put the result into displayView
      --
      set the field_Style of displayView to "click"
      --
      set the title_Menu of displayView to titleMenuTable
      set the line_Menu of displayView to lineMenu
      set the mouse_DoubleUp of displayView to mDoubleUp
   end if
   --
   put the stack_Name of displayView into stackName
   go to stack projectName
   --
   return displayView
end display_ProjectLibs

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
