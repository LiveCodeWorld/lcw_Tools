script "behavior_ViewLayoutVertical"
--> MetaData
-
license: GPLv3
name: behavior_ViewLayoutVertical
type: view behavior
version: 0.2

/*
See also "lib_ViewUpdate"
*/


--> Variables
-
local LocalArray


--> Work in Progress
-
setprop module_Add moduleName
   put module_GetTemplateObject (moduleName) into templateObject
   put templateObject
end module_Add

setprop view_Add viewNames
   -- was "View_Insert"
   replace comma with CR in viewNames
   --
   lock screen
   repeat for each line viewName in viewNames
      put view_GetTemplateObject (viewName) into templateObject
      copy templateObject to me
      put it into createdObject
      put createdObject & CR after createdObjects
   end repeat
   LayoutControl
   unlock screen
   --
   delete char -1 of createdObjects 
   return createdObjects
end view_Add


--> Events | Drag
-
on dragEnter
   set the drag_Hilite of me to true
   pass dragEnter
end dragEnter

on dragLeave
   set the drag_Hilite of me to false
   pass dragLeave
end dragLeave

setprop drag_Hilite someBoolean
   if someBoolean is true then
      put the backgroundcolor of me into LocalArray ["originalColour"]
      set the dragAction to "link"
      set the backgroundcolor of me to "red"
   else
      set the backgroundcolor of me to LocalArray ["originalColour"]
      set the dragAction to "none"
   end if
end drag_Hilite


--> Props
-
getprop layout_Views
   put _GetViewNames() into vNames
   return vNames
end layout_Views

setprop layout_Views viewNames
   replace comma with CR in viewNames
   put the rect of me into oRect
   --
   lock screen
   _SetViewNames viewNames
   put the result into copiedObjects
   LayoutControl oRect
   unlock screen
   --
   return copiedObjects
end layout_Views

getprop layout_Objects
   -- useful?
   put _GetObjects() into objectIndex
   return objectIndex
end layout_Objects

setprop layout_Objects objectIndex
   -- useful?
   replace comma with CR in viewNames
   put the rect of me into oRect
   --
   lock screen
   _SetObjects objectIndex
   Layoutcontrol oRect
   unlock screen
end layout_Objects

getprop row_Number
   put the childControlIDs of me into someIDs
   put the number of lines of someIDs into numberOfRows
   return numberOfRows
end row_Number

setprop row_Number [cloneObject] rowNum
   lock screen
   put the childControlIDs of me into someIDs
   put the number of lines of someIDs into maxNum
   switch
      case rowNum > maxNum
         put line maxNum of someIDs into lastID
         if exists (cloneObject) is false then 
            put the long id of control id lastID into cloneObject
         end if
         repeat (rowNum - maxNum)
            -- clone only works if already in the group
            copy cloneObject to me
            put it into createdObject
         end repeat
         break
      case rowNum < maxNum
         put rowNum + 1 into toRowNum
         repeat with lineNum = maxNum down to toRowNum
            put line lineNum of someIDs into someID
            put the long id of control id someID into topObject
            delete topObject
         end repeat
         break
      default
         -- nothing to do
   end switch
   LayoutControl
   unlock screen
end row_Number


--> Private
-
private command _AddViewNames vNames
   repeat for each line vName in vNames
      put view_GetTemplateObject (vName) into templateObject
      if exists (templateObject) is false then next repeat
      copy templateObject to me
   end repeat
end _AddViewNames

private function _GetViewNames
   put the childControlIDs of me into someIDs
   repeat for each line someID in someIDs
      put the view_Name of control id someID into vName
      put vName & CR after viewNames
   end repeat
   delete char -1 of viewNames
   return viewNames
end _GetViewNames

private command _SetViewNames viewNames
   _DeleteAllObjects
   --
   repeat for each line vName in viewNames
      put view_GetTemplateObject (vName) into someObject
      copy someObject to me
      put it & CR after copiedObjects
   end repeat
   delete char -1 of copiedObjects
   return copiedObjects
end _SetViewNames

private function _GetObjects
   put the childControlIDs of me into someIDs
   repeat for each line someID in someIDs
      put the long id of control id someID into topLayoutObject
      put topLayoutObject & CR after topLayoutObjects
   end repeat
   delete char -1 of topLayoutObjects
   return topLayoutObjects
end _GetObjects

private command _SetObjects objectIndex
   _DeleteAllObjects
   --
   repeat for each line someObject in objectIndex
      copy someObject to me
      put it & CR after copiedObjects
   end repeat
   delete char -1 of copiedObjects
   return copiedObjects
end _SetObjects

private command _DeleteAllObjects
   put the childControlIDs of me into someIDs
   repeat for each line someID in someIDs
      put the long id of control id someID into oldRecord
      delete oldRecord
   end repeat
end _DeleteAllObjects


--> Objects
-
getprop layout_Object
   return the long id of me
end layout_Object

getprop view_Object
   return the long id of me
end view_Object


--> Events
-
on resizeControl pFirstparam
   put the rect of me into pRect
   LayoutControl pRect
end resizeControl


--> Geometry
-
on LayoutControl pRect
   lock screen
   if pRect is empty then put the rect of me into pRect
   put the margins of me into myMargins
   rect_SubtractMargins pRect, myMargins
   
   -- rect_CreateMask pRect, "Inner"
   
   put item 4 of pRect - item 2 of pRect into innerHeight
   
   put the childcontrolids of me into topControlIDs
   put the number of lines of topControlIDs into numberOfChildren
   if numberOfChildren = 0 then return 0
   
   put numberOfChildren - 1 into gutterNum
   put the view_Spacing of me into viewSpacing
   
   put item 2 of pRect into childTop
   repeat with cNum = 1 to numberOfChildren    
      put line cNum of topControlIDs into topControlID
      
      put the effective height of control id topControlID into someHeight
      put childTop + someHeight into childBottom
      
      put pRect into childRect
      put childTop into item 2 of childRect
      put childBottom into item 4 of childRect
      set the rect of control id topControlID to childRect
      
      -- rect_CreateMask childRect, ("Child" && topControlID)
      
      put childBottom + viewSpacing into childTop
   end repeat
   unlock screen
   return numberOfChildren
end LayoutControl

getprop view_Spacing
   put LocalArray ["viewSpacing"] into someNum
   if someNum is not a number then -- let's set a default
      put 8 into someNum
      put someNum into LocalArray ["viewSpacing"]
   end if
   return someNum
end view_Spacing

setprop view_Spacing someNum
   put someNum into LocalArray ["viewSpacing"]
   LayoutControl
end view_Spacing
