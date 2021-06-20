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
on menu_Init tObject
   put the selected_Line of tObject into projectName
   put the hilited_Line of tObject into lineNum
   put the line_Colour [lineNum] of tObject into LocalArray ["oColour"]
   --
   put git_ProjectIsClean (projectName) into isClean
   if isClean is true then
      set the line_Colour [lineNum] of tObject to "green"
   end if
end menu_Init

getprop menu_Target [tObject]
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


--> Global | Environment | Tree | Line | Menu
-
on menu_DisplayProject projectName
   display_ProjectLibs projectName
end menu_DisplayProject

on menu_DisplayGitStatus projectName
   display_GitProjectStatus projectName
end menu_DisplayGitStatus

on _
end _

on menu_StartProject projectName
   project_Start projectName, true
end menu_StartProject

on menu_StopProject projectName
   project_Stop projectName
end menu_StopProject

on _
end _

on menu_OpenProjectHome projectName
   go to stack projectName
   show stack projectName
end menu_OpenProjectHome

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
getprop checked_AddProjectToLibrary [projectName]
   put project_IsActive (projectName) into someBoolean
   return someBoolean
end checked_AddProjectToLibrary

on menu_AddProjectToLibrary projectName
   -- put project_GetFolder (projectName) into projectFolder
   -- put the project_Folder of stack projectName into projectFolder
   put env_GetProjectFolder (projectName) into projectFolder
   if projectFolder is empty then
      -- put LocalArray ["displayView"] into displayView
      -- lcw_AnswerWarning someQuestion, displayView, pQVar, pQVar2, pQVar3
      answer folder "Select the project folder..."
      put it into projectFolder
      if projectFolder is empty then exit to top
   end if
   
   library_StoreProjectFolder projectName, projectFolder
   --
   finder_Reveal projectFolder
end menu_AddProjectToLibrary

on menu_TestByColouring projectName
   put git_ProjectIsClean (projectName) -- into isClean
   if isClean is true then
      
   end if
end menu_TestByColouring


