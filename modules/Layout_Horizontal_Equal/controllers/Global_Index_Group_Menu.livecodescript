script "Global | Index | Group | Menu"
--> MetaData
-
license: GPLv3
name: Global | Index | Group | Menu
type: controller
version: 0.2


--> Menu | Init
-
getprop views_Params
   put view_ListOpen ("Placeholder") into mItems
   return mItems
end views_Params


--> Global | Index | Group | Menu
-
on menu_SetViewSpacing indexGroup
   put the view_Spacing of indexGroup into vSpacing
   put lcw_Ask ("What spacing do you want between views?", vSpacing) into vSpacing
   set the view_Spacing of indexGroup to vSpacing
end menu_SetViewSpacing

on menu_Views indexGroup, vName
   put the child_Views of indexGroup into childViews
   repeat for each line childView in childViews
      set the control_Type of childView to "placeholder"
   end repeat
end menu_Views

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_UpdateViews indexGroup
   put the child_Views of indexGroup into childViews
   repeat for each line childView in childViews
      view_Update childView
   end repeat
end menu_UpdateViews
