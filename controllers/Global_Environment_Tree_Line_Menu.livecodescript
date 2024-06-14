script "Global | Environment | Tree | Line | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | Environment | Tree | Line | Menu
type: controller
version: 0.2

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray


--> Menu | Init
-
getprop menu_Target [tObject]
   put the selected_Line of tObject into projectName
   --
   put the hilited_Line of tObject into lineNum
   put the line_Colour [lineNum] of tObject into LocalArray ["oColour"]
   --
   put git_ProjectIsClean (projectName) into isClean
   if isClean is true then
      set the line_Colour [lineNum] of tObject to "green"
   end if
   --
   put the display_View of tObject into LocalArray ["displayView"]
   return projectName
end menu_Target

getprop menu_CheckTarget [projectName]
   put env_GetProjectHomePath (projectName) into homeStackPath
   put homeStackPath into LocalArray ["homeStackPath"]
   put exists (stack homeStackPath) into projectExists
   return projectExists
end menu_CheckTarget

getprop checked_StartProject [projectName]
   -- put LocalArray ["oColour"] is not "255,0,0" into isActive -- red
   if exists (Stack "LCW") is false then return false
   put env_ProjectIsActive (projectName) into isActive
   return isActive
end checked_StartProject

getprop disabled_ScriptOnly [projectName]
   if exists (stack projectName) is true then
      return false
   else
      return true
   end if
end disabled_ScriptOnly

getprop checked_ScriptOnly [projectName]
   put the scriptonly of stack projectName into isScriptOnly
   return isScriptOnly
end checked_ScriptOnly

getprop disabled_DisplayProject [projectName]
   if exists (stack projectName) is true then
      return false
   else
      return true
   end if
end disabled_DisplayProject

getprop disabled_DisplayGitStatus [projectName]
   if exists (stack projectName) is true then
      return false
   else
      return true
   end if
end disabled_DisplayGitStatus

getprop disabled_RevealProjectFolder [projectName]
   if exists (stack projectName) is true then
      return false
   else
      return true
   end if
end disabled_RevealProjectFolder

getprop disabled_InitGit [projectName]
   if exists (stack projectName) is true then
      put the git_Folder of stack projectName into gitFolder
      return gitFolder is not empty
   else
      return true
   end if
end disabled_InitGit


--> Global | Environment | Tree | Line | Menu
-
on menu_ProjectHelp projectName
   put project_GetHomeStackPath (projectName) into homeStackPath
   put the help_PageArray of stack homeStackPath into pageArray
   --
   draft_PageArray "project.livecode.world", pageArray
   put the result into wikiView
   return wikiView
end menu_ProjectHelp

on menu_StartProject projectName
   -- put LocalArray ["oColour"] is not "255,0,0" into isActive -- red
   put env_ProjectIsActive (projectName) into isActive
   --
   if isActive is true then
      project_Stop projectName
   else
      project_Start projectName, true
   end if
   display_Environment true
end menu_StartProject

private on _
end _

on menu_LoadProject projectName
   lcw_Notify "Loading projectName '[[projectName]] without dependencies..."
   
   project_Load projectName
end menu_LoadProject

on menu_UpdateProjectArray projectName
   display_UpdateProjectArray projectName
   -- display_ProjectArray projectName, true
end menu_UpdateProjectArray

on menu_DisplayProjectArray projectName
   display_ProjectArray projectName, false
end menu_DisplayProjectArray

private on __
end __

on menu_DisplayProject projectName
   display_Project projectName
end menu_DisplayProject

on menu_DisplayProjectLibs projectName
   display_ProjectLibs projectName
end menu_DisplayProjectLibs

private on ___
end ___

on menu_DisplayProjectArray projectName
   put project_GetHomeStackPath (projectName) into homeStackPath
   put the project_Array of stack homeStackPath
   --
   display_ProjectArray
end menu_DisplayProjectArray

on menu_EditProjectHome projectName
   put project_GetHomeStackPath (projectName) into homeStackPath
   go to stack homeStackPath
   --
   edit the script of stack homeStackPath
end menu_EditProjectHome

on menu_RevealProjectFolder projectName
   put the project_Folder of stack projectName into projectFolder
   finder_Reveal projectFolder
end menu_RevealProjectFolder

on menu_InitGit projectName
   git_AskInit projectName
   --
   display_GitProjectStatus projectName
end menu_InitGit

on menu_DisplayGitStatus projectName
   display_GitProjectStatus projectName
end menu_DisplayGitStatus

private on ____
end ____

on menu_RevealProjectFolder projectName
   put the project_Folder of stack projectName into projectFolder
   finder_Reveal projectFolder
end menu_RevealProjectFolder

on submenu_Dev
   return menu_DevTitle ("Global | Environment | Tree | Line | Menu")
end submenu_Dev
