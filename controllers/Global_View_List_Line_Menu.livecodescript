script "Global | View | List | Line | Menu"
--> MetaData
-
copyright: David bovill
license: GPLv3
name: Global | View | List | Line | Menu
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


--> Global | View | List | Line | Menu
-
on menu_Go dView
   put the selected_Line of dView into vName
   put view_GetTemplateObject (vName) into tObject
   object_GoTo tObject
end menu_Go

on _
end _

on menu_ViewTools dView
   put the selected_Line of dView into vName
   display_ViewTools vName
end menu_ViewTools

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_Experiment displayView
   put displayView
end menu_Experiment
