script "Global | Lexon | Hub | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Lexon | Hub | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
on menu_Init tObject
   -- called only once for top menu
   pass menu_Init
end menu_Init

getprop menu_Target [tObject]
   return the displayed_Object of tObject
end menu_Target


--> Global | Lexon | Hub | Menu
-
on menu_TestBodyRect stackObject
   put the back_View of stackObject into backView
   --
   put the body_Rect of backView into bodyRect
   set the rect_Test ["red"] of card 1 of stackObject to bodyRect
end menu_TestBodyRect

on menu_TestLeftRect stackObject
   put the back_View of stackObject into backView
   --
   put the left_Rect [true] of backView into leftRect
   set the rect_Test ["yellow"] of card 1 of stackObject to leftRect
end menu_TestLeftRect

on menu_TestRealLeftRect stackObject
   put the back_View of stackObject into backView
   --
   put the left_Rect of backView into leftRect
   set the rect_Test ["green"] of card 1 of stackObject to leftRect
end menu_TestRealLeftRect

on _
end _

on menu_BodyLeft stackObject
   put the back_View of stackObject into backView
   --
   put the left of the the field_View of backView into realLeft
   put the body_Left of backView && realLeft
end menu_BodyLeft

on menu_LayoutCard stackObject
   dispatch "LayoutCard" to stackObject
end menu_LayoutCard

on menu_LayoutControl stackObject
   put the long id of control 1 of cd 1 of stackObject into viewObject
   dispatch "LayoutControl" to viewObject
end menu_LayoutControl

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on _Experiment stackObject
   put stackObject
end _Experiment
