script "Global | Environment | Atopia | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Environment | Atopia | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-

--> Global | Environment | Atopia | Menu
-
on menu_DisplayAtopiaCatModel
   display_AtopiaCatModel
end menu_DisplayAtopiaCatModel

on menu_UpdateAtopiaFromCatModel
   put atopia_ConstructCatModel() into atopiaCatModel
   --
   lcw_Answer "Are you sure you want to trash and update metadata for all these Atopia domains?", displayView
   --
   atopia_UpdateFromCatModel atopiaCatModel
   --
   display_AtopiaCatModel
end menu_UpdateAtopiaFromCatModel

on submenu_TransportServer
   return "Global | Transport | Model | Menu"
end submenu_TransportServer

on _
end _

on _DisplayNewAtopiaFolders
   display_AtopiaNewFolders
end _DisplayNewAtopiaFolders

on _DisplayAtopiaLogs
   put "/var/log/upstart/wiki.log" into logPath
   put atopia_FetchData (logPath) into logData
   --
   atom_DisplayText logData
end _DisplayAtopiaLogs

on _DisplayAtopiaAuthors
   display_AuthorData
end _DisplayAtopiaAuthors

on _DisplayFederationServers
   display_FederationServers
end _DisplayFederationServers


