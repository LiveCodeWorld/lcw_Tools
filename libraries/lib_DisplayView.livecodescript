script "lib_DisplayView"
--> MetaData
-
license: GPLv3
name: lib_DisplayView
type: library
version: 0.3


--> Working on
-

--> Display | Events
-
on mDouble_DisplayStack indexView, stackName
   switch
      case exists (stack stackName) is false
         answer merge("Could not find stack '[[stackName]]'.")
         break
      case the scriptonly of stack stackName is true
         edit the script of stack stackName
         break
      default
         go to stack stackName
   end switch
end mDouble_DisplayStack


--> Display | Project | Views
-
command display_View viewObject, pIndexView
   put the view_Props of viewObject into viewProps
   
   put the view_Name of viewObject into viewName
   put menu_ConstructViewMenu (viewObject, true) into mTitle
   put viewName & comma & "View" into stackTitle
   
   put "Global | Module | Tree | Line | Menu" into mLineTitle
   put empty into mUp
   put "mDouble_EditProp" into mDoubleUp
   put empty into pDragCommand
   
   if exists (pIndexView) is false then
      display_Index viewProps, stackTitle, mTitle, mLineTitle, mUp, mDoubleUp, pDragCommand, true
      put the result into indexView
      set the multiple_Hilites of indexView to false
   else
      lock screen
      set the view_Index of pIndexView to viewProps
      set the stack_Title of pIndexView to stackTitle
      set the mouse_DoubleUpEvent of pIndexView to mDoubleUp
      set the title_Menu of pIndexView to mTitle
      set the line_Menu of pIndexView to mLineTitle
      unlock screen
      return pIndexView
   end if  
   set the displayed_Object of indexView to viewObject
   set the displayed_ViewName of indexView to viewName
   -- set the displayed_ModuleFolder of indexView to moduleFolder
   -- set the displayed_ModuleName of indexView to moduleFolderName
   -- set the displayed_ModuleHomeStackPath of indexView to moduleHomeStackPath
   -- set the displayed_ProjectName of indexView to projectName
   -- set the displayed_ProjectFolder of indexView to projectFolder
   return indexView
end display_View

command display_ViewBehaviors viewObject, pIndexView
   put the view_Behaviors of viewObject into bObjects
   
   put LocalArray ["moduleName"] into moduleName
   put the view_Name of viewObject into viewName
   put viewName & ",view_Behaviors" into stackTitle
   
   if exists (pIndexView) then
      set the view_Index of pIndexView to bObjects
      put pIndexView into indexView
      
      -- set the displayed_ProjectName of indexView to the project_Name of viewObject
      -- set the displayed_ProjectFolder of indexView to the project_Folder of viewObject
      set the displayed_ModuleFolder of indexView to the module_Folder of viewObject
      set the displayed_ModuleName of indexView to the module_Name of viewObject
      set the displayed_ModuleHomeStackPath of indexView to the module_HomeStackpath of viewObject
   else
      display_Lines bObjects, stackTitle, "mDoubleUp_EditBehavior", moduleName
      put the result into indexView
      
      set the title_Menu of indexView to "Global | View | Behavior | Menu"
      set the line_Menu of indexView to "Global | View | Behavior | Line | Menu"
      
      set the displayed_ProjectName of indexView to LocalArray ["projectName"]
      set the displayed_ProjectFolder of indexView to LocalArray ["projectFolder"]
      set the displayed_ModuleFolder of indexView to LocalArray ["moduleFolder"]
      set the displayed_ModuleName of indexView to LocalArray ["moduleName"]
      set the displayed_ModuleHomeStackPath of indexView to LocalArray ["moduleHomeStackPath"]   
   end if
   
   put the behavior of viewObject into bObject
   repeat with lineNum =1 to the number of lines of bObjects
      put line lineNum of bObjects into cObject
      put exists (cObject) is false into notThere
      switch
         case notThere and cObject = bObject
            set the line_Colour [lineNum] of indexView to "purple"
            break
         case cObject = bObject
            set the line_Colour [lineNum] of indexView to "green"
            break
         case notThere
            set the line_Colour [lineNum] of indexView to "red"
            break
      end switch
   end repeat
   
   set the displayed_Object of indexView to viewObject
end display_ViewBehaviors

-- command display_ViewBehaviors viewObject
   put the view_Behaviors of viewObject into bObjects
   
   put LocalArray ["moduleName"] into moduleName
   display_Lines bObjects, "view_Behaviors", "mDoubleUp_EditBehavior", moduleName
   put the result into indexView
   
   repeat with lineNum =1 to the number of lines of bObjects
      put line lineNum of bObjects into bObject
      if exists (bObject) is false then
         put lineNum & comma after lineNumList
      end if
   end repeat
   delete char -1 of lineNumList
   if lineNumList is not empty then
      set the line_Colour [lineNumList] of indexView to "red"
   end if
   
   put the behavior of viewObject into bObject
   put lineOffset (bObject, bObjects) into lineNum
   set the line_Colour [lineNum] of indexView to "green"
   
   set the displayed_Object of indexView to viewObject
   set the title_Menu of indexView to "Global | View | Behavior | Menu"
   set the line_Menu of indexView to "Global | View | Behavior | Line | Menu"
   
   set the displayed_ProjectName of indexView to LocalArray ["projectName"]
   set the displayed_ProjectFolder of indexView to LocalArray ["projectFolder"]
   set the displayed_ModuleFolder of indexView to LocalArray ["moduleFolder"]
   set the displayed_ModuleName of indexView to LocalArray ["moduleName"]
   set the displayed_ModuleHomeStackPath of indexView to LocalArray ["moduleHomeStackPath"]   
end display_ViewBehaviors

command display_NestedViewArray viewObject
   put the view_NestedArray of viewObject into nestedViewArray
   
   put the view_Name of viewObject into viewName
   put menu_ConstructViewMenu (viewObject, true) into mTitle
   put viewName & comma & "view_NestedArray" into stackTitle
   
   display_Array nestedViewArray, stackTitle, mTitle
   put the result into arrayView
   
   set the displayed_Object of arrayView to viewObject
   set the displayed_ViewName of arrayView to viewName
   
   return arrayView
end display_NestedViewArray

command display_ProjectViews projectName
   put project_ListViewStackNames (projectName) into stackNames
   put merge ("[[projectName]],Views") into someTitle
   
   local mLineTitle, mUp
   display_Index stackNames, someTitle, "Global | Views | Tree | Menu", mLineTitle, mUp, "mDouble_DisplayStack"
   put the result into indexView
   set the multiple_Hilites of indexView to false
end display_ProjectViews

command display_ActiveViews pIndexView
   put env_ListViewStackNames() into activeViewStackNames
   
   put "Active Views,Environment" into stackTitle
   put "mDouble_DisplayStack" into mDoubleUp
   
   put empty into mUp
   put "Global | Environment | Menu" into mTitle
   put "Global | Project | Tree | Line | Menu" into mLineTitle
   
   if exists (pIndexView) is false then
      display_Index activeViewStackNames, stackTitle, mTitle, mLineTitle, mUp, mDoubleUp
      put the result into displayView
      return displayView
   else
      lock screen
      set the view_Index of pIndexView to activeViewStackNames
      set the stack_Title of pIndexView to stackTitle
      set the mouse_DoubleUpEvent of pIndexView to mDoubleUp
      set the title_Menu of pIndexView to mTitle
      set the line_Menu of pIndexView to mLineTitle
      unlock screen
      return pIndexView
   end if
end display_ActiveViews


--> Deps
-
function menu_ConstructViewMenu viewObject, isaView
   put the view_MenuTitle [true] of viewObject into mTitle
   put CR & "-" after mTitle
   if isaView is not false then
      put CR & "Global | Module | Menu" & tab & "submenu" after mTitle
      put CR & "-" after mTitle
      put CR & "Global | View | Authoring | Menu" & tab & "submenu" after mTitle
      put CR & "Global | View | Script | Menu" & tab & "submenu" after mTitle
      put CR & "Global | View | Property | Menu" & tab & "submenu" after mTitle
      put CR & "Global | View | Geometry | Menu" & tab & "submenu" after mTitle
      -- put CR & "Global | Behavior | View | Menu" & tab & "submenu" after mTitle
      put CR &  "Global | View | Update | Menu" & tab & "submenu" after mTitle
   else
      put CR & "Global | Module | Menu" & tab & "submenu" after mTitle
   end if
   return mTitle
end menu_ConstructViewMenu

