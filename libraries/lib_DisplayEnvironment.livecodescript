script "lib_DisplayEnvironment"
--> MetaData
-
license: GPLv3
name: lib_DisplayEnvironment
type: library
version: 0.6

/*
Here we gather all the handlers that make it easy to display handlers, stacks, projects, and the environment.
see "lib_FunctionKey"
*/

--> Working on
-
command env_CommitAndPushEverything pDisplayView
   put lcw_Ask ("Comment for multiple commits...", "", "Git", pDisplayView) into someComment
   
   # Save all edited
   stack_SaveEdited "all"
   lcw_Notify "Save everything first..."
   
   put git_ListNotUpToDate() into needsUpdating
   repeat with lineNum = 1 to the number of lines of needsUpdating
      -- for each line projectName in needsUpdating
      put line lineNum of needsUpdating into projectName
      display_Spin projectName, pDisplayView, "dark green"
      
      set the cursor to watch
      put "Updating project" && projectName && "..." into sComment
      lcw_Notify sComment
      
      put env_ConstructProjectFolder (projectName) into projectFolder
      put git_GetCheckoutFolder (projectFolder) into gitFolder
      if gitFolder is empty then
         breakpoint
         next repeat
      end if
      
      # Add everything
      git_AddEverything gitFolder
      put the result into shellResult
      if shellResult is not empty then
         lcw_Notify shellResult
      end if
      
      # Stage then commit
      git_CommitChanges someComment, gitFolder
      put the result into shellResult
      if shellResult is not empty then
         lcw_Notify shellResult
      end if
      
      # Push
      git_PushBranch gitFolder
      put the result into shellResult
      set the itemdelimiter to ":"
      switch
         case item 1 of shellResult = "To https"
            /*
            To https://github.com/LiveCodeWorld/lcw_Tools.git
            f0c8cd6..270780e  master -> master
            */
            set the deleted_Line of pDisplayView to lineNum
            break
         case item 1 of shellResult = "fatal"
            /*
            fatal: 'origin' does not appear to be a git repository
            fatal: Could not read from remote repository.
            
            Please make sure you have the correct access rights
            and the repository exists.
            */
            set the line_Colour [lineNum] of pDisplayView to "red"
            break
         default
            set the line_Colour [lineNum] of pDisplayView to "blue"
            lcw_Notify shellResult
      end switch
   end repeat
end env_CommitAndPushEverything


--> Env
-
command project_AskCreate
   put the stack_Folder of stack "LCW" into rootFolder
   set the itemdelimiter to slash
   delete item -1 of rootFolder
   
   set the itemdelimiter to comma
   answer folder "Select a root folder for your new project.." with rootFolder
   if it is empty then exit to top   
   
   put lcw_Ask ("What name do you want to give the new project?", "lcw_XXX") into newProjectName
   --
   put library_ListProjectNames() into existingProjectNames
   if newProjectName is among the lines of existingProjectNames then
      answer warning merge ("You already have a project named '[[newProjectName]]'!")
      exit to top
   end if
   
   if exists (stack newProjectName) is true then
      answer warning merge ("There is already a stack named '[[newProjectName]]'!")
      exit to top
   end if
   
   text_AddTrailing rootFolder, slash
   put rootFolder & newProjectName & slash into newProjectFolder
   if there is a folder newProjectFolder then
      answer warning merge ("There is already a folder named '[[newProjectName]]' in this location!")
      exit to top
   end if
   
   project_Create newProjectFolder
   put the result into homeStackPath
   edit the script of stack homeStackPath
   --
   display_Environment
   return newProjectName
end project_AskCreate


--> Display | Events
-
on mDoubleUp_EnvironmentLib displayView, stackName
   mDoubleUp_Project displayView, stackName
end mDoubleUp_EnvironmentLib

on mDoubleUp_Project displayView, stackName
   if the optionkey is "Down" then breakpoint
   
   put the name of stack stackName into stackObject
   if the shiftKey is "Down" then
      display_StackDeps stackObject
   end if
   edit the script of stackObject
   return true
end mDoubleUp_Project


--> Display | LCW
-
command display_NotUpToDate pSaveEditedFirst, pDisplayView
   if pSaveEditedFirst is true then
      stack_SaveEdited "all"
   end if
   
   put git_ListNotUpToDate() into needsUpdating
   --
   -- display_Data needsUpdating, "Not Up-to-Date", "Environment"
   -- display_SetToolMenus "Environment", dView, "lcw_Tools"
   
   display_Tool needsUpdating, "Not Up-to-Date", "Github Update", pDisplayView
   put the result into dView
   return dView
end display_NotUpToDate

command display_RefreshEnvironment
   display_Environment true
end display_RefreshEnvironment

command display_Environment pRefreshOnly, pProjectNames
   if pRefreshOnly is true AND display_FindView ("Environment") is empty then
      return empty -- display is not open so do nothing
   end if
   if pProjectNames is empty then
      put env_ListLocalProjects() into pProjectNames
   end if
   put "List of Projects,Environment" into pStackTitle
   
   put "mDoubleUp_Environment" into mDoubleClick
   put empty into mUp
   put empty into dragCommand
   --
   put "Global | Environment | Menu" into titleMenu
   put "Global | Environment | Tree | Line | Menu" into lineMenu
   
   put display_FindView ("Environment") into displayView
   if exists (displayView) is false then
      display_Data pProjectNames, "Local Projects", "Environment"
      put the result into displayView
      --
      set the title_Menu of displayView to titleMenu
      set the line_Menu of displayView to lineMenu
      --
      set the field_Style of displayView to "click"
      set the mouse_DoubleUp of displayView to mDoubleClick
      set the drop_Command of displayView to dragCommand
   else
      --
      lock screen
      set the displayed_Index ["Local Projects"] of displayView to pProjectNames
      stack_Show displayView
   end if
   --
   put env_ListStoppedProjects() into stoppedProjects
   set the coloured_Lines ["red"] of displayView to stoppedProjects
   unlock screen
   --
   return displayView
end display_Environment

command display_EnvironmentLibs pFilterItems, pDisplayView
   -- put "Global | Project | Tree | Line | Menu" into mLineTitle
   
   put env_ListUsedStackNames() into modelsAndLibs
   if pFilterItems is empty then
      put "Active Libraries" into sTitle
   else
      put "Filtered Libraries" into sTitle
      index_Filter modelsAndLibs, pFilterItems
   end if
   --
   display_Data modelsAndLibs, sTitle, "Environment", pDisplayView
   put the result into displayView
   display_SetInteractions displayView, "Environment | Lib", "mDoubleUp_EnvironmentLib"
   return displayView
end display_EnvironmentLibs


--> Display | Project
-
command display_ProjectStacks homeStackName, pIndexView
   put project_ListStackPaths (homeStackName) into stackPaths
   --
   put stack_PathsToNames (stackPaths) into stackNames
   
   put merge ("[[homeStackName]],Project Stacks") into someTitle
   put "Global | Project | Stacks | Tree | Menu" into mTitle
   put "Global | Project | Stacks | Tree | Line | Menu" into mLineTitle
   --
   display_Index stackNames, someTitle, mTitle, mLineTitle, mUp, "mDouble_DisplayStack"
   put the result into indexView
   --
   return indexView
end display_ProjectStacks


--> Display | Project | Libraries
-
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
