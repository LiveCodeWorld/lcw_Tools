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

on menu_Init tObject
   put the stack_Name of tObject into dStackName
   put dStackName into LocalArray ["dStackName"]
   put the topleft of stack dStackName into LocalArray ["stackTopLeft"]
end menu_Init

getprop menu_Target [tObject]
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

getprop disabled_DispatchLayoutControl [viewObject]
   put the view_Name of viewObject into viewName
   switch
      case viewName is not empty
         return false
      default
         return true
   end switch
end disabled_DispatchLayoutControl


--> Global | View | Geometry | Menu
-
on menu_Clone viewObject
   put the stack_Name of viewObject into stackNameToClone
   stack_Clone stackNameToClone
end menu_Clone

on _
end _

on menu_DispatchResizeToFit viewObject
   dispatch "ResizeToFit" to viewObject
end menu_DispatchResizeToFit

on menu_DispatchLayoutControl viewObject
   put the card_Object of viewObject into cardObject
   put the view_RectOnCard of cardObject into cardRect
   
   if the shiftKey is "Down" then breakpoint
   dispatch "LayoutControl" to viewObject with cardRect
   switch it
      case "unhandled"
         -- breakpoint  
         lcw_Notify merge ("'Layoutcontrol' unhandled by view [[the name of viewObject]]!")
         
         put the behavior of viewObject into bObject
         if exists (bObject) then
            edit the script of bObject
         end if
         
         put the card_Object of viewObject into cardObject
         display_BrokenBehaviors cardObject, true
         break
      default
         lcw_Notify merge ("Dispatched 'Layoutcontrol' to view [[the name of viewObject]]!")
   end switch
end menu_DispatchLayoutControl

on _
end _

on menu_SixLayoutTests someView
   put the card_Object of someView into cardControl
   put the view_RectOnCard of cardControl into cardRect
   
   repeat 6
      set the cursor to busy
      dispatch "LayoutControl" to someView with cardRect
   end repeat
   
   put merge ("Dispatched 'LayoutControl' to [[the name of someView]] 6 times") into someComment
   lcw_Notify someComment
end menu_SixLayoutTests

on menu_SetCardMargin vObject
   put the card_Margin of vObject into cMargin
   put lcw_Ask ("Set the card_Margin of this card to:", cMargin, someView) into newMargin
   set the card_margin of vObject to newMargin
end menu_SetCardMargin

on _
end _

on menu_DispatchResizeStack vObject
   put the card_Object of vObject into cardObject
   dispatch "resizeStack" to cardObject
end menu_DispatchResizeStack

on menu_DispatchResizeControl vObject
   dispatch "resizeControl" to vObject
end menu_DispatchResizeControl

on menu_DispatchPreopenCard viewObject
   if the shiftKey is "Down" then breakpoint
   dispatch "preOpenCard" to viewObject
end menu_DispatchPreopenCard

on menu_DispatchPreopenControl viewObject
   if the shiftKey is "Down" then breakpoint
   dispatch "preOpenControl" to viewObject
   switch it
      case "unhandled"
         put the card_Object of viewObject into cardObject
         display_BrokenBehaviors cardObject, true
         break
      default
         -- all is fine
   end switch
end menu_DispatchPreopenControl

on _
end _

on menu_Gather vObject
   put LocalArray ["stackTopLeft"] into stackTopLeft
   put the stack_Name of vObject into vStackName
   --
   set the topleft of stack vStackName to stackTopLeft
   show stack vStackName
end menu_Gather

on submenu_MoreTests
   return "Global | View | Test | Geometry | Menu"
end submenu_MoreTests

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_EditCardBehavior vObject
   put the card_Object of vObject into cObject
   put the behavior of cObject into bObject
   if exists (bObject) then
      edit the script of bObject
   else
      lcw_AnswerWarning "There is no behavior for this card!", vObject
   end if
end menu_EditCardBehavior

on menu_TestViewRectOnCard vObject
   put the card_Object of vObject into cObject
   --
   put the view_RectOnCard of cObject into viewRect
   rect_Test viewRect, cObject
end menu_TestViewRectOnCard

on menu_SetViewRect vObject
   put the view_RectOnCard of vObject into viewRect
   set the rect of vObject to viewRect
end menu_SetViewRect
