script "behavior_ViewLayoutPlaceholder"
--> MetaData
-
license: GPLv3
name: behavior_LayoutPlaceholder
type: view behavior
version: 0.4
copyright: David Bovill

/*
This "placeholder" view is useful for experimentign with a layout. 
Drag and drop views onto a placeholder to replace them.
It's also a great way to test the robsutness of your layout.
Can you replace all your views with placeholders and back and everything still work?
*/

--> Variables
-
local LocalArray


--> Working on
-
on LayoutControl pRect
   if pRect is a rect then
      set the rect of me to pRect
   end if
end LayoutControl

getprop height_IsFixed
   return LocalArray ["heightIsFixed"] is not false
end height_IsFixed

setprop height_IsFixed someBoolean
   put someBoolean into LocalArray ["heightIsFixed"]
end height_IsFixed


--> Events | Menu
-
on mouseDown pMouseBtnNum
   if pMouseBtnNum = 3 then
      menu_PopUp "Global | Layout | Placeholder | Menu"
   else
      pass mouseDown
   end if
end mouseDown

getprop menu_Target [targetObject]
   return the long id of me
end menu_Target


--> Events | Drag
-
on dragEnter
   put the dragdata ["private"] into privateFlag
   switch privateFlag
      case empty
         set the drag_Hilite of me to true
         break
      default
         if privateFlag contains "|" then
            _DragHiliteView viewName
         end if
   end switch
   pass dragEnter
end dragEnter

on dragLeave
   put the dragdata ["private"] into privateFlag
   switch privateFlag
      case empty
         set the drag_Hilite of me to false
         break
      default
         if privateFlag contains "|" then
            set the drag_Hilite of me to false
         end if
   end switch   
   pass dragLeave
end dragLeave

setprop drag_Hilite someBoolean
   if someBoolean is true then
      put the backgroundcolor of me into LocalArray ["originalColour"]
      set the dragAction to "link"
      set the backgroundcolor of me to "red"
      
      put the dragdata ["private"] into viewName
      put "About to drop view" & CR & kwote(viewName) into dropInfo
      set the label of me to dropInfo
   else
      set the backgroundcolor of me to LocalArray ["originalColour"]
      set the label of me to empty
      set the dragAction to "none"
   end if
end drag_Hilite


--> Geometry
-
/*
As it is a single control we don't need a complicated geometry handler.
*/

getprop view_Height
   return the height of me
end view_Height

setprop view_Height someHeight
   if the height of me = someHeight then pass view_Height -- should we only do this when it has changed?
   
   lock screen
   put the long owner of me into myOwner
   put the rect of myOwner into oRect
   set the height of me to someHeight 
   dispatch "LayoutControl" to myOwner with oRect -- experimental  allows a container to resize itself
   unlock screen
end view_Height


--> Props
-
getprop background_Colour
   return the effective backgroundcolor of me
end background_Colour

setprop background_Colour someColour
   if someColour is "random" then put colour_GetRandom() into someColour
   set the backgroundcolor of me to someColour
end background_Colour

getprop view_IsOpaque
   put the opaque of me into someBoolean
   return someBoolean
end view_IsOpaque

setprop view_IsOpaque someBoolean
   set the opaque of me to someBoolean
   set the showname of me to someBoolean
end view_IsOpaque

getprop view_Label
   return the effective label of the placeHolder_Button of me
end view_Label

setprop view_Label someText
   put the placeHolder_Button of me into placeHolderButton
   if the short name of placeHolderButton = someText then
      set the label of placeHolderButton to empty
   else
      set the label of placeHolderButton to someText
   end if
end view_Label


--> View
-
getprop placeHolder_Button
   return the long id of me
end placeHolder_Button

getprop view_Object
   return the long id of me
end view_Object


--> Deps
-
private command _DragHiliteView viewName
   put view_GetTemplateObject (viewName) into libraryObject
   if libraryObject is empty then
      lcw_Notify merge("Not a view being dropped, [[viewName]] has no library object!"), true
      beep
   else
      set the drag_Hilite of me to true
   end if
end _DragHiliteView

private function colour_GetRandom
   -- was "randomColour"
   put random(255) into item 1 of someColour
   put random(255) into item 2 of someColour
   put random(255) into item 3 of someColour
   return someColour
end colour_GetRandom
