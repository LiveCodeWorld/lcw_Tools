script "Global | Environment | Menu"
--> MetaData
-
license: GPLv3
name: Global | Environment | Menu
type: controller
version: 0.3

/*
This menu needs tidying - removing the old stuff at the bottom.
*/


--> Variables
-
local LocalArray


--> Events | Display
-
on doubleup_DisplayScriptOnlyfolder indexView, mainStackName
   -- put the dataObject_Folder [true] of stack mainStackName into testDataFolder
   put textStack_ConstructDataFolder (mainStackName) into dataFolder
   put script_ReconstructFromExported (dataFolder) into someScript
   
   if exists (stack mainStackName) is false then
      create script only stack mainStackName
      set the script of stack mainStackName to someScript
      edit the script of stack mainStackName
      show stack mainStackName
   else
      display_Text someScript
      atom_DisplayText someScript
   end if
end doubleup_DisplayScriptOnlyfolder

function textStack_ConstructDataFolder mainStackName, pStackName, pLongObjectID
   -- same functionality as "getprop dataObject_Folder"
   
   put textStack_ConstructFolder (mainStackName) into textStackFolder -- textStack_Folder
   put textStackFolder & "data/" into textStackDataFolder
   
   switch pStackName
      case empty
      case mainStackName
         put textStackDataFolder & "objects/" into dataFolder
         break
      default
         put textStackDataFolder & "objects/substacks/" & pStackName & "/" into dataFolder
   end switch
   
   switch word 1 of pLongObjectID
      case empty
      case "stack"
         put "stack/" after dataFolder
         break
      default
         put word 1 of pLongObjectID & "_" & word 3 of pLongObjectID & "/" after dataFolder
   end switch
   return dataFolder
end textStack_ConstructDataFolder


--> Menu | Init
-
getprop menuStyle_Param
   return the menu_Style of stack "lib_MenuArray"
end menuStyle_Param

getprop menuStyle_Params
   return "Array,Old"
end menuStyle_Params

getprop setMenu_Param
   return ide_ShortTitle ("Recent")
end setMenu_Param

getprop setMenu_Params
   put ide_ListShortMenuTitles ("Recent") into shortNames
   return shortNames
end setMenu_Params

getprop displayRecentExports_Params
   return "5 min,10 min,20 min,30 min,300 min,-,ask"
end displayRecentExports_Params

getprop display_Params
   return "List Projects,-,Libraries and Models,Libraries and Models,-,List All Modules,-,Controllers,List All Behaviors,Behaviors,Views"
end display_Params

getprop disabled_SaveEditedStacks
   put stack_ListEditedNames() into editedStackNames
   if editedStackNames is empty then
      -- return true
      return "delete"
   else
      return false
   end if
end disabled_SaveEditedStacks


--> Global | Environment | Menu
-
on menu_SaveEditedStacks
   stack_SaveEdited "all"
end menu_SaveEditedStacks

on submenu_TransportServer
   return "Global | Transport | Model | Menu"
end submenu_TransportServer

on _
end _

on menu_FindStack
   display_SpotlightStacks
end menu_FindStack

on menu_FindPodcast
   display_FindPodcast
end menu_FindPodcast

on _
end _

on menu_DisplayNewAtopiaFolders
   display_AtopiaNewFolders
end menu_DisplayNewAtopiaFolders

on menu_DisplayAtopiaLogs
   put "/var/log/upstart/wiki.log" into logPath
   put atopia_FetchData (logPath) into logData
   --
   -- display_Text logData
   atom_DisplayText logData
end menu_DisplayAtopiaLogs

on menu_DisplayTransporters
   display_Transporters
end menu_DisplayTransporters

on menu_DisplayGithubProjects
   display_GithubProjects
end menu_DisplayGithubProjects

on _
end _

on submenu_Projects
   return "Global | LCW | Projects | Menu"
end submenu_Projects

on menu_EnvironmentLibs indexView
   display_EnvironmentLibs indexView
end menu_EnvironmentLibs

on menu_EnvironmentMenus
   display_EnvironmentMenus
end menu_EnvironmentMenus

on menu_EnvironmentViews
   display_EnvironmentViews
end menu_EnvironmentViews

on menu_EnvironmentModules
   display_ListModules
end menu_EnvironmentModules

on menu_EnvironmentOldViews
   display_OldViewFiles
end menu_EnvironmentOldViews

on _
end _

on menu_GatherDataViews
   put display_ListStackNames() into stackNames
   repeat for each line stackName in stackNames
      set the cursor to busy
      set the loc of stack stackName to the screenloc
      show stack stackName
   end repeat
end menu_GatherDataViews

on menu_ListDataViews
   display_ListDataViews
end menu_ListDataViews

on _
end _

on menu_DisplayRecentExports mTarget, howLong
   if howLong = "ask" then
      put lcw_Ask ("How many hours...", 60) into someHours
      if someHours is not a number then exit to top
      put someHours * 60 into howLong
   end if
   display_RecentExports howLong
end menu_DisplayRecentExports

on menu_DisplayExportedScript indexView, mainStackName
   --put textStack_ConstructDataFolder (mainStackName) into dataFolder
   answer folder "Select a folder..."
   put it into dataFolder
   --
   put script_ReconstructFromExported (dataFolder) into someScript
   --
   display_Text someScript
   atom_DisplayText someScript
end menu_DisplayExportedScript

on _
end _

on menu_DisplayAtopiaAuthors
   --  display_LocalAuthorNameData
   display_AuthorData
end menu_DisplayAtopiaAuthors

on menu_DisplayFederationServers
   display_FederationServers
end menu_DisplayFederationServers

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_Refresh
   display_LcwProjectList
end menu_Refresh

on _
end _

on menu_DisplayDynadot
   display_Dynadot
end menu_DisplayDynadot

on submenu_DisplayMore
   return "Global | Environment | Display | Menu"
end submenu_DisplayMore

on menu_SetMenu mTarget, shortName
   ide_SetMenuTitle "Recent", shortName
   --
   put ide_GetMenuTitle ("Recent") into mTitle
   --
   menu_Edit mTitle
   put mTitle
end menu_SetMenu

on menu_MenuStyle indexView, mStyle
   set the menu_Style of stack "lib_MenuArray" to mStyle
end menu_MenuStyle

on menu_TestRecentMenu
   put "Recent" into ideElement
   put "Watch" into shortTitle
   --
   put ide_ConstructMenuController (ideElement, shortTitle) into mController
   if exists (mController) is true then
      menu_LoadFromScript mController
      put the result into menuTitleArray
   end if
   --
   ide_SetMenuTitle ideElement, shortTitle
   put ide_GetMenuTitle (ideElement) into mTitle
   --
   put ide_GetMenuController (ideElement) into mController
   put menu_GetGlobalController (mTitle) into mController
   --
   edit the script of mController
end menu_TestRecentMenu

on menu_ReindexIdeMenu
   ide_ReIndexMenus
end menu_ReindexIdeMenu

on _
end _

on menu_RevealLocalProjects indexView
   put env_ListLocalProjects() into projectNames
   put env_GetRepoFolder() into repoFolder
   --
   set the displayed_Index of indexView to projectNames
   finder_Reveal repoFolder
end menu_RevealLocalProjects

on menu_DisplayGlobalMenus
   display_EnvironmentMenus
end menu_DisplayGlobalMenus

on menu_ReIndexAllProjectMenus indexView
   -- put the displayed_Index of indexView into projectNames
   put env_ListLocalProjects() into projectNames
   --
   repeat for each line projectName in projectNames
      set the cursor to busy
      if exists (stack projectName) is false then
         put empty into badArray [projectName]
         next repeat
      end if
      
      put project_GetFolder (projectName) into projectFolder
      --
      project_ExportMenusAndStackFiles projectFolder
      put the result into projectArray
      --
      put projectArray into goodArray [projectName]["projectArray"]
      put projectFolder into goodArray [projectName]["projectFolder"]
   end repeat
   --
   lcw_Answer "Indexed all these projects, and found these bad projects"
   --
   put keys (goodArray) into goodIndex
   sort goodIndex
   set the displayed_Index of indexView to goodIndex
   --
   display_BadProjectArray badArray
end menu_ReIndexAllProjectMenus
