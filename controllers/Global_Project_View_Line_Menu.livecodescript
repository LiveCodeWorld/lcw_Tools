script "Global | Project | View | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Project | View | Line | Menu
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
   return the display_View of tObject
end menu_Target


--> Global | Project | View | Line | Menu
-
on menu_DisplayView dView
   put item 2 of the selected_Path of dView into stackName
   -- put the long id of control 1 of stack stackName into viewObject
   --
   go to stack stackName
   --
   put empty into sData
   display_StackTools stackName, "Lexon | Hub", sData
end menu_DisplayView
