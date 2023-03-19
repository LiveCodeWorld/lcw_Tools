script "Global | Environment | Display | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Environment | Display | Menu
type: controller
version: 0.1

/*
Here you can describe this menu.
Full help text should be provided on the linked wiki.
*/

--> Variables
-
local LocalArray


--> Menu | Init
-

--> Global | Environment | Display | Menu
-
on menu_EnvironmentLibs
   display_EnvironmentLibs
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

on menu_DisplayTransporters
   display_Transporters
end menu_DisplayTransporters

on menu_LiveCodeWorldRepos
   display_GithubOrgRepos
end menu_LiveCodeWorldRepos

on menu_GithubProjects
   display_GithubProjects
end menu_GithubProjects

on menu_GithubOrgs
   display_GitHubOrgs
end menu_GithubOrgs
