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
on menu_CreateLevureProject
   go stack url "https://raw.githubusercontent.com/trevordevore/levure/master/utils/create-levure-application.livecode"
end menu_CreateLevureProject

on menu_SaveEditedStacks
   stack_SaveEdited "all"
end menu_SaveEditedStacks

on menu_NotUpToDate dView
   put git_ListNotUpToDate() into needsUpdating
   set the displayed_Index ["Not Up-to-Date"] of dView to needsUpdating
end menu_NotUpToDate

on _
end _

on submenu_Display
   return "Global | Environment | Display | Menu"
end submenu_Display

on submenu_Projects
   return "Global | LCW | Projects | Menu"
end submenu_Projects

on __
end __

on submenu_Gather
   return "Global | Environment | Gather | Menu"
end submenu_Gather

on submenu_Ide
   return "Global | ScriptEditor | Menu"
end submenu_Ide

on menu_RecentExports mTarget
   put 60 * 60 into howLong
   display_RecentExports howLong
end menu_RecentExports

on ___
end ___

on submenu_Dev
   return "Global | Environment | Dev | Menu"
end submenu_Dev
