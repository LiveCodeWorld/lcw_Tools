script "Global | View | Update | Dev | Menu"
--> MetaData
-
license: GPLv3
name: Global | View | Update | Dev | Menu
type: controller
author: David Bovill
version: 0.1

/*
Here you can describe this developer menu.
Full help text should be provided on the linked wiki.

Consider improving by creating with same menu_Target as no-developer menu is is based on.
*/

--> Menu | Props
-
local LocalArray

getprop menu_Target [tObject]
   put the display_View of tObject into displayView
   --
   if exists (displayView) then
      put the displayed_Object of displayView into viewObject
      put displayView into LocalArray ["displayView"]
   else
      put the module_ViewObject of tObject into viewObject
      if exists (viewObject) is false then
         return tObject
      end if
   end if
   --
   return viewObject
end menu_Target

getprop menu_CheckTarget [mTarget]
   return exists (mTarget)
end menu_CheckTarget

getprop disabled_Swap [mTarget]
   return _isNotTemplate (mTarget) is false
end disabled_Swap

private function _isNotTemplate viewObject
   -- this would disable the entire menu if the mTarget was not a view.
   if exists (viewObject)is false then return true
   
   put the view_Name of viewObject into vName
   if vName = empty then
      return false
   else
      -- disable if the viewObject is a template
      put the view_Template of viewObject into templateObject
      if templateObject = viewObject then
         return false
      else
         return true
      end if
   end if
end _isNotTemplate


--> Global | View | Update | Dev | Menu
-
on menu_CreateStandAlone viewObject
   breakpoint
   put LocalArray ["displayView"] into displayView
   --
   put the view_Name of viewObject into vName
   put view_GetTemplateObject (vName) into templateObject
   if exists (templateObject) is false then
      breakpoint
   end if
   
   put the stack_Name of templateObject into stackName
   clone stack stackName
   put it into clonedStack
   set the destroyStack of clonedStack to true
   set the destroyWindow of clonedStack to true
   
   put the long id of cd 1 of clonedStack into clonedTemplateCard
   put the long id of control 1 of clonedTemplateCard into clonedView
   
   set the imported_ViewBehaviors of clonedView to true
   
   display_ViewBehaviors clonedView, empty, clonedStack
end menu_CreateStandAlone

on menu_SaveAllViews
put view_StackNames() into stackNames
repeat for each line stackName in stackNames
   if there is a stack stackName then
      save stack stackName
   end if
end repeat
end menu_SaveAllViews

on menu_TestViewToSwap mTarget
   display_ActiveMenuArray
   put the mobile_Name of mTarget into mTarget
   display_Lines mTarget, "mTarget"
end menu_TestViewToSwap

on menu_BehaviorsOfView mTarget
   put the object_Behaviors of mTarget
end menu_BehaviorsOfView


--> Global | View | Update | Menu | Props
-
getprop v_Name [mTarget]
   if exists(mTarget) is false then return true
   put the view_Name of mTarget into viewName
   set the itemdelimiter to "|"
   delete item 1 of viewName
   return viewName
end v_Name

getprop v_Names [mTarget]
   if exists(mTarget) is false then return true
   put the view_Alternatives of mTarget into viewPaths
   return viewPaths & ",-,Layouts|Placeholder"
end v_Names

getprop view_ChildAlternative [mTarget]
   put the view_Object of mTarget into someView
   if exists(someView) is false then return empty
   
   set the itemdelimiter to "|"
   repeat for each line childView in the view_Children of mTarget
      get the view_Name of childView
      delete item 1 of it
      put it  & CR after viewNames
   end repeat
   delete char -1 of viewNames
   return viewNames
end view_ChildAlternative

getprop view_ChildAlternatives [mTarget]
   put empty into ChildViewArray
   put the view_Object of mTarget into someView
   if exists(someView) is false then return empty
   
   repeat for each line childView in the view_Children of mTarget
      put the short name of childView & CR after someOutline
      get the view_Alternatives of childView
      repeat for each line viewAlternative in it
         put childView into ChildViewArray [viewAlternative]
      end repeat
      put outline_IncreaseIndent(it) & CR after someOutline
   end repeat
   return word 1 to -1 of someOutline
end view_ChildAlternatives


--> Dev | Menu | Disabled
-
getprop disabled_TestViewToSwap [mTarget]
   return _isNotTemplate (mTarget) is false
end disabled_TestViewToSwap

getprop disabled_BehaviorsOfView [mTarget]
   return _isNotTemplate (mTarget) is false
end disabled_BehaviorsOfView

getprop disabled_FixBrokenBehaviors [mTarget]
   return _isNotTemplate (mTarget) is false
end disabled_FixBrokenBehaviors


--> Global | View | Update | Menu | Disabled
-
getprop disabled_GoAndCheckVersion [mTarget]
   return _isNotTemplate (mTarget) is false
end disabled_GoAndCheckVersion

getprop disabled_UpdateLibraryView [menuButtonObject]
   if _isNotTemplate (mTarget) is false then return true
   
    if the shiftkey is "Down" then return false
    put the displayed_View of me into targetObject
    if exists(displayedView) is false then
        return false
    else if the object_IsView of targetObject is false then
        return true
    else
        put targetObject into someView
        put the view_Template of someView into libraryView
        if libraryView is empty then
            return true
        else
            put the object_Version of someView into thisVersion
            put the object_Version of libraryView into libraryVersion
            if thisVersion = libraryVersion then
                return "Delete"
            else
                return false
            end if
        end if
    end if
end disabled_UpdateLibraryView

getprop disabled_ViewTools
   put menu_GetTarget("Global | Script | Editor | Menu") into someView
   if exists(someView) is false then 
      log_Error "menu_GetTarget('Global | Script | Editor | Menu') does not exist!", "disabled_ViewTools", true
      return true
   end if
   
   -- this happens before sending,
   -- and before constructing "menu_ViewTools" subMenu using "view_ToolMenus"
   -- so lets set the menuTarget!
   
   -- put "Global | Record | Menu" into viewsMenuTitles
   put the menu_ToolTitle of someView into viewsMenuTitle
   menu_SetTitleTargetOveride viewsMenuTitle, someView
   
   put the menu_ToolTitle of someView into mTitle
   put menu_GetGlobalController(mTitle) into viewToolControllerObject
   if exists(viewToolControllerObject) then
      return false
   else
      return "delete"
   end if
end disabled_ViewTools
