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


--> Menu | Props
-

--> Global | Environment | Dev | Menu
-
on submenu_Install
   return "Global | Install | Menu"
end submenu_Install

private on _
end _

on submenu_Server
   return "Global | Environment | Server | Menu"
end submenu_Server

on submenu_TransportServer
   return "Global | Transport | Model | Menu"
end submenu_TransportServer

on submenu_Atopia
   return "Global | Environment | Atopia | Menu"
end submenu_Atopia

on menu_FederationModels
   display_FederationModels
end menu_FederationModels

on menu_FederationTools
   put fedray_FetchModel() into fedray
   display_Tools fedray, "Federation Model", "Federation", "LCW", "lcw_Server"
end menu_FederationTools

-- on menu_ServerTools
   display_Tools someData, "Federation Servers", "Federation | Server", "LCW", "lcw_Server"
end menu_ServerTools

on __
end __

on _Refresh
   display_Environment
end _Refresh

on submenu_Prefs
   return "Global | Pref | Menu"
end submenu_Prefs

on _
end _

on menu_DisplayExportedScript indexView, mainStackName
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
