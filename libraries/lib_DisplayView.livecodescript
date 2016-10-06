script "lib_DisplayView"
--> MetaData
-
license: GPLv3
name: lib_DisplayView
type: libraries
version: 0.2


--> Working on
-

--> Display | Events
-
on mDouble_DisplayModule indexView, moduleStackName
   if exists (stack moduleStackName) is false then
      answer merge("Could not find stack '[[moduleStackName]]'.")
      exit to top
   end if
   
   put the module_Folder of stack moduleStackName into moduleFolder
   display_Module moduleFolder
end mDouble_DisplayModule

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

on mDouble_EditProp indexView, hName
   -- put the title_Text of indexView into moduleFolderName
   put the displayed_Object of indexView into viewObject
   put the behavior of viewObject into viewBehavior
   
   -- put revRuggedID (hObject) into hObject
   put "G" && hName into shortHkeyLine
   put hKeyLine_Construct (shortHkeyLine, viewBehavior) into hkeyLine
   
   hkey_Edit hkeyLine
end mDouble_EditProp


--> Display | Project | Views
-
command display_ProjectViews projectName
   put project_ListViewStackNames (projectName) into stackNames
   put merge ("[[projectName]],Views") into someTitle
   
   local mLineTitle, mUp
   display_Index stackNames, someTitle, "Global | Views | Tree | Menu", mLineTitle, mUp, "mDouble_DisplayStack"
   put the result into indexView
   set the multiple_Hilites of indexView to false
end display_ProjectViews


--> Display | View | Behavior
-
command display_BrokenBehaviors pCardObject, pDisplayArray
   if pCardObject is empty then put the long id of this card into pCardObject 
   
   put the behavior_BrokenArray of pCardObject into testArray
   
   if pDisplayArray is true then
      put "Views with behaviors,Fixed behaviors" into someTitle
      put comma & the name of pCardObject after someTitle
      display_Array testArray, someTitle, "Global | Display | Behaviors | Menu", "Global | Display | Behaviors | Line | Menu"
      put the result into displayView
      set the displayed_Object of displayView to pCardObject
      set the view_Data ["behavior_Target"] of displayView to pCardObject
   end if
   return testArray
end display_BrokenBehaviors


--> Display | Project | Modules
-
command display_ProjectControllers homeStackName, pIndexView
   put project_ListControllerPaths (homeStackName) into controllerPaths
   put stack_PathsToNames (controllerPaths) into stackNames
   
   put merge ("[[homeStackName]],Project Controllers") into someTitle
   display_Index stackNames, someTitle, "Global | View | Tree | Menu", mLineTitle, mUp, "mDouble_DisplayStack"
end display_ProjectControllers

command display_ProjectBehaviors homeStackName, pIndexView
   put project_ListBehaviorPaths (homeStackName) into behaviorPaths
   put stack_PathsToNames (behaviorPaths) into stackNames
   
   put merge ("[[homeStackName]],Project Behaviors") into someTitle
   display_Index stackNames, someTitle, "Global | View | Tree | Menu", mLineTitle, mUp, "mDouble_DisplayStack"
end display_ProjectBehaviors

command display_ProjectStacks homeStackName, pIndexView
   put project_ListStackPaths (homeStackName) into stackPaths
   put stack_PathsToNames (stackPaths) into stackNames
   
   put merge ("[[homeStackName]],Project Stacks") into someTitle
   display_Index stackNames, someTitle, "Global | View | Tree | Menu", mLineTitle, mUp, "mDouble_DisplayStack"
end display_ProjectStacks

command display_ProjectModules homeNameOrPath, pIndexView
   put the short name of stack homeNameOrPath into projectHomeStackName
   
   put project_ListModuleHomeStackNames (projectHomeStackName) into moduleStackNames
   
   put empty into mUp
   put "mDouble_DisplayModule" into mDoubleUp
   put "Modules" into stackTitle
   put projectHomeStackName & comma & stackTitle into someTitle
   
   put "Global | Modules | Tree | Menu" into mTitle
   put "Global | Modules | Tree | Line | Menu" into mLineTitle
   
   if exists (pIndexView) is false then
      display_Index moduleStackNames, someTitle,mTitle, mLineTitle, mUp, mDoubleUp
      put the result into indexView
      set the multiple_Hilites of indexView to false
      return indexView
   else
      lock screen
      set the view_Index of pIndexView to moduleStackNames
      set the stack_Title of pIndexView to someTitle
      set the mouse_DoubleUpEvent of pIndexView to mDoubleUp
      set the title_Menu of pIndexView to mTitle
      set the line_Menu of pIndexView to mLineTitle
      unlock screen
      return pIndexView
   end if
end display_ProjectModules

command display_ModuleFromName moduleName, projectName
   put module_ViewNameToShortFolder (moduleName) into moduleFolderName 
   put library_FetchProjectFolder (projectName) into projectFolder
   put module_GetFolder (moduleFolderName, projectFolder) into moduleFolder
   
   display_Module moduleFolder
end display_ModuleFromName

command display_Module moduleFolder
   put project_ConstructHomeStackPath (moduleFolder) into moduleHomeStackPath
   if moduleHomeStackPath is empty then
      put moduleFolder
      answer warning "Cannnot locate a module in this folder!"
      exit to top
   end if
   
   set the itemdelimiter to slash
   put project_GetName (moduleFolder) into moduleFolderName
   put item 1 to -3 of moduleFolder into projectFolder
   put project_GetName (projectFolder) into projectName
   put merge ("[[moduleFolderName]],[[projectName]] Module") into someTitle
   
   go to stack moduleHomeStackPath
   
   if exists (control 1 of cd 1 of stack moduleHomeStackPath) is true then
      put the long id of control 1 of cd 1 of stack moduleHomeStackPath into viewObject
      put the view_Props of viewObject into viewProps
      put the view_MenuTitle [true] of viewObject into mTitle
      put CR & "-" after mTitle
   else
      -- the stack exists but ther is no viewObject
      put the long id of cd 1 of stack moduleHomeStackPath into viewObject
      put empty into viewProps
      put the short name of stack moduleHomeStackPath into viewTitle
   end if
   
   put CR & "Global | Module | Menu" & tab & "submenu" after mTitle
   put CR & "-" after mTitle
   put CR & "Global | View | Authoring | Menu" & tab & "submenu" after mTitle
   put CR & "Global | View | Property | Menu" & tab & "submenu" after mTitle
   put CR & "Global | View | Script | Menu" & tab & "submenu" after mTitle
   put CR & "Global | View | Geometry | Menu" & tab & "submenu" after mTitle
   -- put CR & "Global | Behavior | View | Menu" & tab & "submenu" after mTitle
   put CR &  "Global | View | Update | Menu" & tab & "submenu" after mTitle
   
   put empty into mLineTitle
   put empty into mUp
   
   display_Index viewProps, someTitle, mTitle, "Global | Module | Tree | Line | Menu", mUp, "mDouble_EditProp"
   put the result into indexView
   set the multiple_Hilites of indexView to false
   set the displayed_Object of indexView to viewObject
   
   put the script of cd 1 of stack moduleHomeStackPath into cardScript
   if cardScript is not empty then
      edit the script of cd 1 of stack moduleHomeStackPath
   end if
   module_EditToolScripts moduleHomeStackPath, projectName
end display_Module


--> Dpes
-
command module_EditToolScripts moduleName, projectName
   put library_FetchProjectFolder (projectName) into projectFolder
   put module_ListBehaviorStackNames (moduleName, projectFolder) into behaviorStackNames
   repeat for each line behaviorStackName in behaviorStackNames
      edit the script of stack behaviorStackName
   end repeat
   put module_ListControllerStackNames (moduleName, projectFolder) into controllerStackNames
   repeat for each line controllerStackName in controllerStackNames
      edit the script of stack controllerStackName
   end repeat
end module_EditToolScripts

command stack_FixBrokenBehaviors stackName
   local searchArray
   search_Stack stackName, "behavior", searchArray
   put keys (searchArray) into foundBehaviors
   repeat for each line foundBehavior in foundBehaviors
      put searchArray [foundBehavior] into objectsWithBehavior
      repeat for each line someObject in objectsWithBehavior
         set the cursor to busy
         if exists(someObject) is false then
            -- should not be possible
            breakpoint
            put searchArray [foundBehavior] into displayArray ["impossible error"][foundBehavior]
            next repeat
         end if
         
         if exists (foundBehavior) is false then
            -- probably not in stackfiles
            put searchArray [foundBehavior] into displayArray ["behavior does not exist"][foundBehavior]
            next repeat
         end if
         
         set the behavior of someObject to foundBehavior
         put searchArray [foundBehavior] into displayArray ["good behavior"][foundBehavior]
      end repeat
   end repeat
   return displayArray
end stack_FixBrokenBehaviors

getprop behavior_BrokenArray
   put the card_Object of the target into pCardObject
   
   put the rugged_Views of pCardObject  into ruggedViews
   put the stack_Name of pCardObject  into stackName
   
   set the defaultstack to stackName
   repeat for each line ruggedView in ruggedViews
      put the name of ruggedView into namedRuggedView
      put the behavior of ruggedView into bObject
      switch
         case bObject is empty
            put namedRuggedView into testArray ["empty"][bObject]
            break
         case exists (bObject)
            put namedRuggedView into testArray ["exists"][bObject]
            set the behavior of ruggedView to bObject
            break
         default
            -- behavior exists and is broken
            put namedRuggedView into testArray ["exists and is broken"][bObject]
      end switch
   end repeat
   return testArray
end behavior_BrokenArray


