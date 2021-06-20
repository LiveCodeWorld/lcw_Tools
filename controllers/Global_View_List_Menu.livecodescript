script "Global | View | List | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | View | List | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   -- called first
   put the display_View of tObject into displayView
   put the displayed_Data of displayView into LocalArray ["dataArray"]
   --
   return displayView
end menu_Target


--> Global | View | List | Menu
-
on mmenu_RevealCloudFolder
   put "/Users/fortyfoxes/Documents/My Revolution Enterprise/Plugins/opn_Plugins/opn_Components/views" into someFolder
   finder_Reveal someFolder
end mmenu_RevealCloudFolder

on menu_LaunchGithubViews
   launch url "https://github.com/opn/OPN/tree/master/opn_Plugins/opn_Components/views"
end menu_LaunchGithubViews

on _
end _

on submenu_Environment
   return "Global | Environment | Menu"
end submenu_Environment

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_Refresh
   display_EnvironmentViews
end menu_Refresh



--> Deps
-
