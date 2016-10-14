script "Global_Controllers_Tree_Line_Menu"
--> MetaData
-
license: GPLv3
name: Global_Controllers_Tree_Line_Menu
type: controller
version: 0.1


--> Global | Controllers | Tree | Line | Menu
-
on menu_MoveStack indexView, newProjectName
   put the selected_Index of indexView into stackName
   put the name of stack stackName into stackObject
   
   put the project_Name of stackObject into oProjectName
   if oProjectName = newProjectName then
      answer warning merge ("Stack is already in project '[[newProjectName]]'. Choose a new project to move this library to!")
      exit to top
   end if
   
   project_MoveLibrary stackObject, newProjectName
   
   display_ProjectControllers newProjectName, indexView
end menu_MoveStack


--> Global | Controllers | Tree | Line | Menu | Props
-
getprop new_ProjectName [indexView]
   put the selected_Index of indexView into stackName
   put the project_Name of stack stackName into projectName
   return projectName
end new_ProjectName

getprop new_ProjectNames
   return library_ListProjectNames()
end new_ProjectNames

