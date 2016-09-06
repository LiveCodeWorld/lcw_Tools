script "Global_Project_Tree_Line_Menu"
--> MetaData
-
license: GPLv3
name: Global_Project_Tree_Line_Menu
type: controllers
version: 0.1


--> Global | Project | Tree | Line | Menu
-
on menu_DisplayProject indexView
   put the selected_Index of indexView into projectName
   display_ProjectUsed projectName, true
end menu_DisplayProject


--> Global | Project | Tree | Line | Menu | Props
-
