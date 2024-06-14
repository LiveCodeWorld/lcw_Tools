script "Global | Environment | Menu"
--> MetaData
-
license: GPLv3
name: Global | Environment | Menu
type: controller
version: 0.3

/*
This menu needs tidying - removing the old stuff at the bottom.
*/


--> Variables
-
local LocalArray


--> Menu | Props
-
getprop menu_IsSimple
   return true
end menu_IsSimple

getprop disabled_SaveEditedStacks
   put stack_ListEditedNames() into editedStackNames
   if editedStackNames is empty then
      -- return true
      return "delete"
   else
      return false
   end if
end disabled_SaveEditedStacks


--> Global | Environment | Menu
-
on menu_NotUpToDate dView
   display_NotUpToDate true --, dView
end menu_NotUpToDate

on menu_AutoCommit dView
   env_CommitAndPushEverything dView
end menu_AutoCommit

private on _
end _

on submenu_Display
   return "Global | Environment | Display | Menu"
end submenu_Display

on submenu_Projects
   return "Global | LCW | Projects | Menu"
end submenu_Projects

private on __
end __

on submenu_Gather
   return "Global | Environment | Gather | Menu"
end submenu_Gather

on submenu_Ide
   return "Global | ScriptEditor | Menu"
end submenu_Ide

private on ___
end ___

on menu_SaveStartupProject dView
   put lcw_Ask ("What project would you like to load at startup?", "lcw_Camera", "LCW", dView) into projectName
   env_SaveProjectStartName projectName
end menu_SaveStartupProject

on menu_EditPluginScript
   edit the script of stack "lcw_Plugin"
end menu_EditPluginScript

private on ____
end ____

on menu_RecentExports mTarget
   put 60 * 60 into howLong
   display_RecentExports howLong
end menu_RecentExports

on menu_SaveEditedStacks
   stack_SaveEdited "all"
end menu_SaveEditedStacks

-- on menu_CreateLevureProject
   go stack url "https://raw.githubusercontent.com/trevordevore/levure/master/utils/create-levure-application.livecode"
end menu_CreateLevureProject

private on _____
end _____

on menu_Refresh
   display_RefreshEnvironment
end menu_Refresh

on submenu_Dev
   return "Global | Environment | Dev | Menu"
end submenu_Dev
