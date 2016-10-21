script "Global_Controllers_Tree_Menu"
--> MetaData
-
license: GPLv3
name: Global_Controllers_Tree_Menu
type: controller
version: 0.1


--> Global | Controllers | Tree | Menu
-
on menu_CreateProjectMenu indexView
   put the title_Text of indexView into projectName
   menu_Do "menu_CreateProjectMenu", "Global | Project | Create | Menu", projectName
end menu_CreateProjectMenu

on _
end _

on menu_Refresh indexView
   put the title_Text of indexView into projectName
   display_ProjectControllers projectName, indexView
end menu_Refresh
