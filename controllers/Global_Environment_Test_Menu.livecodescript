script "Global | Environment | Test | Menu"
--> MetaData
-
license: GPLv3
name: Global | Environment | Test | Menu
type: controller
version: 0.1

/*
Here we've dumped all the various tools and tests that were clutering the "Global | Environment | Menu"

The "Global | Environment | Menu" is the one attached to the project display view that start up with LCW.
There are likely a lot of useful things here.
*/

--> Variables
-
local LocalArray


--> Menu | Init
-
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


--> Global | Environment | Test | Menu
-
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

on _
end _

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

on menu_ListLoadedStack sObject
   put revLoadedStacks ("all") into stackNames
   --
   put "rev*" into someFilter
   put lcw_Ask ("Filter stacksinuse with...", someFilter) into someFilter
   --
   filter stackNames with someFilter
   put empty into pIndexView
   display_Stacks stackNames, "Found Stacks"
end menu_ListLoadedStack

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

command init_PlaceArray
-- ???
put script_FetchHkeyPlaceArray() into storedHkeyPlaceArray
put hkeyLine_GetPlaceArray() into hkeyPlaceArray
put hkeyPlaceArray is not storedHkeyPlaceArray into LocalArray ["storedIsDifferent"]
return storedHkeyPlaceArray
end init_PlaceArray


--> Deps
-
