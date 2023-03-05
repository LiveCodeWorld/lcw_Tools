script "Global | Environment | Tree | Line | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | Environment | Tree | Line | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray


--> Menu | Init
-
getprop menu_Target [tObject]
   put the selected_Line of tObject into projectName
   put the hilited_Line of tObject into lineNum
   put the line_Colour [lineNum] of tObject into LocalArray ["oColour"]
   --
   put git_ProjectIsClean (projectName) into isClean
   if isClean is true then
      set the line_Colour [lineNum] of tObject to "green"
   end if
   --
   put the display_View of tObject into LocalArray ["displayView"]
   put the selected_Line of tObject into projectName
   return projectName
end menu_Target

getprop disabled_StartProject [pName]
   if LocalArray ["oColour"] = "255,0,0" then -- red
      return false
   else
      return "delete"
   end if
end disabled_StartProject

getprop disabled_StopProject [pName]
   if LocalArray ["oColour"] = "255,0,0" then -- red
      return "delete"
   else
      return false
   end if
end disabled_StopProject

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


--> Global | Environment | Tree | Line | Menu
-
on menu_DisplayProject projectName
   display_Project projectName
end menu_DisplayProject

on menu_DisplayProjectLibs projectName
   display_ProjectLibs projectName
end menu_DisplayProjectLibs

private command _
end _

on menu_InitGit projectName
   put the project_Folder of stack projectName into projectFolder
   git_AskInit projectFolder
   --
   display_GitProjectStatus projectName
end menu_InitGit

on menu_DisplayGitStatus projectName
   display_GitProjectStatus projectName
end menu_DisplayGitStatus

private command __
end __

on menu_StartProject projectName
   project_Start projectName, true
end menu_StartProject

on menu_StopProject projectName
   project_Stop projectName
   display_Environment true
end menu_StopProject

private command ___
end ___

on menu_FixProjectStackFiles projectName
   project_FixStackFiles projectName
   put the result into projectArray
   --
   set the cursor to watch
   display_Project projectName, true
   display_EnvironmentMenus true
   display_GitRefreshProjectName projectName
end menu_FixProjectStackFiles

on menu_ScriptOnly projectName
   put the scriptonly of stack projectName into isScriptOnly
   set the scriptonly of stack projectName to isScriptOnly is false
end menu_ScriptOnly

on menu_RevealProjectFolder projectName
   put the project_Folder of stack projectName into projectFolder
   finder_Reveal projectFolder
end menu_RevealProjectFolder


