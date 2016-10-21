script "lib_DisplayEnvironment"
--> MetaData
-
license: GPLv3
name: lib_DisplayEnvironment
type: library
version: 0.4

/*
Here we gather all the handlers that make it easy to display handlers, stacks, projects, and the environment.

-- command display_EnvironmentProjects   
put library_ListProjectNames() into projectNames
put "List of Projects,Environment" into displayTitle
display_Index projectNames, displayTitle, "Global | Environment | Menu", "Global | Project | Tree | Line | Menu", empty, "mDouble_DisplayProject"
put the result into displayView
set the multiple_Hilites of displayView to false
return displayView
end display_EnvironmentProjects

*/

--> Working on
-
command display_Used
   put library_ListProjectNames ("all") into projectNames
   display_ProjectList projectNames, indexView, "List Projects and Modules"
   put the result into indexView
   return indexView
end display_Used

command display_Project homeStackName, pGoOrEdit
   if exists (stack homeStackName) is true then
      put the effective filename of stack homeStackName into homeStackPath
   else
      put library_FetchProjectHomeStackPath (homeStackName) into homeStackPath
      if exists (stack homeStackPath) is false then
         put homeStackName
         answer warning merge ("Cannot locate stack '[[homeStackName]]'")
         exit to top
      end if
   end if
   
   if pGoOrEdit is true then
      if the scriptonly of stack homeStackPath is true then
         edit the script of stack homeStackPath
      else
         go to stack homeStackPath
      end if
   end if
   
   display_LibrariesAndModels homeStackPath
   put the result into indexView
   set the menu_Target of indexView to homeStackName
   
   display_ProjectModules homeStackName
   
   -- could check to see if it is already loaded
   -- but here we just load again (may be useful)
   project_Start homeStackName
   
   return indexView
end display_Project


--> Display | ProjectList
-
command display_ProjectList pProjectNames, pIndexView, pStackTitle
   if pProjectNames is empty then put library_ListProjectNames() into pProjectNames
   if pStackTitle is empty then put "List of Projects,Environment" into pStackTitle
   
   put "mDouble_DisplayProject" into mDoubleUp
   
   put empty into mUp
   put "Global | Environment | Menu" into mTitle
   put "Global | Project | Tree | Line | Menu" into mLineTitle
   
   if exists (pIndexView) is false then
      put empty into mUp
      display_Index pProjectNames, pStackTitle, mTitle, mLineTitle, mUp, mDoubleUp
      put the result into displayView
      return displayView
   else
      lock screen
      set the view_Index of pIndexView to pProjectNames
      set the stack_Title of pIndexView to pStackTitle
      set the mouse_DoubleUpEvent of pIndexView to mDoubleUp
      set the title_Menu of pIndexView to mTitle
      set the line_Menu of pIndexView to mLineTitle
      unlock screen
      return pIndexView
   end if
end display_ProjectList


--> Display | Libraries
-
command display_LibrariesAndModels homeStackPath
   put the short name of stack homeStackPath into homeStackName
   put the project_UsedStackNames of stack homeStackPath into stackNames
   
   put merge ("[[homeStackName]],Model and Libraries") into someTitle
   put empty into mUp
   
   put project_ConstructMenuTitle (homeStackName) & tab & "submenu" after projectMenuTitles
   --
   put CR & "-" after projectMenuTitles
   put CR & "Global | Project | Display | Menu" & tab & "submenu" after projectMenuTitles
   put CR & "Global | Project | Create | Menu" & tab & "submenu" after projectMenuTitles
   put CR & "-" after projectMenuTitles
   put CR & "Global | Project | Tree | Menu" after projectMenuTitles
   
   display_Index stackNames, someTitle, projectMenuTitles, "Global | Project | Line | Menu", mUp, "mDouble_DisplayStackDeps"
   put the result into indexView
   set the multiple_Hilites of indexView to false
   return indexView
end display_LibrariesAndModels

command display_Libraries pIndexView, pProjectNames
   -- see also "display_Project" and "display_LibrariesAndModels"
   put env_ListUsedStackNames (pProjectNames) into activeUsedStackNames
   sort activeUsedStackNames
   
   put empty into mUp
   put "mDouble_DisplayStackDeps" into mDoubleUp
   put "Active Libraries,Environment" into stackTitle
   
   put "Global | Environment | Menu" into mTitle
   put "Global | Project | Tree | Line | Menu" into mLineTitle
   
   if exists (pIndexView) is false then
      display_Index activeUsedStackNames, stackTitle, mTitle, mLineTitle, mUp, mDoubleUp
      put the result into displayView
      return displayView
   else
      lock screen
      set the view_Index of pIndexView to activeUsedStackNames
      set the stack_Title of pIndexView to stackTitle
      set the mouse_DoubleUpEvent of pIndexView to mDoubleUp
      set the title_Menu of pIndexView to mTitle
      set the line_Menu of pIndexView to mLineTitle
      unlock screen
      return pIndexView
   end if
end display_Libraries


--> Display | Events
-
command mDouble_DisplayStack indexView, stackName
   switch
      case exists (stack stackName) is false
         answer merge("Could not find stack '[[stackName]]'.")
         break
      case the scriptonly of stack stackName is true
         edit the script of stack stackName
         break
      default
         go to stack stackName
   end switch
end mDouble_DisplayStack

on mDouble_DisplayProject targetObject, stackName
   display_Project stackName
end mDouble_DisplayProject

command mDouble_DisplayBehavior indexView, stackName
   mDouble_DisplayStack indexView, stackName
end mDouble_DisplayBehavior



--> Display | Project | Standard
-
command display_ProjectStacks homeStackName, pIndexView
   put project_ListStackPaths (homeStackName) into stackPaths
   put stack_PathsToNames (stackPaths) into stackNames
   
   put merge ("[[homeStackName]],Project Stacks") into someTitle
   put "Global | Project | Stacks | Tree | Menu" into mTitle
   put "Global | Project | Stacks | Tree | Line | Menu" into mLineTitle
   display_Index stackNames, someTitle, mTitle, mLineTitle, mUp, "mDouble_DisplayStack"
   put the result into indexView
   return indexView
end display_ProjectStacks

command display_ProjectFrontScripts homeStackName, pIndexView
   put project_ListFrontScriptPaths (homeStackName) into stackPaths
   put stack_PathsToNames (stackPaths) into stackNames
   
   put merge ("[[homeStackName]],Project FrontScripts") into someTitle
   put "Global | Project | FrontScripts | Tree | Menu" into mTitle
   put "Global | Project | FrontScripts | Tree | Line | Menu" into mLineTitle
   display_Index stackNames, someTitle, mTitle, mLineTitle, mUp, "mDouble_DisplayStack"
   put the result into indexView
   return indexView
end display_ProjectFrontScripts

command display_ProjectBackScripts homeStackName, pIndexView
   put project_ListBackScriptPaths (homeStackName) into stackPaths
   put stack_PathsToNames (stackPaths) into stackNames
   
   put merge ("[[homeStackName]],Project BackScripts") into someTitle
   put "Global | Project | BackScripts | Tree | Menu" into mTitle
   put "Global | Project | BackScripts | Tree | Line | Menu" into mLineTitle
   display_Index stackNames, someTitle, mTitle, mLineTitle, mUp, "mDouble_DisplayStack"
   put the result into indexView
   return indexView
end display_ProjectBackScripts


--> Display | Environment
-
function project_ConstructMenuTitle homeStackName
   set the itemdelimiter to "_"
   put item -1 of homeStackName into menuBit
   put toupper (char 1 of menuBit) into char 1 of menuBit
   put "Global |" && menuBit && "| Menu" into gMenuTitle
   return gMenuTitle
end project_ConstructMenuTitle
