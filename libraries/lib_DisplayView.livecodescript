script "lib_DisplayView"
--> MetaData
-
license: GPLv3
name: lib_DisplayView
type: library
version: 0.4


--> Working on
-
function display_FirstOpenView viewName, pStackLabel, pViewTitle
   view_NormalizeName viewName
   put "|" after viewName
   --
   put revLoadedStacks ("application") into dStackNames
   repeat for each line dStackName in dStackNames
      # Check exists
      if exists (control 1 of card 1 of stack dStackName) is false then next repeat
      put the long id of control 1 of card 1 of stack dStackName into displayView
      put the view_Name of displayView into testViewName
      put "|" after testViewName
      
      # Check viewName is stem of text view name
      if testViewName begins with viewName is false then next repeat
      
      # Refine test
      put the label of stack dStackName into stackLabel
      if stackLabel is empty then
         put dStackName into stackLabel
      end if
      switch
         case pStackLabel is empty
            return displayView
         case stackLabel begins with pStackLabel
            if pViewTitle is empty then
               return displayView
            else if the title_Text of displayView = pViewTitle then
               return displayView
            else
               next repeat
            end if
         default
            -- next repeat
      end switch
   end repeat
   return empty
end display_FirstOpenView

function display_FindView displayStackLabel, pDisplayViewTitle, pTypes
   -- Looks for Display Array, and Display Index views depending on pTypes
   if pTypes is empty then put "Display Index,Display Array" into pTypes
   
   put revLoadedStacks ("application") into dStackNames
   repeat for each line dStackName in dStackNames
      get word 1 to 2 of dStackName
      if it is not among the items of pTypes then next repeat
      if the label of stack dStackName = displayStackLabel then
         put the long id of group 1 of stack dStackName into displayView
         if pDisplayViewTitle is empty then
            return displayView
         else if the title_Text of displayView = pDisplayViewTitle then
            return displayView
         end if
      end if
   end repeat
   return empty
end display_FindView


--> Display | Image
-
command display_Image imageOrURL, pStackLabel, pDisplayView, pStackStyle, pStackRect
   display_ModuleInstance "View|Image", imageOrURL, pStackLabel, pDisplayView, "displayed_Data", pStackStyle
   put the result into displayView
   return displayView
end display_Image


--> Display | Module
-
command display_ModuleInstance moduleName, pData, pStackLabel, pDisplayView, pDataProp, pStackStyle
   if pStackLabel is empty then put moduleName into pStackLabel
   if pDataProp is empty then put "displayed_Data" into pDataProp
   if pStackStyle is empty then put "toplevel" into pStackStyle
   
   switch
      case pDisplayView is true
         display_ViewTemplate moduleName
         put the result into pDisplayView
      case exists (pDisplayView)
         set the pDataProp of pDisplayView to pData
         set the stack_Label of pDisplayView to pStackLabel
         return pDisplayView
      default
         display_CloneModule moduleName, pData, pStackLabel, pDataProp, pStackStyle
         put the result into clonedViewObject
         return clonedViewObject
   end switch 
end display_ModuleInstance

command display_CloneModule moduleName, pData, pStackLabel, pDataProp, pStackStyle, pStackLocOrRect, pViewRect
   # Find Template View
   put view_GetTemplateObject (moduleName) into moduleObject
   if exists (moduleObject) is false then throw "Error, no template object found for:" && moduleName
   
   # Defaults
   if pStackLabel is empty then put moduleName into pStackLabel
   if pDataProp is empty then put "displayed_Data" into pDataProp
   if pStackStyle is empty then put "toplevel" into pStackStyle
   
   # Clone
   stack_CloneInvisible moduleName
   put the result into clonedStackName
   put the long id of control 1 of cd 1 of stack clonedStackName into clonedViewObject
   
   # Set the data to display
   set the pDataProp of clonedViewObject to pData
   
   # Show And Position
   display_ShowStack clonedViewObject, clonedStackName, pStackLabel, pStackStyle, pStackLocOrRect, pViewRect
   
   return clonedViewObject
end display_CloneModule

command display_ShowStack viewObject, cloneStackName, pStackLabel, pStackStyle, pStackLocOrRect, pViewRect
   if pStackStyle is empty then put "toplevel" into pStackStyle
   set the stack_Style of stack cloneStackName to pStackStyle
   if pStackLabel is not empty then set the label of stack cloneStackName to pStackLabel
   --
   stack_Position cloneStackName, pStackLocOrRect
   if pViewRect is a rect then
      dispatch "LayoutControl" to viewObject with pViewRect
   else
      dispatch "LayoutControl" to viewObject
   end if
   --
   show stack cloneStackName
   go to stack cloneStackName
   --
   return cloneStackName
end display_ShowStack

command display_View viewName, pData, pStackLabel, pStackRect, pDataProp, pStackStyle
   if pStackLabel is empty then put viewName into pStackLabel
   if pDataProp is empty then put "displayed_Data" into pDataProp
   if pStackStyle is empty then put "palette" into pStackStyle
   
   # Find Template View
   put view_GetTemplateObject (viewName) into viewObject
   if exists (viewObject) is false then throw "Error, no template object found for:" && viewName
   
   # Clone invisible
   display_Clone viewName, pStackLabel, pData, pDataProp, pStackRect, pStackStyle
   put the result into viewObject
   --
   if exists (viewObject) then
      return viewObject
   else
      # Problem copying view?
      breakpoint
      return "Error, cloning:" && viewName,viewObject
   end if
end display_View

command display_Clone viewName, pCloneName, pData, pDataProp, pLocOrRect, pStackStyle
   -- rename?
   if pStackStyle is empty then put "palette" into pStackStyle
   --
   if pCloneName is empty then
      put viewName into stackLabel
   else
      put pCloneName into stackLabel
   end if
   --
   stack_CloneInvisible viewName, pCloneName
   put the result into pCloneName
   --
   if exists (control 1 of cd 1 of stack pCloneName) then
      put the long id of control 1 of cd 1 of stack pCloneName into viewObject
   else
      -- problem copying view?
      breakpoint
      show stack pCloneName
      return the name of stack pCloneName
   end if
   --
   -- put the rect of viewObject into pLocOrRect
   put the view_RectOnCard of viewObject into viewRect
   --
   if pDataProp is empty then put "displayed_Data" into pDataProp
   set the pDataProp of viewObject to pData
   --
   if the visible of stack pCloneName is false then
      -- causes flicker. If we need to reposition then possibly but now now...
      display_ShowStack viewObject, pCloneName, stackLabel, pStackStyle, pLocOrRect, viewRect
   else
      go to stack pCloneName
   end if
   --
   return viewObject
end display_Clone



--> Display | functions
-
function display_List pViewNames, pStackLabel
   # List open stacks with a UX
   put stack_ListOpen() into dStackNames
   -- put revLoadedStacks ("application") into loadedStackNames
   
   # Filter
   repeat for each line dStackName in dStackNames
      get the label of stack dStackName
      if (pStackLabel is not empty) AND (it is not pStackLabel) then
         next repeat
      end if
      -- 
      if exists (control 1 of card 1 of stack dStackName) then
         put the long id of control 1 of card 1 of stack dStackName into sView
         if pViewNames is empty then
            put sView & CR after foundViews
         else
            put the view_Name of sView into testViewName
            if testViewName is among the items of pViewNames then
               put sView & CR after foundViews
            end if
         end if
      end if
   end repeat
   delete char -1 of foundViews
   return foundViews
end display_List


--> Stack | List
-
function stack_ListOpen
   put the openstacks into stackNames
   repeat for each line stackName in stackNames
      switch
         case stackName = "Message Box"
         case char 1 to 3 of stackName = "rev"
         case char 1 to 4 of stackName = "com."
         case the scriptonly of stack stackName is true
            next repeat
         default
            put stackName & CR after appStackNames
      end switch
   end repeat
   delete char -1 of appStackNames
   return appStackNames
end stack_ListOpen

function stack_ListLabeled sLabel
   put revLoadedStacks ("application") into dStackNames
   repeat for each line dStackName in dStackNames
      if the label of stack dStackName = sLabel then
         put dStackName & CR after foundStackNames
      end if
   end repeat
   delete char -1 of foundStackNames
   return foundStackNames
end stack_ListLabeled

function stack_FindNameData pSearchStackLabel, pTestProperty
   put revLoadedStacks ("application") into dStackNames
   repeat for each line dStackName in dStackNames
      if pTestProperty is not empty then
         if the pTestProperty of stack dStackName is not empty then
            next repeat
         end if
      end if
      
      put the label of stack dStackName into stackLabel
      switch
         case pSearchStackLabel is empty
         case stackLabel = pSearchStackLabel
            if word 1 to -1 of stackLabel is empty then put "Space" into stackLabel
            put displayView into stackNameData [dStackName]["displayView"]
            put stackLabel into stackNameData [dStackName]["stackLabel"]
            --
            if pTestProperty is not empty then
               put pTestProperty into stackNameData [dStackName]["prop"][pTestProperty]
            end if
            break
         default
            -- next repeat
      end switch
   end repeat
   return stackNameData
end stack_FindNameData

function stack_ListNamedViews nameStem
   put stack_FindNames (nameStem) into sNames
   repeat for each line sName in sNames
      if exists (control 1 of card 1) is false then next repeat
      --
      put the long id of control 1 of card 1 of stack sName into sView
      put revRuggedId (sView) & CR after namedViews
   end repeat
   return namedViews
end stack_ListNamedViews

function stack_FindNames nameStem
   -- could use filter
   put revLoadedStacks ("application") into loadedStackNames
   repeat for each line stackName in loadedStackNames
      if stackName begins with nameStem then
         put stackName & CR after foundStackNames
      end if
   end repeat
   delete char -1 of foundStackNames
   return foundStackNames
end stack_FindNames

function stack_ListNames pStackNames
   switch pStackNames
      case empty
         return stack_ListOpen()
      case "open"
         return the openstacks
      case "loaded"
         return revLoadedStacks ("application")
      default
         -- could check they exist
         return pStackNames
   end switch
end stack_ListNames


--> Display | Find | One
-
function display_FindCloned vName, displayStackLabel, pDisplayViewTitle
   -- only one
   put revLoadedStacks ("application") into dStackNames
   repeat for each line dStackName in dStackNames
      if the label of stack dStackName = displayStackLabel then
         if exists (control 1 of stack dStackName) is false then next repeat
         put the long id of control 1 of stack dStackName into dView
         --
         switch
            case the view_Name of dView is not vName
               next repeat
            case the title_Text of dView = pDisplayViewTitle
            case displayStackLabel is empty
               return dView
            default
               next repeat
         end switch
      end if
   end repeat
   return empty
end display_FindCloned

function display_FindStackNameArray pSearchStackLabel, pSearchViewTitle, pPretty
   -- looks for Dispay Array, and Display Index views
   put revLoadedStacks ("application") into dStackNames
   repeat for each line dStackName in dStackNames
      get word 1 to 2 of dStackName
      if it is not among the items of "Display Index,Display Array" then next repeat
      
      put the long id of group 1 of stack dStackName into displayView
      --
      put the title_text of displayView into titleText
      put the label of stack dStackName into stackLabel
      
      -- skip unless the following conditions are met
      if pSearchStackLabel is empty then
         put displayView into displayViewArray [dStackName]["displayView"]
         put stackLabel into displayViewArray [dStackName]["stackLabel"]
         put titleText into displayViewArray [dStackName]["titleText"]
      else if stackLabel = pSearchStackLabel then
         if pSearchViewTitle is empty then
            put displayView into displayViewArray [dStackName]["displayView"]
            put stackLabel into displayViewArray [dStackName]["stackLabel"]
            put titleText into displayViewArray [dStackName]["titleText"]
         else if titleText = pSearchViewTitle then
            put displayView into displayViewArray [dStackName]["displayView"]
            put stackLabel into displayViewArray [dStackName]["stackLabel"]
            put titleText into displayViewArray [dStackName]["titleText"]
         end if
      end if
   end repeat
   --
   if pPretty is true then
      put _MakeStackNameArrayPretty (displayViewArray) into prettyArray
      return prettyArray
   else
      return displayViewArray
   end if
end display_FindStackNameArray


--> Display | View
-
command display_NewViewStack viewName, pCloneName, pData, pDataProp, pStackRect, pStackStyle
   -- Not used. Creates clean stack. Card behaviour currenlty not set
   if pCloneName is empty then put stack_ConstructNewCloneName (viewName) into pCloneName
   if pDataProp is empty then put "displayed_Data" into pDataProp
   
   stack_Create pCloneName, viewName, "", pStackRect, "", true, pStackStyle
   put the result into viewObject
   --
   set the pDataProp of viewObject to pData
   show stack pCloneName
   --
   return viewObject
end display_NewViewStack


--> Display | View
-
command display_Camera cameraDeviceName, sRect
   display_Clone "View|Camera", "Camera", cameraDeviceName, "camera_DeviceName", sRect
   put the result into displayView
   return displayView
end display_Camera


--> Display | View | Examples
-
command display_SVG svgFile, pStackLabel, pStackStyle, pLocOrRect
   stack_CloneInvisible "View|Image|SVG", "Display SVG"
   put the result into cloneStackName
   put the long id of widget 1 of cd 1 of stack cloneStackName into viewObject
   --
   if svgFile begins with "http" then
      set the svg_URL [true] of viewObject to svgFile
   else
      set the svg_File [true] of viewObject to svgFile
   end if
   --
   if pStackLabel is empty then
      set the itemdelimiter to slash
      put item -1 of svgFile into pStackLabel
   end if
   display_ShowStack viewObject, cloneStackName, pStackLabel, pStackStyle, pLocOrRect
   return viewObject
end display_SVG

function view_ConstructToolMenu viewObject, isaView
   put the view_MenuTitle [true] of viewObject into mTitle
   put view_MenuToolTitles (mTitle, isaView) into mTitles
   return mTitles
end view_ConstructToolMenu

function view_MenuToolTitles mTitle, isaView
   if menu_GlobalControllerExists (mTitle) is true then
      put tab & "submenu" & CR & "-" after mTitle
   end if
   --
   if isaView is not false then
      put CR & "Global | Module | Menu" & tab & "submenu" after mTitle
      put CR & "Global | View | Assets | Menu" & tab & "submenu" after mTitle
      put CR & "-" after mTitle
      -- put CR & "Global | View | Authoring | Menu" & tab & "submenu" after mTitle
      put CR & "Global | View | Script | Menu" & tab & "submenu" after mTitle
      put CR & "Global | View | Property | Menu" & tab & "submenu" after mTitle
      put CR & "Global | View | Geometry | Menu" & tab & "submenu" after mTitle
      put CR & "Global | View | Update | Menu" & tab & "submenu" after mTitle
   else
      put CR & "Global | Module | Menu" & tab & "submenu" after mTitle
   end if
   return word 1 to -1 of mTitle
end view_MenuToolTitles


--> Display | Events
-
on mDouble_DisplayView indexView, viewName
   switch
      case exists (stack viewName) is false
         answer merge("Could not find stack '[[viewName]]'.")
         break
      default
         -- display_ModuleInstance viewName
         display_ViewTemplate viewName
   end switch
end mDouble_DisplayView

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

command mDoubleUp_EditBehavior indexView, bObject
   put the displayed_Object of indexView into viewObject
   
   put the textcolor of the clickLine into lineColour
   switch lineColour
      case "255,0,0" -- red
         -- behavior is missing
         breakpoint
         break
      case "142,53,239" -- purple
         -- default behavior is missing
         breakpoint
         break
      case "0,255,0" -- green
         -- default behavior in this project
         edit the script of bObject
         break
      case "248,122,23" -- orange
         -- inAnotherProject
         _askMoveBehavior "Do you want to import this behavior from project '[[otherProjectName]]'?", bObject, viewObject
         display_ViewBehaviors viewObject, indexView
         break
      case "0,0,139" -- dark blue
         -- default behavior is in another project
         _askMoveBehavior "Do you want to import this default behavior from project '[[otherProjectName]]'?", bObject, viewObject
         set the behavior of viewObject to the behavior of viewObject -- probably not necessary?
         display_ViewBehaviors viewObject, indexView
         break
      default
         -- subview in this project
         edit the script of bObject
         -- put lineColour
   end switch
end mDoubleUp_EditBehavior


--> Display | View
-
command palette_View viewName, pCardMargin, pStackRect, pHidden
   stack_CreateWithView viewName, pCardMargin, pStackRect, pStackStyle, pHidden
   put the result into createdView
   return createdView
end palette_View


--> Display | Project | Views
-
command display_ViewIndex viewObject, pIndexView
   put the view_Props of viewObject into viewProps
   
   put the view_Name of viewObject into viewName
   put the module_Name of viewObject into moduleName
   put the project_Name of viewObject into projectName
   
   put viewName & comma & projectName into stackTitle
   
   put view_ConstructToolMenu (viewObject, true) into mTitle  
   put "Global | Module | Tree | Line | Menu" into mLineTitle
   put empty into mUp
   put "mDouble_EditProp" into mDoubleClick
   put empty into pDragCommand
   
   if exists (pIndexView) is false then
      display_Index viewProps, stackTitle, mTitle, mLineTitle, mUp, mDoubleClick, pDragCommand, true
      put the result into indexView
      set the multiple_Hilites of indexView to false
   else
      lock screen
      set the view_Index of pIndexView to viewProps
      set the stack_Title of pIndexView to stackTitle
      set the mouse_DoubleUp of pIndexView to mDoubleClick
      set the title_Menu of pIndexView to mTitle
      set the line_Menu of pIndexView to mLineTitle
      unlock screen
      return pIndexView
   end if
   
   put the module_Folder of viewObject into moduleFolder
   put project_PathFromFolder (moduleFolder) into moduleHomeStackPath
   put the project_Folder of viewObject into projectFolder
   put the project_Name of viewObject into projectName
   
   set the displayed_Object of indexView to viewObject
   set the displayed_ViewName of indexView to viewName
   set the displayed_ModuleFolder of indexView to moduleFolder
   set the displayed_ModuleName of indexView to moduleFolderName
   set the displayed_ModuleHomeStackPath of indexView to moduleHomeStackPath
   set the displayed_ProjectName of indexView to projectName
   set the displayed_ProjectFolder of indexView to projectFolder
   return indexView
end display_ViewIndex

command display_ViewBehaviors viewObject, pIndexView, pStacklabel
   put the behavior_Objects of viewObject into bObjects
   put the view_Name of viewObject into viewName
   
   put the project_Folder of viewObject into projectFolder
   if projectFolder is empty then
      -- may not be in a module or project
      -- put viewName & comma & "No Project" into stackTitle
   else
      put the project_Name of viewObject into projectName
      put the module_Folder of viewObject into moduleFolder
      put the module_Name of viewObject into moduleName
      put project_PathFromFolder (moduleFolder) into moduleHomeStackPath
      
      -- put viewName & comma & projectName into stackTitle
   end if
   put viewName & comma & "Behaviors" into stackTitle
   
   if exists (pIndexView) then
      set the view_Index of pIndexView to bObjects
      put pIndexView into indexView
   else
      display_Lines bObjects, stackTitle, "mDoubleUp_EditBehavior", moduleName, pStacklabel
      put the result into indexView
      set the title_Menu of indexView to "Global | View | Behavior | Menu"
      set the line_Menu of indexView to "Global | View | Behavior | Line | Menu"
   end if
   
   set the displayed_Object of indexView to viewObject
   set the displayed_ViewName of indexView to viewName
   
   if projectFolder is not empty then
      set the displayed_ModuleFolder of indexView to moduleFolder
      set the displayed_ModuleName of indexView to moduleName
      set the displayed_ModuleHomeStackPath of indexView to moduleHomeStackPath
      set the displayed_ProjectName of indexView to projectName
      set the displayed_ProjectFolder of indexView to projectFolder
   end if
   
   -- now let's colour the behavior lines
   put moduleName into thisModuleName
   put projectName into thisProjectName
   put the behavior of viewObject into bObject
   
   repeat with lineNum =1 to the number of lines of bObjects
      put line lineNum of bObjects into cObject
      put exists (cObject) is false into notThere
      if notThere is true then
         switch
            case cObject = bObject
               set the line_Colour [lineNum] of indexView to "purple"
               break
            case notThere
               set the line_Colour [lineNum] of indexView to "red"
               break
         end switch
         next repeat
      end if
      
      put the project_Name of cObject into thatProjectName
      put thisProjectName is not thatProjectName into inAnotherProject
      switch
         case cObject = bObject and inAnotherProject
            set the line_Colour [lineNum] of indexView to "dark blue"
            break
         case cObject = bObject
            set the line_Colour [lineNum] of indexView to "green"
            break
         case inAnotherProject
            set the line_Colour [lineNum] of indexView to "orange"
            break
         default
            -- it's within the project so leave as deafult (black) colour
      end switch
   end repeat
   
   return indexView
end display_ViewBehaviors

command display_NestedViewArray viewObject
   put the view_NestedArray of viewObject into nestedViewArray
   
   put the view_Name of viewObject into viewName
   put the module_Name of viewObject into moduleName
   put the project_Name of viewObject into projectName
   
   put view_ConstructToolMenu (viewObject, true) into mTitle
   put viewName & comma & projectName into stackTitle
   
   display_Array nestedViewArray, stackTitle, mTitle
   put the result into arrayView
   
   set the displayed_Object of arrayView to viewObject
   set the displayed_ViewName of arrayView to viewName
   
   put the module_Folder of viewObject into moduleFolder
   put project_PathFromFolder (moduleFolder) into moduleHomeStackPath
   put the project_Folder of viewObject into projectFolder
   
   set the displayed_ModuleFolder of arrayView to moduleFolder
   set the displayed_ModuleName of arrayView to moduleFolderName
   set the displayed_ModuleHomeStackPath of arrayView to moduleHomeStackPath
   set the displayed_ProjectName of arrayView to projectName
   set the displayed_ProjectFolder of arrayView to projectFolder
   
   return arrayView
end display_NestedViewArray

command display_ProjectViews projectName
   put project_ListViewStackNames (projectName) into stackNames
   put merge ("[[projectName]],Views") into someTitle
   
   local mLineTitle, mUp
   display_Data stackNames, someTitle, "Views"
   put the result into displayView
   display_SetInteractions displayView, "Views | Tree", "mDouble_DisplayView"
   return displayView
end display_ProjectViews

command display_EnvironmentViews
   put env_ListViewStackNames() into activeViewStackNames
   --
   display_Data activeViewStackNames, "Views", "Environment"
   put the result into displayView
   --
   display_SetInteractions displayView, "View | List", "mDouble_DisplayView"
   --
   return displayView
end display_EnvironmentViews


--> Private
-
private command _askMoveBehavior someComment, bObject, viewObject
   put the project_Name of bObject into otherProjectName
   put merge (someComment) into someComment
   replace "'" with quote in someComment
   answer someComment with "Cancel" or "Copy" or "Move"
   switch it
      case "Copy"
         breakpoint
         break
      case "Move"
         if word 1 of bObject is not "stack" then
            breakpoint
            exit to top
         end if
         
         answer "Do you want to move the behavior to the behavior folder in the module_Folder or the project_Folder?" with "Cancel" or "Project" or "Module"   
         switch it
            case "Cancel"
               exit to top
            case "Project"
               put the project_Folder of viewObject into projectFolder
               put folder_AddShort (projectFolder, "behaviors") into newBehaviorFolder
               break
            case "Module"
               put the module_Folder of viewObject into moduleFolder
               put folder_AddShort (moduleFolder, "behaviors") into newBehaviorFolder
               break
         end switch
         folder_CreateNested newBehaviorFolder
         
         set the itemdelimiter to slash
         put the filename of bObject into oldBehaviorPath
         put item -1 of oldBehaviorPath into shortFile
         put newBehaviorFolder & shortFile into newBehaviorPath
         
         breakpoint
         project_MoveStack oldBehaviorPath, newBehaviorPath, true
         break
      default
         -- case "Cancel" 
         exit to top
   end switch
end _askMoveBehavior
