script "Global | Github | Projects | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Github | Projects | Line | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   put the display_View of tObject into LocalArray ["dView"]
   put the displayed_Object of tObject into sObject
   return sObject
end menu_Target

private function _dView
   return LocalArray ["dView"]
end _dView

getprop menu_CheckTarget [dView]
   return exists (dView)
end menu_CheckTarget

on mDoubleUp_GithubProjects dView, repoName
   put _RepoFolder (dView) into repoFolder
   put env_GetRepoFolder (repoName) into repoFolder
   finder_Reveal repoFolder
end mDoubleUp_GithubProjects

private function _RepoFolder dView
   put the selected_Line of dView into repoName
   put env_GetRepoFolder (repoName) into repoFolder
   return repoFolder
end _RepoFolder


--> Global | Github | Projects | Line | Menu
-
on menu_DownloadGithubRepo dView
   put the title_text of dView into orgName
   put the selected_Line of dView into repoName
   --
   lcw_Answer "Clone LiveCodeWorld repo '[[repoName]] from Github to your local environment folder?", dView, repoName
   gh_CloneOrgRepo repoName, orgName
   --
   menu_RevealRepoFolder dView
end menu_DownloadGithubRepo

getprop disabled_DownloadGithubRepo [dView]
   put _RepoFolder (dView) into repoFolder
   return there is a folder repoFolder
end disabled_DownloadGithubRepo

getprop checked_DownloadGithubRepo [dView]
   put _RepoFolder (dView) into repoFolder
   return there is a folder repoFolder
end checked_DownloadGithubRepo

private on _
end _

on menu_RevealRepoFolder dView
   put _RepoFolder (dView) into repoFolder
   finder_Reveal repoFolder
end menu_RevealRepoFolder

private on __
end __

on submenu_Dev
   return menu_DevTitle ("Global | Github | Projects | Line | Menu")
end submenu_Dev

