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


--> Menu | Init
-
getprop disabled_Server
   put mArray_GetSimple() into isSimple
   return isSimple
end disabled_Server

getprop disabled_SaveEditedStacks
   put stack_ListEditedNames() into editedStackNames
   if editedStackNames is empty then
      -- return true
      return "delete"
   else
      return false
   end if
end disabled_SaveEditedStacks


--> sShell
-
on menu_SaveEditedStacks
   stack_SaveEdited "all"
end menu_SaveEditedStacks

on menu_NotUpToDate dView
   put git_ListNotUpToDate() into needsUpdating
   set the displayed_Index ["Not Up-to-Date"] of dView to needsUpdating
end menu_NotUpToDate

on _
end _

on submenu_TransportServer
   return "Global | Transport | Model | Menu"
end submenu_TransportServer

on submenu_Atopia
   return "Global | Environment | Atopia | Menu"
end submenu_Atopia

on menu_FederationModels
   display_FederationModels
end menu_FederationModels

on menu_FederationTools
   put fedray_FetchModel() into fedray
   display_Tools fedray, "Federation Model", "Federation", "LCW", "lcw_Server"
end menu_FederationTools

on menu_ServerTools
   display_Tools someData, "Federation Servers", "Federation | Server", "LCW", "lcw_Server"
end menu_ServerTools

on __
end __

on submenu_Projects
   return "Global | LCW | Projects | Menu"
end submenu_Projects

on submenu_Display
   return "Global | Environment | Display | Menu"
end submenu_Display

on submenu_Gather
   return "Global | Environment | Gather | Menu"
end submenu_Gather

on ___
end ___

on submenu_Server
   return "Global | Environment | Server | Menu"
end submenu_Server

on submenu_Ide
   return "Global | ScriptEditor | Menu"
end submenu_Ide

on submenu_Dev
   return "Global | Environment | Dev | Menu"
end submenu_Dev

on ____
end ____

on menu_RecentExports mTarget
   put 60 * 60 into howLong
   display_RecentExports howLong
end menu_RecentExports

on submenu_Install
   return "Global | Install | Menu"
end submenu_Install

on _Refresh
   display_Environment
end _Refresh
