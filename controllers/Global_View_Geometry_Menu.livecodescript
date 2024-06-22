script "Global | View | Geometry | Menu"
--> MetaData
-
license: GPLv3
name: Global | View | Geometry | Menu
type: controller
version: 0.2

--> Menu | Props
-
local LocalArray

getprop menu_Target [tObject]
   put the displayed_Object of tObject into viewObject
   return viewObject
end menu_Target

getprop menu_CheckTarget [viewObject]
   return exists (viewObject)
end menu_CheckTarget

function _DodgyView tObject
   put the stack_Name of tObject into dStackName
   put dStackName into LocalArray ["dStackName"]
   put the topleft of stack dStackName into LocalArray ["stackTopLeft"]
   
   put the display_View of tObject into displayView
   switch
      case exists (displayView)
         put the displayed_Object of displayView into viewObject
         return viewObject
      case the view_Name of tObject is not empty
         return tObject
      default
         put the card_Object of tObject into cardObject
         if exists (control 1 of cardObject) then
            return the long id of control 1 of cardObject
         else
            return cardObject
         end if
   end switch
end _DodgyView


--> Global | View | Geometry | Menu
-
on menu_Clone vObject
   put the stack_Name of vObject into cStackName
   display_CloneTools cStackName
end menu_Clone

on menu_SetCardMargin vObject
   put the card_Margin of vObject into cMargin
   put lcw_Ask ("Set the card_Margin of this card to:", cMargin, someView) into newMargin
   set the card_margin of vObject to newMargin
end menu_SetCardMargin

private on _
end _

on menu_LayoutControl vObject
   if the shiftKey is "Down" then breakpoint
   put the rect of vObject into oRect
   dispatch "LayoutControl" to vObject with oRect
end menu_LayoutControl

on menu_LayoutViewOnCard viewObject
   put the card_Object of viewObject into cardObject
   put the view_RectOnCard of cardObject into vCardRect
   
   if the shiftKey is "Down" then breakpoint
   dispatch "LayoutControl" to viewObject with vCardRect
end menu_LayoutViewOnCard

on menu_LayoutCard viewObject
   put the card_Object of viewObject into cardObject
   
   if the shiftKey is "Down" then breakpoint
   dispatch "LayoutCard" to cardObject
end menu_LayoutCard

private on __
end __

on menu_SetRect viewObject
   put the card_Object of viewObject into cardObject
   put the view_RectOnCard of cardObject into vCardRect
   --
   set the rect of viewObject to vCardRect
end menu_SetRect

private on ___
end ___

on submenu_Dev
   return "Global | View | Test | Geometry | Menu"
end submenu_Dev
