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
end menu_Target

getprop disabled_DispatchResizeControl [viewObject]
   return the behavior_HandlerExists ["M resizeControl"] of viewObject is false
end disabled_DispatchResizeControl

getprop disabled_DispatchPreopenControl [viewObject]
   return the behavior_HandlerExists ["M preOpenControl"] of viewObject is false
end disabled_DispatchPreopenControl

getprop disabled_DispatchPreopenCard [viewObject]
   return the behavior_HandlerExists ["M preOpenCard"] of viewObject is false
end disabled_DispatchPreopenCard

getprop disabled_DispatchResizeToFit [viewObject]
   switch
      case exists (the dvControl of viewObject )
         return false
      default
         return true
   end switch
end disabled_DispatchResizeToFit

getprop disabled_LayoutViewOnCard [viewObject]
   put the view_Name of viewObject into viewName
   switch
      case viewName is not empty
         return false
      default
         return true
   end switch
end disabled_LayoutViewOnCard

getprop disabled_RestoreGeometry [vObject]
   put the rect_Array of vObject into rectArray
   if rectArray is an array then
      return false
   else
      return true
   end if
end disabled_RestoreGeometry

private command _HandleDispatch dispatchResult, viewObject, cardObject
   switch dispatchResult
      case "unhandled"
         breakpoint  
         lcw_Notify merge ("'Layoutcontrol' unhandled by view [[the name of viewObject]]!")
         
         put the behavior of viewObject into bObject
         if exists (bObject) then
            edit the script of bObject
         end if
         
         put the card_Object of viewObject into cardObject
         display_BrokenBehaviors cardObject, true
         break
      default
         put the rect of viewObject into vRect
         if vRect = vCardRect then
            lcw_Notify merge ("Dispatched 'Layoutcontrol' to view [[the name of viewObject]]!")
         else
            /*
            set the rect_Test ["red"] of cardObject to vCardRect
            set the rect_Test ["yellow"] of cardObject to vRect
            */
         end if
   end switch
end _HandleDispatch


--> Global | View | Geometry | Menu
-
on menu_Clone vObject
   put the stack_Name of vObject into stackNameToClone
   stack_Clone stackNameToClone
end menu_Clone

on menu_SetCardMargin vObject
   put the card_Margin of vObject into cMargin
   put lcw_Ask ("Set the card_Margin of this card to:", cMargin, someView) into newMargin
   set the card_margin of vObject to newMargin
end menu_SetCardMargin

private on ___
end ___

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
   --
   _HandleDispatch it, viewObject, cardObject
end menu_LayoutViewOnCard

on menu_SetRect viewObject
   put the card_Object of viewObject into cardObject
   put the view_RectOnCard of cardObject into vCardRect
   --
   set the rect of viewObject to vCardRect
end menu_SetRect

private on _
end _

on submenu_Card
   return "Global | Card | Menu"
end submenu_Card

on submenu_MoreTests
   return "Global | View | Test | Geometry | Menu"
end submenu_MoreTests
