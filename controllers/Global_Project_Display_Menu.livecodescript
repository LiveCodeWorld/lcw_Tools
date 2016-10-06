script "Global_Project_Display_Menu"
--> MetaData
-
license: GPLv3
name: Global_Project_Display_Menu
type: controller
version: 0.2


--> Global | Project | Display | Menu
-
on menu_DisplayLibraries homeStackName
   put menu_GetTargetObject() into tObject
   put the index_View of tObject into indexView
   display_Libraries indexView, homeStackName
   return empty
end menu_DisplayLibraries

on menu_DisplayUsed homeStackName
   display_Project homeStackName, false
   return empty
end menu_DisplayUsed

on menu_DisplayViews homeStackName
   display_ProjectViews homeStackName
   return empty
end menu_DisplayViews

on menu_DisplayMenus homeStackName
   display_ProjectControllers homeStackName
end menu_DisplayMenus

on _
end _

on menu_DisplayModules homeStackName
   display_ProjectModules homeStackName
   return empty
end menu_DisplayModules

on menu_DisplayBehaviors homeStackName
   display_ProjectBehaviors homeStackName
end menu_DisplayBehaviors

on menu_DisplayStacks homeStackName
   display_ProjectStacks homeStackName
end menu_DisplayStacks

on _
end _

on menu_DisplayProjectFolder homeStackName
   put the project_Folder of stack homeStackName into projectFolder
   if there is not a folder projectFolder then
      answer warning "Cannot find project folder!"
      put projectFolder
      exit to top
   end if
   
   finder_Reveal projectFolder
end menu_DisplayProjectFolder




--> Global | Project | Display | Menu | Props
-

--> Global | Project | Display | Menu | Disabled
-
