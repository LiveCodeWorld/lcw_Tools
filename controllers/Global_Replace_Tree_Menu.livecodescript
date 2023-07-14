script "Global | Replace | Tree | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Replace | Tree | Menu
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
   -- return display_MenuTarget(tObject)
   return the display_View of tObject
end menu_Target


--> Global | Replace | Tree | Menu
-
on menu_SetFoldState displayView
   put false into fState ["Layout"]["folded"]
   set the fold_State of displayView to fState
end menu_SetFoldState

private on _
end _

on menu_Refresh displayView
   put the displayed_Object of displayView into dView
   display_ReplaceWithModule dView
end menu_Refresh
