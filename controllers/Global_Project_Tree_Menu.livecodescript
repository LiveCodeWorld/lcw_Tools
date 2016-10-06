script "Global_Project_Tree_Menu"
--> MetaData
-
license: GPLv3
name: Global_Project_Tree_Menu
type: controller
version: 0.2


--> Menu | Props
-
/* mTarget should already be set by set the menu_Target of indexView to projectName */


--> Global | Project | Tree | Menu
-
on menu_StartProject projectName, someBoolean
   if someBoolean is true then
      project_Start projectName
   else
      project_Stop projectName
   end if
end menu_StartProject

on menu_ChangeProject projectName, projectChoice
   put library_FetchProjectHomeStackPath (projectChoice) into homeStackPath
   put the project_UsedStackNames of stack homeStackPath into stackNames
   
   lock screen
   put menu_GettargetObject() into tObject
   put the index_View of tObject into indexView
   
   set the view_Index of indexView to stackNames
   set the title_Text of indexView to projectChoice
   put the stack_Object of indexView into stackObject
   set the label of stackObject to "Model and Libraries"
   unlock screen
end menu_ChangeProject


--> Global | Project | Tree | Menu | Props
-
getprop start_Project [projectName]
   return project_IsActive (projectName) is true
end start_Project

getprop project_Choice [indexView]
   put menu_GettargetObject() into tObject
   put the index_View of tObject into indexView
   
   put the title_Text of indexView into displayedProjectName
   return displayedProjectName
end project_Choice

getprop project_Choices
   return library_ListProjectNames()
end project_Choices


