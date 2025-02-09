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

--> Working on
-
command ask_CreateTreeFieldMenu lineTitle
   breakpoint
   put the tool_LibName of the target into libName
   ask_CreateMenuFromObject lineTitle, libName
end ask_CreateTreeFieldMenu


--> Ask | Create
-
command ask_CreateMenuFromObject gMenuTitle, libName, pControllerScript, pDisplay
   -- as this handler is called for most display creation code 
   -- we are careful and do a lot of checks before creating
   -- but we need to be fast in rejecting searches where we know that we dont need to create a menu as it already exists
   
   # Return mController (fast)
   if there is a stack gMenuTitle then return merge ("Error, not creating menu as stack '[[gMenuTitle]]' already exits!")
   put menu_GetGlobalController (gMenuTitle) into mController -- usually a stackObject
   if exists (mController) then return merge ("Error, not creating menu as '[[mController]]' already exits!")
   
   # Project name from library name
   if exists (stack libName) is false then
      -- put debug_CallingObject (1) into libObject
      -- put the project_Name of libObject into projectName
      put "lcw_Tools" into projectName
   else
      put the project_Name of stack libName into projectName
   end if
   
   # Check path in case file not loaded
   put the project_Folder of stack projectName into projectFolder
   if there is not a folder projectFolder then return "Error, no project_Folder:" && projectFolder
   put project_ConstructStandardFile (gMenuTitle, projectFolder, "controllers") into controllerPath
   --
   if there is a file controllerPath then
      put the short name of stack controllerPath into stackName
      if stackName = gMenuTitle then
         return empty
      end if
   end if
   
   # Ask Create
   ask_CreateProjectMenu projectName, gMenuTitle, pControllerScript, pDisplay
   put the result into mController
   
   # Edit the script
   if pDisplay is true then
      edit the script of mController
   end if
   
   return mController
end ask_CreateMenuFromObject


--> Display
-
on display_RenameMenu mTitle, mController, mModel
   -- put "Rename menu:" && kwote (mTitle) && "of" && mController
   put mTitle into dArray ["mTitle"]
   put mController into dArray ["mController"]
   put mModel into dArray ["mModel"]
   --
   if exists (mController) then
      put the project_Name of mController into projectName
      put projectName into dArray ["projectName"]
      --
      put the module_Name of mController into moduleName
      if moduleName is not empty then
         put moduleName into dArray ["moduleName"]
      end if
   end if
   
   display_Tool dArray, mTitle, "Rename Menu"
   if the shiftKey is "Down" then
      display_DebugHistory "menu_GetGlobalController()"
   end if
end display_RenameMenu

command display_ModuleClone mName, pCloneName
   if pCloneName is empty then
      put mName into mWords
      set the itemdelimiter to "|"
      if item 1 of mWords = "View" then delete item 1 of mWords
      replace "|" with space in mWords
      put "Cloned" && mWords into pCloneName
   end if
   
   # Clone
   stack_Clone mName, pCloneName
   put the result into cStack
   if exists(cStack) is false then
      lcw_AnswerWarning "Failed to clone stack '[[var]]'!", dView, mName
   end if
   
   # Display Clone Tools
   put the short name of cStack into cName
   put the card_ViewObject of stack cName into vObject
   
   # Also display clone tools
   display_CloneTools cName
   return vObject
end display_ModuleClone

command display_CloneTools cStackName
   if exists (stack cStackName) is false then
      return "Error, cannot locate stack:" && cStackName
   end if
   put the short name of stack cStackName into cStackName -- in case it's a stackPath
   put the original_ModuleName of stack cStackName into moduleName
   
   # Module Directory Array
   put the module_Folder of stack moduleName into moduleFolder
   put directory_NestedArray (moduleFolder) into dArray
   
   # Display 
   display_Tool dArray, cStackName, "Clone Tools"
   put the result into dView
   
   # Set Props
   put the card_ViewObject of stack moduleName into originalView
   put the card_ViewObject of stack cStackName into clonedView
   --
   set the displayed_Object of dView to clonedView
   set the original_View of dView to originalView
   set the displayed_ModuleFolder of dView to moduleFolder
   --
   return dView
end display_CloneTools

command display_MenuBarData mGroup
   if exists (the menubar_View of mGroup) is false then
      breakpoint
      return "Error, menubar_View does not exists:" && mGroup
   end if
   
   put the stack_Name of mGroup into stackName
   put the menubar_TableData of mGroup into indexArray
   put display_FindArrayView ("Menubar Data", stackName) into dView
   --
   display_Tool indexArray, stackName, "Menubar Data", "lcw_Menus", "m mName", dView
   put the result into dView
   set the displayed_Object of dView to mGroup
   return dView
end display_MenuBarData


--> Display | Tools
-
command display_Tool someData, pTitle, pStackLabel, pProjectName, pNameKey, pDisplayView
   # Display data depending on ducktyping of content
   if pNameKey is empty then
      display_Data someData, pTitle, pStackLabel, pDisplayView
   else
      display_IndexArray someData, pTitle, pStackLabel, false, pNameKey, 2, pDisplayView
   end if
   put the result into dView
   
   # Guess libName from pStackLabel
   if pProjectName is empty then
      put "lib_" & word 1 of pStackLabel into pProjectName
   end if
   
   # Guess menuBit from pStackLabel
   put pStackLabel into toolPath
   replace space with " | " in toolPath
   
   # Set menus and mouse_DoubleUp
   set the tool_MenuBit [pProjectName] of dView to toolPath
   return dView
end display_Tool

command display_Tools someData, pTitle, pToolPath, pStackLabel, pProjectName, pPalette, pTopLeft, pFoldedArray
   # Display data depending on ducktyping of content
   display_Data someData, pTitle, pStackLabel, "", pPalette, pTopLeft, pFoldedArray
   put the result into displayView
   
   # Set menus and mouse_DoubleUp
   set the tool_MenuBit [pProjectName] of displayView to pToolPath
   return displayView
end display_Tools

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


--> Display | Tools
-
on display_ModuleTools stackName, pDisplayView
   if exists (stack stackName) is false then
      return "Error, cannot locate stack:" && stackName
   end if
   
   put the short name of stack stackName into stackName -- in case it's a stackPath
   put the module_Folder of stack stackName into moduleFolder
   put the card_ViewObject of stack stackName into moduleViewObject
   put directory_NestedArray (moduleFolder) into dArray
   --
   display_Tool dArray, stackName, "Module Tools"
   put the result into displayView
   --
   set the displayed_Object of displayView to moduleViewObject
   set the displayed_ModuleFolder of displayView to moduleFolder
   --
   return displayView
end display_ModuleTools

put the stack_View of cd 1 of clonedStack into mView
if exists (mView) then
   set the displayed_Object of mView to moduleName
else
   breakpoint
end if

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


--> Events (Move to Line menu)
-
on mDoubleUp_GoToCard displayView, cardName
   put the displayed_Object of displayView into stackObject
   put the title_Text of displayView into stackName
   --
   go to cd cardName of stack stackName
end mDoubleUp_GoToCard
