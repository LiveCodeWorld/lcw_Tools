script "Global | Environment | Dev | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Environment | Dev | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-

--> Events | Display | Not Needed?
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


--> Global | Environment | Dev | Menu
-
on submenu_Prefs
   return "Global | Pref | Menu"
end submenu_Prefs

on _
end _

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

on menu_DisplayDynadot
   display_Dynadot
end menu_DisplayDynadot

on menu_SetWatchMenu mTarget, shortName
   ide_SetMenuTitle "Recent", "Watch"
   --
   put ide_GetMenuTitle ("Recent") into mTitle
   menu_Edit mTitle
end menu_SetWatchMenu

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
