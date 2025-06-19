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
-- getprop menu_CheckTarget [projectName]
   put exists (stack projectName) into projectExists
   if projectExists is false then
      -- breakpoint
      return true
   else
      return true
   end if
end menu_CheckTarget

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


--> Events
-
on mDoubleUp_Environment displayView, projectName
   switch
      case the title_Text of displayView = "Not Up-to-Date"
      case the shiftKey is "Down" 
         project_Start projectName
         display_GitProjectStatus projectName
         -- display_Project projectName
         display_Environment
         break
      default
         if env_ProjectIsActive (projectName) is false then
            project_Start projectName
            display_Environment true
         end if
         display_Project projectName
   end switch
end mDoubleUp_Environment


--> Global | Environment | Line | Menu
-
on insert_EnvLineMenu
   return "Global | Environment | Tree | Line | Menu"
end insert_EnvLineMenu

private on _
end _

on menu_EditLineMenu
   edit the script of me
end menu_EditLineMenu
