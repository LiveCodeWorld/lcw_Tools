script "Global | ViewData | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | ViewData | Line | Menu
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
   put the display_View of tObject into LocalArray ["dView"]
   put the displayed_Object of tObject into viewObject
   return viewObject
end menu_Target

private function _dView
   return LocalArray ["dView"]
end _dView

private function _SelectedLine
   return the selected_Line of _dView()
end _SelectedLine

getprop menu_CheckTarget [dView]
   return exists (dView)
end menu_CheckTarget

on mDoubleUp_ViewData displayView, someLine
   put the title_Text of displayView into viewName
   put the selected_Path of displayView into sPath
   put the displayed_Data of displayView into dData
   switch item 1 of sPath
      case "dictionary"
         put item 2 of sPath into itemNum
         put dData ["dictionary"][itemNum] into itemArray
         put itemArray ["behavior"] into bObject
         --
         edit the script of bObject
         break
      case "nestedArray"
         breakpoint
         break
   end switch
end mDoubleUp_ViewData


--> Global | ViewData | Line | Menu
-
on menu_ViewdataLine viewObject
   put the params
end menu_ViewdataLine

private on _
end _

on menu_EditBehavior viewObject
   put _SelectedLine() into bObject
   edit the script of bObject
end menu_EditBehavior

getprop disabled_EditBehavior [dView]
   get the title_Text of _dView()
   return it is not "the view_CardBehaviorObjects"
end disabled_EditBehavior

private on __
end __

on submenu_Dev
   return menu_DevTitle ("Global | ViewData | Line | Menu")
end submenu_Dev
