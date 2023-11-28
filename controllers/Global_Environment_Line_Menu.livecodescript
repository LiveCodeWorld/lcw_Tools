script "Global | Environment | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Environment | Line | Menu
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
   put the selected_Line of tObject into projectName
   --
   put git_ProjectIsClean (projectName) into isClean
   put the hilited_Line of tObject into lineNum
   if isClean is true then
      set the line_Colour [lineNum] of tObject to "green"
   else
      set the line_Colour [lineNum] of tObject to "orange"
   end if
   --
   put the display_View of tObject into LocalArray ["displayView"]
   return projectName
end menu_Target

getprop menu_CheckTarget [projectName]
   put exists (stack projectName) into projectExists
   return projectExists
end menu_CheckTarget


--> Global | Environment | Line | Menu
-
on menu_DisplayGitStatus projectName
   display_GitProjectStatus projectName
end menu_DisplayGitStatus

private on _
end _

on submenu_Dev
   return menu_DevTitle ("Global | Environment | Line | Menu")
end submenu_Dev
