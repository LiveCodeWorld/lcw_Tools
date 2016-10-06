script "Global_Module_Tree_Menu"
--> MetaData
-
license: GPLv3
name: Global_Module_Tree_Menu
type: controllers
version: 0.1


--> Menu | Props
-
getprop menu_Target
   put menu_GetTargetObject() into tObject
   put the index_View of tObject into indexView
   put the displayed_Object of indexView into viewObject
   return viewObject
   
   /*
   put the title_text of tObject into moduleStackName
   put module_NameToFolder (moduleStackName) into moduleFolderName 
   
   put the stack_Object of tObject into stackObject
   put the label of stackObject into projectName
   delete word -1 of projectName
   
   put module_GetHomeStackPath (moduleFolderName, projectName) into moduleHomeStackPath
   if exists (control 1 of cd 1 of stack moduleHomeStackPath) is false then
      breakpoint
      return empty
   end if
   put the long id of control 1 of cd 1 of stack moduleHomeStackPath into viewObject
   */
end menu_Target


--> Global | Module | Tree | Menu
-
on submenu_Module
   return "Global | Module | Menu"
end submenu_Module

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_ModuleInfo someView
   -- put menu_GetTargetObject() into tObject
   -- put the index_View of tObject into indexView
   put the module_Array of someView into moduleArray
   put moduleArray ["viewName"] into viewName
   put merge ("[[viewName]],Module Array") into someTitle
   display_Array moduleArray, someTitle
end menu_ModuleInfo

on menu_EditMenus
   menu_Edit "Global | View | Card | Tools | Menu"
   menu_Edit "Global | View | Card | Create | Menu"
end menu_EditMenus


-- > Global | Module | Tree | Menu | Props
-


--> Global | Module | Tree | Line | Menu
-
on menu_ViewProperty someView
   put menu_GetTargetObject() into tObject
   put the index_View of tObject into indexView
   
   put the displayed_Object of indexView into someView
   -- put the title_Text of indexView into moduleFolderName
   put the selected_Index of indexView into viewProp
   
   put the viewProp of someView
end menu_ViewProperty


--> Global | Modules | Tree | Menu
-
on menu_CreateModule indexView
   put the title_Text of indexView into moduleShortFolder
   
   put "Choose a name for your new module...." into someQuestion
   put the clipboarddata ["text"] into suggestedAnswer
   set the itemdelimiter to "|"
   if item 1 of suggestedAnswer is not "View" then
      put "View|Test" into suggestedAnswer
   end if
   put lcw_Ask (someQuestion, suggestedAnswer) into moduleStackName
   
   put project_GetFolder (moduleShortFolder) into projectFolder
   put project_ConstructFolder ("modules", projectFolder) into rootModuleFolder
   project_CreateModule moduleStackName, rootModuleFolder
end menu_CreateModule

on _
end _

on menu_Refresh indexView
   put the title_Text of indexView into projectHomeStackName
   display_ProjectModules projectHomeStackName, indexView
end menu_Refresh

on menu_CheckModules indexView
   put the title_Text of indexView into projectName
   put the view_Index of indexView into moduleNames
   
   repeat for each line moduleName in moduleNames
      put the long id of control 1 of cd 1 of stack moduleName into templateView
      dispatch "view_FixBehavior" to templateView with templateView
      go to stack moduleName
   end repeat
end menu_CheckModules
