script "Global_Environment_Menu"
--> MetaData
-
license: GPLv3
name: Global_Environment_Menu
type: controller
version: 0.6


--> Variables
-
local LocalArray


--> Events | Display
-
on doubleup_DisplayScriptOnlyfolder indexView, mainStackName
   -- put the dataObject_Folder [true] of stack mainStackName into testDataFolder
   put textStack_ConstructDataFolder (mainStackName) into dataFolder
   put script_ReconstructFromExported (dataFolder) into someScript
   
   if exists (stack mainStackName) is false then
      create script only stack mainStackName
      set the script of stack mainStackName to someScript
      edit the script of stack mainStackName
      show stack mainStackName
   else
      display_Text someScript
      atom_DisplayText someScript
   end if
end doubleup_DisplayScriptOnlyfolder

function textStack_ConstructDataFolder mainStackName, pStackName, pLongObjectID
   -- same functionality as "getprop dataObject_Folder"
   
   put textStack_ConstructFolder (mainStackName) into textStackFolder -- textStack_Folder
   put textStackFolder & "data/" into textStackDataFolder
   
   switch pStackName
      case empty
      case mainStackName
         put textStackDataFolder & "objects/" into dataFolder
         break
      default
         put textStackDataFolder & "objects/substacks/" & pStackName & "/" into dataFolder
   end switch
   
   switch word 1 of pLongObjectID
      case empty
      case "stack"
         put "stack/" after dataFolder
         break
      default
         put word 1 of pLongObjectID & "_" & word 3 of pLongObjectID & "/" after dataFolder
   end switch
   return dataFolder
end textStack_ConstructDataFolder

on mDoubleUp_SaveStack indexView, mStackName
   put the bad_StackArray of indexView into testArray
   put testArray ["bad path"][mStackName] into stackPath
   switch
      case there is a file stackPath
         put "OK"
         break
      default
         put "Missing:" && stackPath
   end switch
end mDoubleUp_SaveStack


--> Menu | Props
-
getprop menuStyle_Param
   return the menu_Style of stack "lib_MenuArray"
end menuStyle_Param

getprop menuStyle_Params
   return "Array,Old"
end menuStyle_Params

getprop setMenu_Param
   return ide_ShortTitle ("Recent")
end setMenu_Param

getprop setMenu_Params
   put ide_ListShortMenuTitles ("Recent") into shortNames
   return shortNames
end setMenu_Params

getprop displayRecentExports_Params
   return "5 min,10 min,20 min,30 min,300 min,-,ask"
end displayRecentExports_Params

getprop display_Params
   return "List Projects,-,Libraries and Models,Libraries and Models,-,List All Modules,-,Controllers,List All Behaviors,Behaviors,Views"
end display_Params


--> Global | Environment | Menu
-
on menu_DisplayRigControllers
   display_RigControllers
end menu_DisplayRigControllers

on menu_DisplayFederationServers
   display_FederationServers
end menu_DisplayFederationServers

on menu_DisplayAtopiaFolders
   display_AtopiaDomains
end menu_DisplayAtopiaFolders

on _
end _

on menu_DisplayRecentExports mTarget, howLong
   if howLong = "ask" then
      put lcw_Ask ("How many hours...", 60) into someHours
      if someHours is not a number then exit to top
      put someHours * 60 into howLong
   end if
   display_RecentExports howLong
end menu_DisplayRecentExports

on _
end _

on menu_Display indexView, displayWhat
   put displayWhat & comma & "Environment" into someTitle
   switch displayWhat
      case "List All Projects"
         put library_ListProjectNames() into projectNames -- it's the default anyway
         display_LcwProjectList projectNames
         break
      case "List Active Projects"
         if the shiftKey is "Down" then
            put env_ListProjects() into projectNames
         else
            put library_ListProjectNames() into projectNames
         end if
         display_LcwProjectList projectNames
         break
      case "-"
      case "List All Libs"
         if the shiftKey is "Down" then
            display_LcwLibs
         else
            display_LcwLibs indexView
         end if
         break
      case "List All Modules"
         put library_ListProjectNames ("module") into projectNames
         set the view_Index [displayWhat] of indexView to projectNames
         set the mouse_DoubleUpEvent of indexView to "mDouble_DisplayModule"
         break
      case "List All Controllers"
         if the shiftKey is "Down" then
            display_Controllers
         else
            display_Controllers indexView
         end if
         break
      case "List All Behaviors"
         put env_ListBehaviorStackNames() into behaviorStackNames
         set the view_Index [displayWhat] of indexView to behaviorStackNames
         set the mouse_DoubleUpEvent of indexView to "mDouble_DisplayBehavior"
         break
         
         if the shiftKey is "Down" then
            display_ActiveBehaviors
         else
            display_ActiveBehaviors indexView
         end if
      case "-"
      case "List LCW Views"
         if the shiftKey is "Down" then
            display_ActiveViews
         else
            display_ActiveViews indexView
         end if
         break
   end switch
end menu_Display

on submenu_Create
   return "Global | ScriptEditor | Create | Menu"
end submenu_Create

on _
end _

on menu_SetMenu mTarget, shortName
   ide_SetMenuTitle "Recent", shortName
   --
   put ide_GetMenuTitle ("Recent") into mTitle
   menu_Edit mTitle
   put mTitle
end menu_SetMenu

on menu_MenuStyle indexView, mStyle
   set the menu_Style of stack "lib_MenuArray" to mStyle
end menu_MenuStyle

on _
end _

on submenu_Git
   return "Global | GIT | Menu"
end submenu_Git

on menu_WatchEditingScripts indexView, someBoolean
   if someBoolean is true then
      ide_AddRevEditScriptStack "LCW"
   else
      ide_RemoveRevEditScriptStack "LCW"
   end if
end menu_WatchEditingScripts


--> END
-
on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Menu | Props | old
-
getprop m_Styles
   return "Array,Old"
end m_Styles

getprop m_Style
   return the menu_Style of stack "lib_MenuArray"
end m_Style

getprop short_Name
   return ide_ShortTitle ("Recent")
end short_Name

getprop short_Names
   put ide_ListShortMenuTitles ("Recent") into shortNames
   return shortNames
end short_Names

getprop how_Longs
   return "5 min,10 min,20 min,30 min,300 min,-,ask"
end how_Longs

getprop from_Whichs
   return "the used environment,-,the openstacks,the usedstacks"
end from_Whichs

getprop display_What [indexView]
   put the title_Text of indexView into someTitle
   return someTitle
end display_What

getprop display_Whats [indexView]
   return "List Projects,List Active Projects,List All Projects,List Projects and Modules,-,Libraries and Models,Libraries and Models,-,List All Modules,Active Modules,-,Controllers,List All Behaviors,Behaviors,Views"
end display_Whats

getprop active_Projects
   put env_ListProjects() into activeProjects
end active_Projects


--> Global | Environment | Menu | Disabled
-
command init_PlaceArray
   -- ???
   put script_FetchHkeyPlaceArray() into storedHkeyPlaceArray
   put hkeyLine_GetPlaceArray() into hkeyPlaceArray
   put hkeyPlaceArray is not storedHkeyPlaceArray into LocalArray ["storedIsDifferent"]
   return storedHkeyPlaceArray
end init_PlaceArray

getprop disabled_LoadStoredPlaceArray
   return LocalArray ["storedIsDifferent"] is false
end disabled_LoadStoredPlaceArray

getprop disabled_StoreActivePlaceArray
   return LocalArray ["storedIsDifferent"] is false
end disabled_StoreActivePlaceArray

getprop watch_EditingScripts
   put ide_GetRevEditScriptStack ("LCW") into someBoolean
   return someBoolean
end watch_EditingScripts


--> Dev | Menu
-
on menu_IndicateStarted
   display_LcwProjectList
end menu_IndicateStarted

on menu_SetWatchMenu mTarget
   ide_SetScriptEditorTitles "Watch"
end menu_SetWatchMenu

on submenu_Project
   return "Global | Library | Project | Model | Menu"
end submenu_Project

on submenu_Export
   return "Global | Project | Export | Menu"
end submenu_Export

on _
end _

on menu_LivecodePluginArray
   -- ide_AddRevEditScriptStack stackName
   -- this adds the stack stackname to the list of stacks that receive the "revEditScript" command
   -- send "revEditScript tObject" to this card of stack tPlugin
   global gREVMessageDispatch
   display_Array gREVMessageDispatch
end  menu_LivecodePluginArray

on _
end _

on menu_ShrinkStacks indexView, shrinkWhat
   switch shrinkWhat
      case "me"
         stack_Shrink indexView
         break
      case "display"
         put ide_VisibleStackNames ("display") into stackNames
         repeat for each line stackName in stackNames
            put the scaleFactor of stack stackName into someFactor
            if someFactor = 1 then
               put the name of stack stackName into stackObject
               stack_Shrink stackObject
            end if
         end repeat
         break
      case "shrink all"
         put ide_VisibleStackNames ()
         break
      case "-"
      case "restore"
         put ide_VisibleStackNames () into stackNames
         repeat for each line stackName in stackNames
            put the scaleFactor of stack stackName into someFactor
            if someFactor is not 1 then
               -- set the scaleFactor of stack stackName to 1
               put the name of stack stackName into stackObject
               stack_Shrink stackObject, 1
            end if
         end repeat
         break
   end switch
end menu_ShrinkStacks

on _
end _

on menu_LibraryProjectData
   put library_FetchProjectData() into libraryProjectData
   display_Array libraryProjectData, "library_FetchProjectData()", "Global | Library | Project | Model | Menu", "Global | Library | Project | Model | Line | Menu"
end menu_LibraryProjectData

on _
end _

on menu_RecreateScriptOnlyStack
   put lcw_UserMetadataFolder() into textStackRoot
   put folder_ListShort (textStackRoot) into exportedScriptOnlyStacks
   
   local mTitle, mLineTitle, mUp, mDoubleUp
   put "Script-only Stack Exports" into someTitle
   put "doubleup_DisplayScriptOnlyfolder" into mDoubleUp
   display_Index exportedScriptOnlyStacks, someTitle, mTitle, mLineTitle, mUp, mDoubleUp
   -- put the exported_Script of stack "LCW"
end menu_RecreateScriptOnlyStack

on _
end _

on submenu_ProjectTools
   return "Global | Project | Menu"
end submenu_ProjectTools

on submenu_Library
   return "Global | Library | Menu"
end submenu_Library

on submenu_ManageLibrary
   return "Global | Library | Manage | Menu"
end submenu_ManageLibrary

on submenu_Archive
   return "Global | OPN | Save Count | Menu"
end submenu_Archive

on submenu_Mainstack
   return "Global | Script | Mainstack | Menu"
end submenu_Mainstack

on _
end _

on submenu_Teamster
   return "Global | Teamster | Menu"
end submenu_Teamster

on submenu_TextStack
   return "Global | Object | Export | Test | Menu"
end submenu_TextStack

on _
end _

on submenu_Place
   return "Global | Place | Menu"
end submenu_Place

on menu_LibraryProjectData
   put library_FetchProjectData() into libraryProjectData
   display_Array libraryProjectData, "library_FetchProjectData()", "Global | Library | Project | Model | Menu", "Global | Library | Project | Model | Line | Menu"
end menu_LibraryProjectData

on menu_ListLoadedStacks indexView
   put revLoadedStacks ("all") into stackNames
   filter stackNames with "rev*"
   display_Stacks stackNames, indexView
end menu_ListLoadedStacks

on menu_ListIdeLibraryHandlers
   -- put the revAvailablehandlers of stack "revIdeLibrary"
   put the name of stack "revIdeLibrary" into scriptObject
   
   put the script_ShortHkeys of stack "revIdeLibrary" into hKeys
   filter hKeys with "* rev*"
   sort hKeys by word 2 of each
   display_ScriptObject scriptObject, "revIdeLibrary", hKeys
end menu_ListIdeLibraryHandlers

on _
end _

on menu_TidyProjectLibrary
   library_TidyProjectModel
end menu_TidyProjectLibrary

on _
end _

on menu_MultipleHilights treeView
   put the multi_Hilites of treeView
end menu_MultipleHilights


--> Deps
-
function hkeyPlaceArray_ExtractDuplicates hkeyPlaceArray
   local duplicatePlaceArray
   repeat for each key hTableKey in hkeyPlaceArray
      get hkeyPlaceArray [hTableKey]
      if the number of lines of keys (it) > 1 then
         put it into duplicatePlaceArray [hTableKey]
      end if
   end repeat
   return duplicatePlaceArray
end hkeyPlaceArray_ExtractDuplicates
