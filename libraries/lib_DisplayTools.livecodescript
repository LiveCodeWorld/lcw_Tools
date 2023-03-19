script "lib_DisplayTools"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: lib_DisplayTools
type: library
version: 0.1

/*
This stack is for displaying tools that go with views.
Their should be an easy default, with teh ability to customise.
*/


--> Display | Template
-
command display_ViewTemplate viewName, pRepoFolder
   -- go_ViewTemplate
   put view_GetTemplateObject (viewName, pRepoFolder) into viewObject
   object_GoTo viewObject
   return viewObject
end display_ViewTemplate


--> Display | Tools
-
on display_ModuleTools stackName
   if exists (stack stackName) is false then
      return "Error, cannot locate stack:" && stackName
   end if
   
   put the short name of stack stackName into stackName -- in case it's a stackPath
   put the module_Folder of stack stackName into moduleFolder
   put directory_NestedArray (moduleFolder) into dArray
   --
   display_Data dArray, stackName, "Module Tools"
   put the result into displayView
   --
   set the displayed_ModuleFolder of displayView to moduleFolder
   --
   _SetModuleToolsMenus stackName, displayView
   return displayView
end display_ModuleTools

private command _SetModuleToolsMenus stackName, displayView
   if exists (control 1 of cd 1 of stack stackName) is false then return false
   
   put the long id of control 1 of cd 1 of stack stackName into viewObject   
   set the displayed_Object of displayView to viewObject
   --
   put view_ConstructToolMenu (viewObject, true) into mTitles
   set the itemdelimiter to tab
   put item 1 of line 1 of mTitles into mTitle
   --
   if menu_GlobalControllerExists (mTitle) is false then
      put "Global | Module | Tree | Menu" into line 1 of mTitles
      display_SetInteractions displayView, "Module | Tree", "mDouble_EditProp"
   else
      set the title_Menu of displayView to mTitles
      set the line_Menu of displayView to "Global | Module | Tree | Line | Menu"
      set the mouse_DoubleUp of displayView to "mDouble_EditProp"
   end if
   return true
end _SetModuleToolsMenus

command display_ModuleToolScripts moduleName, projectName
   -- put library_FetchProjectFolder (projectName) into projectFolder
   put env_ConstructProjectFolder (projectName) into projectFolder
   --
   put module_ListBehaviorStackNames (moduleName, projectFolder) into behaviorStackNames
   repeat for each line behaviorStackName in behaviorStackNames
      edit the script of stack behaviorStackName
   end repeat
   put module_ListControllerStackNames (moduleName, projectFolder) into controllerStackNames
   repeat for each line controllerStackName in controllerStackNames
      edit the script of stack controllerStackName
   end repeat
end display_ModuleToolScripts


--> Display | Tools
-
command display_StackTools stackName, pMenuBit, pData, pDoubleUp
   if exists (stack stackName) is false then return empty
   if pMenuBit is empty then
      put stackName into pMenuBit
      replace space with empty in pMenuBit
   end if
   if pData is empty then put the cardnames of stack stackName into pData
   if pDoubleUp is empty then put "mDoubleUp_GoToCard" into pDoubleUp
   --
   put the name of stack stackName into stackObject
   display_ObjectTools stackObject, pData, stackName, "Stack Tools", pMenuBit, pDoubleUp
   return the result
end display_StackTools

command display_ToolStack viewObject, pMenuTitle, pDoubleUp
   put the view_Name of viewObject into vName
   put the view_Props of viewObject into viewProps
   --
   put vName into menuBit
   set the itemdelimiter to "|"
   if word 1 to -1 of item 1 of menuBit = "View" then delete item 1 of menuBit
   menu_NormalizeTitle menuBit
   --
   display_ObjectTools viewObject, viewProps, vName, "View Tools", menuBit, pDoubleUp
   return the result
end display_ToolStack

command display_ObjectTools sObject, someData, sTitle, sLabel, menuBit, pDoubleUp
   display_Data someData, sTitle, sLabel
   put the result into displayView
   display_SetInteractions displayView, menuBit, pDoubleUp
   set the displayed_Object of displayView to sObject
   return displayView
end display_ObjectTools


--> Display | View | Tools
-
command display_ViewTools viewName, pRepoFolder
   -- see display_ModuleTools
   put view_GetTemplateObject (viewName, pRepoFolder) into viewObject
   if exists (viewObject) is false then throw "Error, no template object found for:" && viewName
   --
   put the view_Props of viewObject into viewProps
   
   display_Data viewProps, viewName, "View Tools"
   put the result into displayView
   --
   put view_ConstructToolMenu (viewObject, true) into mTitles
   put line 1 of mTitles into mTitle
   set the title_Menu of displayView to mTitles
   set the line_Menu of displayView to "Global | Module | Tree | Line | Menu"
   set the mouse_DoubleUp of displayView to "mDouble_EditProp"
   --
   -- set the multiple_Hilites of displayView to false
   
   set the itemdelimiter to slash
   put the project_Name of stack viewName into projectName
   put the project_Folder of stack viewName into projectFolder
   -- put the original_ModuleName of viewObject into moduleName
   
   set the displayed_Object of displayView to viewObject
   set the displayed_ProjectName of displayView to projectName
   set the displayed_ProjectFolder of displayView to projectFolder
   --
   return displayView
end display_ViewTools


--> Display | Events
-
on mDoubleUp_GoToCard displayView, cardName
   put the displayed_Object of displayView into stackObject
   put the title_Text of displayView into stackName
   --
   go to cd cardName of stack stackName
end mDoubleUp_GoToCard
