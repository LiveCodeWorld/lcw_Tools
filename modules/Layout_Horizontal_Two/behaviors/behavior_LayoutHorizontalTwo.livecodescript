script "behavior_View|Layouts|Horizontal|Two"
--> MetaData
-
license: GPLv3
name: behavior_View|Layouts|Horizontal|Two
type: view behavior
version: 0.1
copyright: David Bovill

/*
This layout allows you to resize two horzontally divided panes.

There seems to be a bug regarding resizing - the veritcal bar and the margin.
*/


--> Variables
-
local LocalArray
local LeftView, RightView


--> Working on
-
on Refresh
   GuessViewReferences
   --
   preOpenControl
   LayoutControl
   --
   ClearStoredViewReferences
end Refresh

on GuessViewReferences
   put _GetFirstView() into LeftView
   get _GetSecondView()
   if it is not LeftView then
      put it into RightView
   else
      breakpoint -- must be a bug???
   end if
end GuessViewReferences

on StoreViewReferences pSaveStack
   # Fix RightView
   if exists (LeftView) then
      set the uOPN ["LeftView"] of me to LeftView
   else
      breakpoint
      set the uOPN ["LeftView"] of me to empty
   end if
   
   # Fix RightView
   if exists (RightView) then
      set the uOPN ["RightView"] of me to RightView
   else
      breakpoint
      set the uOPN ["RightView"] of me to empty
   end if
   
   if pSaveStack is true then
      put the stack_Name of me into stackName
      save stack stackName
   end if
end StoreViewReferences

on ClearStoredViewReferences pSaveStack
   set the uOPN ["left_Name"] of me to empty
   set the uOPN ["right_Name"] of me to empty
   
   if pSaveStack is true then
      put the stack_Name of me into stackName
      save stack stackName
   end if
end ClearStoredViewReferences

getprop vertical_Divider
   if exists (control "_VerticalDivider View" of me) is false then return empty
   return the long id of control "_VerticalDivider View" of me
end vertical_Divider

setprop left_View vObject
   if exists (vObject) is false then return empty
   put revRuggedID (vObject) into LeftView
   --
   set the uOPN ["LeftView"] of me to LeftView
   return LeftView
end left_View

setprop right_View vObject
   if exists (vObject) is false then return empty
   put revRuggedID (vObject) into RightView
   set the uOPN ["RightView"] of me to RightView
   return RightView
end right_View


--> Initialisation
-
private function _GetFirstView
   _SetFirstAndSecond firstChildID, secondChildID
   --
   if exists (control id firstChildID of me) then
      put the long id of control id firstChildID of me into firstView
      return revRuggedId (firstView)
   else
      return empty
   end if
end _GetFirstView

private function _GetSecondView
   _SetFirstAndSecond firstChildID, secondChildID
   --
   if exists (control id secondChildID of me) then
      put the long id of control id secondChildID of me into secondView
      return revRuggedId (secondView)
   else
      return empty
   end if
end _GetSecondView

private command _SetFirstAndSecond @firstChildID, @secondChildID
   put the childcontrolids of me into childIDs
   put word 3 of the vertical_Divider of me into verticalDividerID
   
   set the wholematches to true
   put lineOffset (verticalDividerID, childIDs) into lineNum
   delete line lineNum of childIDs
   
   put line 1 of childIDs into firstChildID
   put line 2 of childIDs into secondChildID
end _SetFirstAndSecond


--> Init
-
on preOpenControl
   _SetLeftViewLocal
   _SetRightViewLocal
   --
   pass preOpenControl
end preOpenControl

private command _SetLeftViewLocal
   put the left_Name of me into leftName
   if exists (control leftName of me) is false then
      put empty into LeftView
   else
      put the long id of control leftName of me into LeftView
   end if
end _SetLeftViewLocal

private command _SetRightViewLocal
   put the right_Name of me into rightName
   if exists (control rightName of me) is false then
      put empty into RightView
   else
      put the long id of control rightName of me into RightView
   end if
end _SetRightViewLocal

getprop left_Name
   put the uOPN ["left_Name"] of me into leftName
   return leftName
end left_Name

setprop left_Name leftName
   set the uOPN ["left_Name"] of me to leftName
end left_Name

getprop right_Name
   put the uOPN ["right_Name"] of me into rightName
   return rightName
end right_Name

setprop right_Name rightName
   set the uOPN ["right_Name"] of me to rightName
end right_Name


--> View
-
getprop view_Type
   if exists (LeftView) is false then return empty
   if exists (RightView) is false then return empty
   
   put label_ViewToCamelTitle (the view_Name of LeftView) into firstViewName
   put label_ViewToCamelTitle (the view_Name of RightView) into secondViewName
   --
   switch
      case secondViewName is empty
         return firstViewName
      case firstViewName = secondViewName
         return firstViewName
      default
         return firstViewName,secondViewName
   end switch
end view_Type

setprop view_Type camelTitle
   switch camelTitle
      case "placeholder"
         put "placeholder" into viewName
         break
      default
         put label_CamelTitleToView (camelTitle) into viewName
   end switch
   --
   if viewName is empty then
      put "placeholder" into firstViewName
      put "placeholder" into secondViewName
   else
      put item 1 of viewName into firstViewName
      put item 2 of viewName into secondViewName
      if secondViewName is empty then
         put firstViewName into secondViewName
      end if
   end if
   
   # Set (replace) views
   set the control_Type ["left_View"] of LeftView to firstViewName
   set the control_Type ["right_View"] of RightView to secondViewName
end view_Type

on layout_SetLastLeftViewWidth
   -- used by divider
   put the width of LeftView into leftViewWidth
   _SetLastLeftViewWidth leftViewWidth
end layout_SetLastLeftViewWidth

private function _GetLastViewWidth
   put LocalArray ["leftViewWidth"] into leftViewWidth
   if leftViewWidth is empty then put the width of leftView into leftViewWidth
   return leftViewWidth
end _GetLastViewWidth

private command _SetLastLeftViewWidth leftViewWidth
   put leftViewWidth into LocalArray ["leftViewWidth"]
end _SetLastLeftViewWidth

private function _GetLastTotalWidth
   put LocalArray ["lastTotalWidth"] into lastTotalWidth
   if lastTotalWidth is empty then put the width of me into lastTotalWidth
   return lastTotalWidth
end _GetLastTotalWidth

private command _SetLastTotalWidth newLayoutWidth
   put newLayoutWidth into LocalArray ["lastTotalWidth"]
end _SetLastTotalWidth


--> Events
-
on resizeControl
   if the long id of the target is not the long id of me then pass resizeControl -- needed???
   LayoutControl the rect of me
end resizeControl


--> Layout
-
getprop layout_ViewNames
   put the view_Name of LeftView into firstViewName
   put the view_Name of RightView into secondViewName
   --
   switch
      case secondViewName is empty
         return firstViewName
      case firstViewName = secondViewName
         return firstViewName
      default
         return firstViewName,secondViewName
   end switch
end layout_ViewNames

getprop layout_Views
   return LeftView & CR & RightView
end layout_Views

getprop layout_Elements
   if the long id of the target is not the long id of me then pass layout_Elements
   
   repeat for each item objectRef in "left_View,right_View"
      put the objectRef of me into someView
      put the layout_Elements of someView into viewElements
      if viewElements is empty then
         put someView & CR after layoutElements
      else
         put viewElements & CR after layoutElements
      end if
   end repeat
   delete char -1 of layoutElements
   return layoutElements
end layout_Elements

getprop top_ControlNames
   put the childcontrolids of me into topIDs
   repeat for each line someID in topIDs
      put the short name of control id someID & CR after topNames
   end repeat
   delete char -1 of topNames
   return topNames
end top_ControlNames

getprop top_Controls
   put the childcontrolids of me into topIDs
   repeat for each line someID in topIDs
      put the long id of control id someID & CR after topControls
   end repeat
   delete char -1 of topControls
   return topControls
end top_Controls



--> Props
-
getprop horizontal_Spacing
   -- put LocalArray ["horizontal_Spacing"] into someSpacing
   put the uOPN ["horizontal_Spacing"] of me into someSpacing
   if someSpacing is empty then put 4 into someSpacing
   return someSpacing
end horizontal_Spacing

setprop horizontal_Spacing [dontLayout] someSpacing
   set the uOPN ["horizontal_Spacing"] of me to someSpacing
   if dontLayout is not true then
      -- dispatch "LayoutControl" to me
      LayoutControl
   end if
end horizontal_Spacing

getprop fixed_View
   -- put LocalArray ["fixed_View"] into leftOrRight
   put the uOPN ["fixed_View"] of me into leftOrRight
   if leftOrRight is empty then return "left"
   return leftOrRight
end fixed_View

setprop fixed_View [dontLayout] leftOrRight
   -- put leftOrRight into LocalArray ["fixed_View"]
   set the uOPN ["fixed_View"] of me to leftOrRight
   if dontLayout is not true then
      LayoutControl
   end if
end fixed_View

getprop left_View
   return LeftView
end left_View

getprop right_View
   return RightView
end right_View


--> Geometry
-
on LayoutControl pRect
   if the long id of the target is not the long id of me then return empty -- this is important for nested datagrids at the moment.
   if pRect is empty then put the the rect of me into pRect
   
   put the left_View of me into leftView
   if exists (leftView) is false then return false
   put the right_View of me into rightView
   if exists (rightView) is false then return false
   put the vertical_Divider of me into verticalDividerView
   
   put the inner_rect [pRect] of me into innerRect
   --
   switch
      case the visible of leftView is false
         put innerRect into leftViewRect
         put innerRect into rightViewRect
         put innerRect into verticalDividerRect
         set the visible of verticalDividerView to false
         break
      case the visible of rightView is false
         put innerRect into leftViewRect
         put innerRect into rightViewRect
         put innerRect into verticalDividerRect
         set the visible of verticalDividerView to false
         break
      default -- they are both visible
         set the visible of verticalDividerView to true
         
         put the horizontal_Spacing of me into viewSpacing
         put item 3 of pRect - item 1 of pRect into newLayoutWidth
         
         put layout_GetLeftViewWidth (newLayoutWidth, leftView, rightView, verticalDividerView) into leftViewWidth
         
         -- left_View rect
         put innerRect into leftViewRect
         put item 1 of leftViewRect + leftViewWidth into leftViewRight
         put leftViewRight into item 3 of leftViewRect
         
         -- vertical_Divider Rect
         put innerRect into verticalDividerRect
         put leftViewRight into item 1 of verticalDividerRect
         put leftViewRight + viewSpacing into rightViewLeft
         put rightViewLeft into item 3 of verticalDividerRect
         
         -- right_View rect
         put innerRect into rightViewRect
         put rightViewLeft into item 1 of rightViewRect
         
         _SetLastLeftViewWidth leftViewWidth
         _SetLastTotalWidth newLayoutWidth
   end switch
   
   -- Set Rects
   lock screen
   set the rect of leftView to leftViewRect
   set the rect of verticalDividerView to verticalDividerRect -- to rest locals for stability hack
   -- set the view_Rect of verticalDividerView to verticalDividerRect -- to rest locals for stability hack
   set the rect of rightView to rightViewRect
   unlock screen   
end LayoutControl


--> Views
-
getprop horizontal_Layout
   return the long id of me
end horizontal_Layout

getprop layout_View
   return the long id of me
end layout_View

getprop view_Object
   return the long id of me
end view_Object


--> Geometry | Layout
-
setprop layout_Margins someMargin
   lock screen
   put the rect of me into oRect
   set the margins of me to someMargin
   LayoutControl oRect
   unlock screen
end layout_Margins

getprop layout_Margins
   return the margins of me
end layout_Margins

getprop fixed_Views
   return "left,right,formatted,proportional"
end fixed_Views

getprop layout_DividerStyle
   return the divider_Style of the vertical_Divider of me
end layout_DividerStyle

setprop layout_DividerStyle someStyle
   set the divider_Style of the vertical_Divider of me to someStyle
end layout_DividerStyle

getprop layout_DividerStyles
   return "invisible,transparent,opaque,icon"
end layout_DividerStyles


--> Show and Hide
-
getprop hidden_View
   switch
      case the visible of the left_View of me = false
         return "left"
      case the visible of the right_View of me = false
         return "right"
      default
         return "none"
   end switch      
end hidden_View

setprop left_Only sBooelan
   _SetViews leftView, rightView, verticalDivider
   --
   set the visible of leftView to sBooelan
   set the visible of rightView to (sBooelan is false)
   set the visible of verticalDivider to (sBooelan is false)
end left_Only

getprop left_Visible
   put the visible of the left_View of me into sBooelan
   return sBooelan
end left_Visible

setprop left_Visible sBooelan
   put the rect of me into pRect
   _SetViews leftView, rightView, verticalDivider
   
   lock screen
   set the visible of leftView to sBooelan
   put sBooelan AND the visible of verticalDivider into dividerVisible
   set the visible of verticalDivider to dividerVisible
   --
   LayoutControl pRect
   unlock screen
end left_Visible

getprop right_Visible
   put the visible of the right_View of me into sBooelan
   return sBooelan
end right_Visible

setprop right_Visible sBooelan
   put the rect of me into pRect
   _SetViews leftView, rightView, verticalDivider
   
   put the visible of leftView into leftVisible
   put sBooelan AND leftVisible into ndVis
   
   lock screen
   set the visible of rightView to sBooelan
   set the visible of verticalDivider to ndVis
   --
   LayoutControl pRect
   unlock screen
end right_Visible

private command _SetViews @leftView, @rightView, @verticalDivider
   put the left_View of me into leftView
   put the right_View of me into rightView
   put the vertical_Divider of me into verticalDivider
end _SetViews

setprop hidden_View whichView
   -- lcw_Notify whichView
   lock screen
   put the rect of me into oRect
   
   switch word 1 of whichView
      case "left"
         set the left_Only of me to true
         break
      case "right"
         set the right_Visible of me to true
         break
      case "none"
      default
         set the visible of leftView to true
         set the visible of rightView to true
         set the visible of verticalDivider to true
         
         put _GetLastViewWidth() into lastLeft
         get item 1 of whichView
         if it is a number then
            set the width of leftView to it
         else if lastLeft is a number then
            set the width of leftView to lastLeft
         end if
   end switch
   LayoutControl oRect
   unlock screen
end hidden_View


--> Geometry | Right View | Width
-
/*
I think this needs tidying to work like title_Height
*/

getprop right_Width
   return the width of the right_View of me
end right_Width

setprop right_Width someWidth
   lock screen
   put the the rect of me into oRect
   set the fixed_View of me to "right"
   set the width of the right_View of me to someWidth
   LayoutControl oRect
   unlock screen
end right_Width


--> Geometry | Left View | Width
-
/*
I think this needs tidying to work like title_Height
*/

getprop left_Width
   return the width of the left_View of me
end left_Width

setprop left_Width someWidth
   lock screen
   put the the rect of me into oRect
   set the fixed_View of me to "left"
   set the width of the left_View of me to someWidth
   LayoutControl oRect
   unlock screen
end left_Width


--> Geometry | Subview Defaults
-
getprop formatted_Width
   return the width of the target
end formatted_Width


--> Private
-
private function layout_GetLeftViewWidth newLayoutWidth, leftView, rightView, verticalDividerView
   put the fixed_View of me into fixedView
   switch fixedView
      case "right"
         put the width of rightView into rightViewWidth
         put the width of verticalDividerView into leftViewWidth
         
         put the margins of me into someMargin
         margin_Normalize someMargin, left_Margin, top_Margin, right_Margin, bottom_Margin
         put right_Margin + left_Margin into extraBit
         if the showborder of me is true then
            add 2 * the borderwidth of me to extraBit
         end if
         
         return newLayoutWidth - rightViewWidth - leftViewWidth - extraBit
      case "formatted"
         put the formatted_Width of leftView into leftViewWidth
         put the width of me into totalWidth
         put leftViewWidth / totalWidth into widthProportion
         return round(newLayoutWidth * widthProportion)
      case "half"
         return round(newLayoutWidth / 2)
      case "proportional"
         put _GetLastViewWidth() into lastLeft
         put _GetLastTotalWidth() into lastTotalWidth
         
         put lastLeft / lastTotalWidth into widthProportion
         put round(newLayoutWidth * widthProportion) into newLeftWidth
         return newLeftWidth
      default -- case "left"
         get the width of leftView
         return it
   end switch
end layout_GetLeftViewWidth
