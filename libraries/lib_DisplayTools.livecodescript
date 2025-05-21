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

command display_MenuBarData mGroup
   if exists (the menubar_View of mGroup) is false then
      breakpoint
      return "Error, menubar_View does not exists:" && mGroup
   end if
   
   put the stack_Name of mGroup && "Menubar Data" into stackName
   put the menubar_TableData of mGroup into indexArray
   
   -- put display_FindArrayView ("Menubar Data", stackName) into dView
   -- display_Tool indexArray, "Menubar Data", "Menubar Data" -- "lcw_Menus", "m mName"
   
   display_StandardTool indexArray, stackName, "Menubar Data"
   put the result into dView
   set the displayed_Object of dView to mGroup
   
   # Set menus and mouse_DoubleUp
   set the tool_MenuBit ["lcw_Menus"] of dView to "Menubar | Data"
   
   return dView
end display_MenuBarData

command display_Tool someData, pTitle, pStackLabel, pProjectName, pNameKey
   if pTitle is empty then put "Data" into pTitle
   --
   display_StandardTool someData, pTitle, pStackLabel, pNameKey
   put the result into dView
   
   # Guess menuBit from pStackLabel
   if pStackLabel is empty then
      put menu_Bit (pTitle) into pToolPath
      breakpoint
   else
      put pStackLabel into pToolPath
      replace space with " | " in pToolPath
   end if
   
   # Set menus and mouse_DoubleUp
   set the tool_MenuBit [pProjectName] of dView to pToolPath
   
   return dView
end display_Tool


--> Events (Move to Line menu)
-
on mDoubleUp_GoToCard displayView, cardName
   breakpoint
   put the displayed_Object of displayView into stackObject
   put the title_Text of displayView into stackName
   --
   go to cd cardName of stack stackName
end mDoubleUp_GoToCard


--> Display
-
command display_Project projectName, pExpandedItems
   local foldedArray
   if pExpandedItems is empty then put "Modules" into pExpandedItems
    
   put project_GetStackNameArray (projectName) into dArray
   --
   put display_ConstructFoldState (pExpandedItems) into foldedArray
   display_StandardTool dArray, projectName, "Project", foldedArray
   put the result into displayView
   
   # Set Menus
   put project_DisplayMenuTitles (projectName) into titleMenuTable
   set the title_Menu of displayView to titleMenuTable
   set the line_Menu of displayView to "Global | Project | Line | Menu"
   set the mouse_DoubleUp of displayView to "mDoubleUp_ProjectTree"
   --
   return displayView
end display_Project

command display_ProjectArray projectName, pReconstruct
   if pReconstruct is true then
      project_UpdateArray projectName
      put the result into projectArray
      --
      display_Project projectName
      display_EnvironmentMenus true
      display_GitRefreshProjectName projectName
   else
      put project_GetArray (projectName) into projectArray
   end if
   
   /*
   display_Data projectArray, projectName, "Project Array"
   put the result into displayView
   */
   
   display_StandardTool projectArray, projectName, "Project Array"
   put the result into displayView
   --
   set the tool_MenuBit [projectName] of displayView to "Project | Array"
   --
   return displayView
end display_ProjectArray

command display_ModuleTools moduleStackName, pDisplayView
   -- moduleStackName = "View|Guide"
   if exists (stack moduleStackName) is false then
      return "Error, cannot locate stack:" && moduleStackName
   end if
   
   put the short name of stack moduleStackName into moduleStackName -- in case it's a stackPath
   put the module_Folder of stack moduleStackName into moduleFolder
   put the card_ViewObject of stack moduleStackName into moduleView
   put directory_NestedArray (moduleFolder) into dArray
   --
   display_StandardTool dArray, moduleStackName
   put the result into displayView
   --
   set the displayed_Object of displayView to moduleView
   set the displayed_ModuleFolder of displayView to moduleFolder
   put the module_MenuTitle of moduleView into moduleMenu
   
   # Set menus and mouse_DoubleUp
   set the tool_MenuBit [projectName] of displayView to "Module | Tools"
   --
   put the stack_Name of displayView into displayStackName
   show stack displayStackName -- just in case
   --
   return displayView
end display_ModuleTools

command display_StandardTool someData, pTitle, pStackLabel, pFoldedArray, pNameKey
   # Clone name
   -- put "Display" && label_FromModuleName(pTitle) into cloneName
   put "Display" && pTitle into cloneName
   
   # Ducktype
   -- put pNameKey is empty into isArray
   put someData is an array into isArray
   put there is a stack cloneName into stackExisted
   
   # Display data
   lock screen
   if stackExisted then
      put cloneName into cloneStackName
   else
      if isArray then
         stack_CloneInvisible "View|Tree|Widget with Title", cloneName
      else
         stack_CloneInvisible "View|Index|Simple", cloneName
      end if
      put the result into cloneStackName
      
      if pStackLabel is not empty then
         set the label of stack cloneStackName to pStackLabel
      end if
      
      # Default stack style
      set the style of stack cloneStackName to "palette"
   end if
   
   # Find display_View
   put _DisplayView (cloneStackName) into dView -- hacky
   if exists (dView) is false then
      breakpoint
      go to stack cloneStackName
      return "Error, could not find dView:" && cloneStackName
   end if
   
   # Display And Show
   set the displayed_Data [pTitle] of dView to someData
   if pFoldedArray is an array then
      set the fold_State of dView to pFoldedArray
   end if
   
   # Title Colour
   display_SetTitleColour dView
   
   # Auto Width
   if isArray is false then
      set the field_Style of dView to "click"
      set the drop_Command of dView to empty
      --
      put the formatted_Width of dView into fWidth
      set the stack_Width of dView to fWidth
   end if
   unlock screen
   
   # Show
   if stackExisted then
      -- go visible to stack cloneStackName -- bug: same as go invisible
      show stack cloneStackName
      go to stack cloneStackName
      if the result is not empty then
         breakpoint
      end if
   else
      set the visible of stack cloneStackName to true
   end if
   
   return dView
end display_StandardTool


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


--> Display | Tools
-
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


--> Private
-
private function _DisplayView cloneStackName
   if exists (control 1 of cd 1 of stack cloneStackName) is false then
      return empty
   end if
   --
   put the long id of control 1 of cd 1 of stack cloneStackName into displayView
   return displayView
end _DisplayView
