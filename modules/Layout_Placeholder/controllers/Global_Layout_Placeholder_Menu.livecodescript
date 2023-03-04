script "Global | Layout | Placeholder | Menu"
--> MetaData
-
license: GPLv3
name: Global | Layout | Placeholder | Menu
type: controller
version: 0.7


--> Working on
-
getprop owner_Params [tObject]
   put the view_Object of the owner of tObject into viewOwner
   if exists (viewOwner) is false then return empty
   
   -- put the menu_ToolTitle of tObject into ownerMenuTitle
   -- menu_SetTitleTargetOveride ownerMenuTitle, viewOwner -- complicated, useful and deprecated
   
   put the view_ToolMenu of viewOwner into mText
   return mText
end owner_Params


--> Menu | Props
-
/*
menu_Target is defined in the view. Can override by placing a getprop menu_Target handler here.
*/

local LocalArray

getprop menu_Target [tObject]
   local objectArray
   put the view_Hierarchy of tObject into objectIndex
   put object_NamesFromIndex (objectIndex, objectArray) into objectNames
   put objectNames into LocalArray ["objectNames"]
   put objectArray into LocalArray ["objectArray"]
   --
   return tObject
end menu_Target

getprop menu_CheckTarget [mTarget]
   get the placeHolder_Button of mTarget
   return exists (it)
end menu_CheckTarget

getprop is_Transparent [mTarget]
   put the view_IsOpaque of mTarget into isOpaque
   return not isOpaque
end is_Transparent

getprop some_Views
   if LocalArray ["objectNames"] is empty then
      return "This menu script"
   else
      return it & CR & "-" & CR & "This menu script"
   end if
end some_Views

getprop disabled_UpdatePlaceholder [tObject]
   put the placeHolder_Button of tObject into placeHolderView
   if exists (placeHolderView) then
      put the view_IsOld of placeHolderView into isOld
      return isOld is not true
   else
      return true
   end if
end disabled_UpdatePlaceholder

getprop disabled_UpdateElements [tObject]
   put the layout_Elements of tObject into layoutElements
   if layoutElements is empty then
      return true
   else
      return false
   end if
end disabled_UpdateElements

getprop disabled_Owner [tObject]
   put the view_Object of the owner of tObject into viewOwner
   if exists (viewOwner) is false then return empty   
   return false
end disabled_Owner

getprop checked_HeightIsFixed [viewObject]
   put the height_IsFixed of viewObject into heightIsFixed
   return heightIsFixed
end checked_HeightIsFixed

getprop checked_IsOpaque [viewObject]
   return the view_IsOpaque of viewObject
end checked_IsOpaque

command drag_Delete tObject, someThing
   switch someThing
      default
         put someThing
         breakpoint
   end switch
   return "View|SivaSiva|Navigation|Bottom"
end drag_Delete


--> Global | Layout | Placeholder | Menu
-
on submenu_Replace
   return "Global | Layout | Placeholder | Replace | Menu"
end submenu_Replace

on menu_UpdatePlaceholder tObject
   view_Update tObject, true
end menu_UpdatePlaceholder

on menu_UpdateLayoutPlaceholders tObject
   put the layout_View of tObject into layoutView
   --
   put the top_Controls of layoutView into topControls
   repeat for each line someControl in topControls
      put the view_Name of someControl into vName
      if vName = "View|Layout|Placeholder" then
         put the view_Colour of someControl into oColour
         view_Update someControl, true
         put the result into newView
         set the view_Colour of newView to "random"
      end if
   end repeat
end menu_UpdateLayoutPlaceholders

private command _
end _

on menu_DeleteMe tObject
   send "delete tObject" to tObject in 0 ticks
end menu_DeleteMe

private command __
end __

on menu_ChangeName tObject
   put the short name of tObject into someValue
   ask "Change the name of this place holder?" with someValue
   if the result is "Cancel" then exit to top
   put it into newValue
   set the name of tObject to newValue
end menu_ChangeName

on menu_ChangeLabel tObject
   put the view_Label of tObject into someValue
   
   ask "Change the label of this place holder?" with someValue
   if the result is "Cancel" then exit to top
   put it into newValue
   
   set the view_Label of tObject to newValue
end menu_ChangeLabel

on menu_ChangeColour tObject
   answer color
   if the result is "Cancel" then exit to top
   put it into newValue
   
   set the view_Colour of tObject to newValue
end menu_ChangeColour

private command ___
end ___

on menu_IsOpaque tObject
   put the view_IsOpaque of tObject into sBoolean
   set the view_IsOpaque of tObject to not sBoolean
end menu_IsOpaque

on menu_HeightIsFixed viewObject
   put the height_IsFixed of viewObject into heightIsFixed
   --
   set the height_IsFixed of viewObject to (heightIsFixed is false)
end menu_HeightIsFixed

private command ____
end ____

on menu_PlaceholderBehavior viewObject
   put the behavior of viewObject into bObject
   edit the script of bObject
end menu_PlaceholderBehavior

on _DisplayDragWidgets
   put "Global | Layout | Placeholder | Replace | Menu" into mTitle
   put "Controls,Drag and Drop" into someTitle
   put empty into mLineTitle
   put empty into mUp
   put empty into mDoubleUp
   put "drag_Delete" into dCommand
   put "headerBar,navBar,segmented,browser,tree" into someIndex
   display_Index someIndex, someTitle, mTitle, mLineTitle, mUp, mDoubleUp, dCommand
end _DisplayDragWidgets

on _ChangeWidth tObject
   put lcw_Ask ("Change the width of placeholder to...", the width of tObject) into newWidth
   set the width of tObject to newWidth
   dispatch "LayoutControl" to the owner of tObject
end _ChangeWidth

on _GoToPlaceholderTemplate
   put view_GetTemplateObject ("Layouts|Placeholder") into templateObject
   object_GoTo templateObject
end _GoToPlaceholderTemplate

on _UpdateElements tObject
   put the layout_Elements of tObject into layoutElements
   repeat for each line someView in layoutElements
      view_Update someView, true
   end repeat
end _UpdateElements
