﻿script "Global | Layout | Horizontal | Two | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Layout | Horizontal | Two | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray


--> Menu | Props
-
getprop menu_Target [tObject]
   put the layout_View of tObject into layoutView
   --
   put _TopControlNames (layoutView) into LocalArray ["_TopControlNames"]
   put view_ListOpen ("Layout|Placeholder") into LocalArray ["openViews"]
   --
   return layoutView
end menu_Target

private function _TopControlNames layoutView
   put the top_ControlNames of layoutView into cNames
   line_Delete "_VerticalDivider View", cNames
   return cNames
end _TopControlNames

getprop setLeftName_Param [layoutView]
   return the left_Name of layoutView
end setLeftName_Param

getprop setRightName_Param [layoutView]
   return the right_Name of layoutView
end setRightName_Param

getprop setLeftName_Params [layoutView]
   return LocalArray ["_TopControlNames"]
end setLeftName_Params

getprop setRightName_Params [layoutView]
   return LocalArray ["_TopControlNames"]
end setRightName_Params

getprop replaceLeftView_Param [mTarget]
   put the left_View of mTarget into someView
   return getPath (someView)
end replaceLeftView_Param

getprop replaceLeftView_Params [mTarget]
   return LocalArray ["openViews"]
   
   put the left_View of mTarget into someView
   return getPaths (someView)
end replaceLeftView_Params

getprop replaceRightView_Param [mTarget]
   put the right_View of mTarget into someView
   return getPath (someView)
end replaceRightView_Param

getprop replaceRightView_Params [mTarget]
   return LocalArray ["openViews"]
   
   put the right_View of mTarget into someView
   return getPaths (someView)
end replaceRightView_Params

getprop showBorder_Param [mTarget]
   return the showborder of mTarget
end showBorder_Param

getprop showBorder_Params [mTarget]
   return "true,false"
end showBorder_Params

private function getPath someView
   if exists (someView) is false then return empty
   put menu_GetSentPath() into mPath
   put the other_ViewName [mPath] of someView into otherHeader
   if otherHeader is empty then
      put the view_Name of someView into otherHeader -- get a default
   end if
   return otherHeader
end getPath

private function getPaths someView, pFilter
   if exists (someView) is false then return empty
   
   put menu_GetSentPath() into mPath
   put the other_ViewNames [mPath] of someView into otherHeaders
   if otherHeaders is empty then
      put the view_SubPaths [pFilter] of someView into otherHeaders -- get a default
   end if
   return otherHeaders
end getPaths


--> Junk
-
getprop divider_MenuItems [horizontalLayoutView]
   put the verticalDivider_View of horizontalLayoutView into mView
   return the view_ToolMenu [mView] of mView
end divider_MenuItems

getprop left_MenuItems [horizontalLayoutView]
   put the left_View of horizontalLayoutView into mView
   return the view_ToolMenu [mView] of mView
end left_MenuItems

getprop right_MenuItems [horizontalLayoutView]
   put the right_View of horizontalLayoutView into mView
   return the view_ToolMenu [mView] of mView
end right_MenuItems


--> Global | Layout | Horizontal | Two | Menu
-
on menu_ShowBorder layoutView, someBoolean
   set the showborder of layoutView to someBoolean
end menu_ShowBorder

on menu_BackgroundColour layoutView
   answer color
   put it into someColour
   set the backgroundColor of layoutView to someColour
end menu_BackgroundColour

private command _
end _

on menu_ReplaceLeftView layoutView, leftPath
   put the left_View of layoutView into someView
   if exists (someView) is false then exit to top
   --
   set the view_Swap of someView to leftPath
end menu_ReplaceLeftView

on menu_ReplaceRightView layoutView, rightPath
   put the right_View of layoutView into someView
   if exists (someView) is false then exit to top
   --
   set the view_Swap of someView to rightPath
end menu_ReplaceRightView

private command __
end __

on menu_SetLeftName layoutView, cName
   set the left_Name of layoutView to cName
end menu_SetLeftName

on menu_SetRightName layoutView, cName
   set the right_Name of layoutView to cName
end menu_SetRightName

private command ___
end ___

on menu_PreopenControl layoutView
   dispatch "preOpenControl" to layoutView
end menu_PreopenControl

on menu_CloneModule layoutView
   put the stack_Name of layoutView into sName
   stack_Clone sName
   put the result into clonedStack
   set the original_ModuleName of clonedStack to moduleName
   put the stack_Name of clonedStack into cStackName
   --
   display_CloneTools cStackName
end menu_CloneModule

on submenu_View
   return "Global | View | Property | Menu"
   return "Global | View | Update | Menu"
end submenu_View

on submenu_Dev
   return menu_DevTitle ("Global | Layout | Horizontal | Two | Menu")
end submenu_Dev
