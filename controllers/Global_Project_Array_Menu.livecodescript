script "Global | Project | Array | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Project | Array | Menu
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


--> Global | Project | Array | Menu
-
on menu_GetProjectArray displayView
   put the title_Text of displayView into projectName
   --
   put project_GetArray (projectName, false) into projectArray
   set the displayed_Data of displayView to projectArray
end menu_GetProjectArray

on menu_ReconstructProjectArray displayView
   put the title_Text of displayView into projectName
   --
   put project_GetArray (projectName, true) into projectArray
   set the displayed_Data of displayView to projectArray
end menu_ReconstructProjectArray
