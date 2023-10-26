script "Global | Environment | Tree | Line | Dev | Menu"
--> MetaData
-
license: GPLv3
name: Global | Environment | Tree | Line | Dev | Menu
type: controller
author: David Bovill
version: 0.1

/*
Here you can describe this menu.
Full help text should be provided on the linked wiki.
*/

--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   put the selected_Line of tObject into projectName
   return projectName
end menu_Target


--> Global | Environment | Tree | Line | Dev | Menu
-
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

