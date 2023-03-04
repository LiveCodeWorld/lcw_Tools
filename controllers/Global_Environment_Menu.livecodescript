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


--> Global | Environment | Menu
-
on menu_SaveEditedStacks
   stack_SaveEdited "all"
end menu_SaveEditedStacks

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

on _
end _

on submenu_Projects
   return "Global | LCW | Projects | Menu"
end submenu_Projects

on submenu_Display
   return "Global | Environment | Display | Menu"
end submenu_Display

on submenu_Gather
   return "Global | Environment | Gather | Menu"
end submenu_Gather

on _
end _

on submenu_Server
   return "Global | Environment | Server | Menu"
end submenu_Server

on submenu_Ide
   return "Global | ScriptEditor | Menu"
end submenu_Ide

on submenu_Dev
   return "Global | Environment | Dev | Menu"
end submenu_Dev

on _
end _

on menu_RecentExports mTarget
   put 60 * 60 into howLong
   display_RecentExports howLong
end menu_RecentExports

on _Refresh
   display_Environment
end _Refresh
