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
local LeftView, RightView, DividerView


--> Working on
-
getprop layout_DividerStyle
   return the divider_Style of the vertical_Divider of me
end layout_DividerStyle

setprop layout_DividerStyle someStyle
   set the divider_Style of the vertical_Divider of me to someStyle
end layout_DividerStyle

getprop layout_DividerStyles
   return "invisible,transparent,opaque,icon"
end layout_DividerStyles


--> Events
-
on preOpenControl
   _SetLeftViewLocal
   _SetRightViewLocal
   _SetDividerViewLocal
   --
   pass preOpenControl
end preOpenControl

private command _SetDividerViewLocal
   put the vertical_Divider of me into DividerView
end _SetDividerViewLocal

on resizeControl
   if the long id of the target is not the long id of me then pass resizeControl -- needed???
   LayoutControl the rect of me
end resizeControl

on LayoutControl pRect
   if the long id of the target is not the long id of me then return empty -- this is important for nested datagrids at the moment.
   if pRect is empty then put the the rect of me into pRect
   
   # Safety Checks
   if exists (DividerView) is false then return false
   if exists (LeftView) is false then return false
   if exists (RightView) is false then return false
   
   put the inner_rect [pRect] of me into innerRect
   --
   switch
      case the visible of LeftView is false
         put innerRect into leftViewRect
         put innerRect into rightViewRect
         put innerRect into verticalDividerRect
         set the visible of DividerView to false
         break
      case the visible of RightView is false
         put innerRect into leftViewRect
         put innerRect into rightViewRect
         put innerRect into verticalDividerRect
         set the visible of DividerView to false
         break
      default -- they are both visible
         set the visible of DividerView to true
         
         put the horizontal_Spacing of me into viewSpacing
         put item 3 of pRect - item 1 of pRect into newLayoutWidth
         
         put layout_GetLeftViewWidth (newLayoutWidth, leftView, rightView, DividerView) into leftViewWidth
         
         # left_View rect
         put innerRect into leftViewRect
         put item 1 of leftViewRect + leftViewWidth into leftViewRight
         put leftViewRight into item 3 of leftViewRect
         
         # vertical_Divider Rect
         put innerRect into verticalDividerRect
         put leftViewRight into item 1 of verticalDividerRect
         put leftViewRight + viewSpacing into rightViewLeft
         put rightViewLeft into item 3 of verticalDividerRect
         
         # right_View rect
         put innerRect into rightViewRect
         put rightViewLeft into item 1 of rightViewRect
         
         _SetLastLeftViewWidth leftViewWidth
         _SetLastTotalWidth newLayoutWidth
   end switch
   
   # Set Rects
   lock screen
   set the rect of LeftView to leftViewRect
   set the rect of DividerView to verticalDividerRect
   set the rect of RightView to rightViewRect
   set the rect of me to pRect
   unlock screen   
end LayoutControl

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


--> Deps
-
command margin_Normalize @someMargin, @leftM, @topM, @rightM, @bottomM
   if the number of items of someMargin < 4 then
      put item 1 of someMargin into defaultMargin
      put defaultMargin into leftM
      
      put item 2 of someMargin into actualMargin
      if actualMargin is empty then
         put leftM into topM
      else
         put actualMargin into topM
      end if
      
      put item 3 of someMargin into actualMargin
      if actualMargin is empty then
         put leftM into rightM
      else
         put actualMargin into rightM
      end if
      
      put item 4 of someMargin into actualMargin
      if actualMargin is empty then
         put topM into bottomM
      else
         put actualMargin into bottomM
      end if
   else
      put item 1 of someMargin into leftM
      put item 2 of someMargin into topM
      put item 3 of someMargin into rightM
      put item 4 of someMargin into bottomM
   end if
   put leftM,topM,rightM,bottomM into someMargin
end margin_Normalize

command view_NormalizeName @viewPath
   if viewPath is empty then return false
   view_NormalizePiped viewPath
   
   set the itemdelimiter to "|"
   if item 1 of viewPath is not among the items of "View|Layout" then put "View|" before viewPath
   return true
end view_NormalizeName

function control_ConstructCreateDoScript controlType, someName, targetOwner, pClassOrViewName
   switch
      case controlType is empty
      case controlType = "placeholder"
         put view_GetTemplateObject ("Layout|Placeholder") into templateObject
         -- put view_GetTemplateObject ("View|Layout|Placeholder") into templateObject
         if exists (templateObject) is false then return empty
         put "copy" && templateObject && "to" && targetOwner into doScript
         return doScript
      case controlType = "view"
         put view_GetTemplateObject (pClassOrViewName) into templateObject 
         if exists (templateObject) is false then return empty
         put "copy" && templateObject && "to" && targetOwner into doScript
         return doScript
      case controlType contains "|"
         put controlType into viewName
         put view_GetTemplateObject (viewName) into templateObject 
         if exists (templateObject) is false then return empty
         put "copy" && templateObject && "to" && targetOwner into doScript
         return doScript
      case controlType = "headerBar"
         put widget_ConstructCreateDoScript (someName, "com.livecode.widget.headerBar", targetOwner) into doScript
         return doScript
      case controlType = "navBar"
         put widget_ConstructCreateDoScript (someName, "com.livecode.widget.navBar", targetOwner) into doScript
         return doScript
      case controlType = "segmented"
         put widget_ConstructCreateDoScript (someName, "com.livecode.widget.segmented", targetOwner) into doScript
         return doScript
      case controlType = "browser"
         put widget_ConstructCreateDoScript (someName, "com.livecode.widget.browser", targetOwner) into doScript
         return doScript
      case controlType = "treeView"
         put widget_ConstructCreateDoScript (someName, "com.livecode.widget.treeView", targetOwner) into doScript
         return doScript
      case controlType begins with "com.livecode.widget."
         put controlType into pClassOrViewName
         put widget_ConstructCreateDoScript (someName, pClassOrViewName, targetOwner) into doScript
         return doScript
      case controlType = "widget"
         put widget_ConstructCreateDoScript (someName, pClassOrViewName, targetOwner) into doScript
         return doScript
      case controltype is among the items of "field,button,graphic,player,image"
         if word 1 of targetOwner is "group" then
            put "create invisible" && controlType && quote & someName & quote && "in" && targetOwner into doScript
         else
            put "create invisible" && controlType && quote & someName & quote into doScript
         end if
         return doScript
         break
      default
         breakpoint
         return empty
   end switch
end control_ConstructCreateDoScript

setprop control_Type [pClassOrViewName] controlType
   -- should not do this if they control_Type is already controlType
   lock screen
   -- 
   put the long id of the target into targetObject
   put the long id of the owner of targetObject into targetOwner
   
   put the short name of targetObject into oName
   put the short id of targetObject into originalID
   put the rect of targetObject into oRect
   put the backgroundcolor of targetObject into bColour
   
   put control_ConstructCreateDoScript (controlType, oName, targetOwner, pClassOrViewName) into doScript
   if doScript is empty then
      breakpoint
      put control_ConstructCreateDoScript (controlType, oName, targetOwner, pClassOrViewName) into doScript
      return targetObject
   else
      do doScript
      put it into tempCreatedObject
      if exists (tempCreatedObject) is false then
         breakpoint
         return empty
      end if
      
      set the rect of tempCreatedObject to oRect
      relayer tempCreatedObject before targetObject
      --
      switch
         case controlType is empty
         case controlType = "Layout|Placeholder"
         case controlType = "View|Layout|Placeholder"
         case controlType = "placeholder"
            if bColour is empty then put "random" into bColour
            --
            set the background_Colour of tempCreatedObject to bColour
            set the name of tempCreatedObject to oName
            set the urip_Type of tempCreatedObject to "view"
            break
         case controlType = "view"
            set the urip_Type of tempCreatedObject to "view"
            break
         case controlType contains "|"
            set the urip_Type of tempCreatedObject to "view"
            break
         default
            -- it's a standard Livecode control
            -- here we could look at "pClassOrViewName" and 
            -- add some customisation to things list list fields
      end switch
      
      try
         delete targetObject
      catch e
         object_Delete targetObject
      end try
      
      set the name of tempCreatedObject to oName
      show tempCreatedObject
      
      put "reset_ID" && originalID into pigeon
      send pigeon to tempCreatedObject in 20 ticks
      
      dispatch "LayoutControl" to targetOwner
      put the result into createdObject
      
      unlock screen
      return createdObject -- shoujd have the same id but may be a different control type
   end if
end control_Type

getprop inner_Rect [groupRect]
   put the long id of the target into someGroup
   if groupRect is empty then put the rect of someGroup into groupRect
   if word 1 of someGroup is not "group" then return groupRect -- only for groups
   
   put rect_GetInner (groupRect, someGroup) into innerRect
   return innerRect
end inner_Rect

function label_CamelFromPiped pipedName
   replace space with empty in pipedName -- hack
   
   set the itemdelimiter to "|"
   repeat with itemNum = 1 to the number of items of pipedName
      put word 1 to -1 of item itemNum of pipedName into sItem
      get toLower (sItem)
      put text_InitialCaps (it) into capsItem
      put capsItem after camelCaps
   end repeat
   return camelCaps
end label_CamelFromPiped

function label_CamelTitleToView camelTitle, pFirstItem
   if pFirstItem is empty then put "View" into pFirstItem
   
   put word_SplitCaps (camelTitle, "|") into viewName
   --
   set the itemdelimiter to "|"
   if item 1 of viewPath is not among the items of "View|Layout" then
      put pFirstItem & "|" before viewName
   end if
   return viewName
end label_CamelTitleToView

function label_ReverseCamelFromPiped pipedName
   replace space with empty in pipedName -- hack
   
   set the itemdelimiter to "|"
   repeat with itemNum = the number of items of pipedName down to 1
      put word 1 to -1 of item itemNum of pipedName into sItem
      get toLower (sItem)
      put text_InitialCaps (it) into capsItem
      put capsItem after camelCaps
   end repeat
   return camelCaps
end label_ReverseCamelFromPiped

function label_ViewToCamelTitle pipedName, pReverse
   set the itemdelimiter to "|"
   if item 1 of pipedName is among the items of "View|Layout" then
      delete item 1 of pipedName
   end if
   
   # Create camelCaps
   if pReverse is false then
      put label_CamelFromPiped (pipedName) into camelCaps
   else
      put label_ReverseCamelFromPiped (pipedName) into camelCaps
   end if
   return camelCaps
end label_ViewToCamelTitle

command margin_Normalize someMargin, @leftM, @topM, @rightM, @bottomM
   if the number of items of someMargin < 4 then
      put item 1 of someMargin into defaultMargin
      put defaultMargin into leftM
      
      put item 2 of someMargin into actualMargin
      if actualMargin is empty then
         put leftM into topM
      else
         put actualMargin into topM
      end if
      
      put item 3 of someMargin into actualMargin
      if actualMargin is empty then
         put leftM into rightM
      else
         put actualMargin into rightM
      end if
      
      put item 4 of someMargin into actualMargin
      if actualMargin is empty then
         put topM into bottomM
      else
         put actualMargin into bottomM
      end if
   else
      put item 1 of someMargin into leftM
      put item 2 of someMargin into topM
      put item 3 of someMargin into rightM
      put item 4 of someMargin into bottomM
   end if
   return leftM,topM,rightM,bottomM
end margin_Normalize

command object_Delete pObjects
   if pObjects is empty then put the long id of the target into pObjects
   lock screen
   repeat for each line someObject in pObjects
      if exists(someObject) then
         try
            delete someObject
         catch e
            -- in case the script is executing in the context of the object itself
            send "delete someObject" to someObject in 2 ticks
         end try
      end if
   end repeat
   unlock screen
end object_Delete

function rect_GetInner groupRect, someGroup, pMargin
   if exists (someGroup) is false then return empty
   if pMargin is empty then
      put the margins of someGroup into pMargin
   end if
   rect_SubtractMargins groupRect, pMargin
   put the result into nMargins
   --
   if the showborder of someGroup is true then
      put the borderwidth of someGroup into bWidth
      rect_SubtractMargins groupRect, bWidth
   end if
   
   if the showname of someGroup is true then
      put the effective textheight of someGroup - bWidth into someBit
      subtract 2 from someBit
      add someBit to item 2 of groupRect
   end if
   
   put the scrollbarwidth of someGroup into scrollBarMargin
   if the vscrollbar of someGroup is true then 
      subtract scrollBarMargin from item 3 of groupRect
   end if
   if the hscrollbar of someGroup is true then
      subtract scrollBarMargin from item 4 of groupRect
   end if
   --
   return groupRect
end rect_GetInner

command rect_SubtractMargins @someRect, pMargin
   margin_Normalize pMargin, leftM, topM, rightM, bottomM
   put the result into nMargins
   --
   add leftM to item 1 of someRect
   add topM to item 2 of someRect
   subtract rightM from item 3 of someRect
   subtract bottomM from item 4 of someRect
   --
   return nMargins
end rect_SubtractMargins

function stack_FirstControl sPath
   if exists (control 1 of card 1 of stack sPath) then
      return the long id of control 1 of card 1 of stack sPath
   else
      return empty
   end if
end stack_FirstControl

getprop stack_Name
   return the short name of the defaultstack
end stack_Name

function text_InitialCaps someText
   repeat with wordNum = 1 to the number of words of someText
      put tolower(word wordNum of someText) into someWord
      put toupper(char 1 of someWord ) into char 1 of someWord
      put someWord into word wordNum of someText
   end repeat
   return someText
end text_InitialCaps

function text_StartsWithCaps someText
   put char 1 of sometext into testChar
   put nativeCharToNum (testChar) into someCharNum
   if someCharNum >= 97 and someCharNum <= 122 then
      return false
   else
      return true
   end if
end text_StartsWithCaps

setprop urip_Array [someKey] arrayOrValue
   if someKey is empty then
      set the customproperties ["uRIP"] of the target to arrayOrValue
      return arrayOrValue
   else
      put the customproperties ["uRIP"] of the target into uRipArray
      put arrayOrValue into uRipArray [someKey]
      set the customproperties ["uRIP"] of the target to uRipArray
      return uRipArray
   end if
end urip_Array

setprop urip_Type objectType
   set the urip_Array ["type"] of the target to objectType
   put the result into uRipArray
   return uRipArray
end urip_Type

function view_GetTemplateObject viewName, pRepoFolder
   view_NormalizeName viewName
   put stack_FirstControl (viewName) into mObject
   return mObject
end view_GetTemplateObject

getprop view_Name
   put the long id of the target into tObject   
   if the uRIP ["type"] of tObject is not "view" then return empty
   put the uRIP ["name"] of tObject into viewName
   return viewName
end view_Name

command view_NormalizePiped @viewPath, pMakePretty
   if viewPath is empty then return false
   put word 1 to -1 of viewPath into viewPath
   
   set the itemdelimiter to "|"
   repeat with itemNum = 1 to the number of items of viewPath
      put word 1 to -1 of item itemNum of viewPath into someItem
      if pMakePretty is true then
         repeat for each word someWord in someItem
            put toUpper (char 1 of someWord) into char 1 of someWord
            put someWord & space after prettyItem
         end repeat
         put char 1 to -2 of prettyItem into someItem
      end if
      put someItem into item itemNum of viewPath
   end repeat
   return true
end view_NormalizePiped

function widget_ConstructCreateDoScript someName, widgetClass, pTargetOwner
   if word 1 of pTargetOwner is "group" then
      put "create invisible widget" && quote & someName & quote && "as" && quote & widgetClass & quote && "in" && pTargetOwner into doScript
   else
      put "create invisible widget" && quote & someName & quote && "as" && quote & widgetClass & quote into doScript
   end if
   return doScript
end widget_ConstructCreateDoScript

function word_SplitCaps sWord, pDelimChar
   if pDelimChar is empty then put space into pDelimChar
   --
   put 1 into charNum
   repeat the number of chars of sWord
      put char charNum of sWord into sChar
      if text_StartsWithCaps (sChar) is true then
         put pDelimChar before char charNum of sWord
         add 2 to charNum
      else
         add 1 to charNum
      end if
   end repeat
   put the number of chars of pDelimChar into maxNum
   delete char 1 to maxNum of sWord
   return sWord
end word_SplitCaps
