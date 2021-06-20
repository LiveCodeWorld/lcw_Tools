script "Global_Tree_With Title_Menu"
--> MetaData
-
license: GPLv3
name: Global_Tree_With Title_Menu
type: controller
version: 0.2


--> Menu | Props
-
getprop title_MenuItems [mTarget]
   put the title_View of mTarget into titleView
   put the view_PropertyMenu of titleView into someMenu
   return someMenu
end title_MenuItems

getprop field_MenuItems [mTarget]
   put the tree_Field of mTarget into treeField
   put the view_PropertyMenu of treeField into someMenu
   return someMenu
end field_MenuItems


--> Global | Tree | With Title | Menu
-
on menu_TestView viewObject
   put the view_Name of viewObject
end menu_TestView

on _
end _

on menu_ReplaceTitle viewObject, whichTitle
   put the title_View of viewObject into titleView
   switch whichTitle
      case "Tree with title"
         set the control_Type of titleView to "View|Title|Tree"
         break
      case "Placeholder"
         set the control_Type of titleView to "placeholder"
         break
   end switch
end menu_ReplaceTitle


--> Dev | Menu
-
on menu_TreeField mTarget, fieldMenuItem
   put the tree_Field of mTarget into treeField
   view_DoPropertyMenu fieldMenuItem, treeField 
end menu_TreeField

on menu_Title mTarget, titleMenuItem
   put the title_View of mTarget into titleView
   view_DoPropertyMenu titleMenuItem, titleView 
end menu_Title



