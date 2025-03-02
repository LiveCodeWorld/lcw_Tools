script "Global | View | Update | Menu"
--> MetaData
-
license: GPLv3
name: Global | View | Update | Menu
type: controller
version: 0.1


--> Variables
-
local ViewIsObject, ViewIsOld


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

getprop menu_CheckTarget [sView]
   return _isTemplate (sView)
end menu_CheckTarget

private function library_AskNewViewName vName
   put lcw_Ask ("Give the cloned view a name...", vName) into vName
   if exists (stack vName) then
      beep
      put merge ("The view '[[vName]]' already exists! Please manually delete the file or choose a new name.") into someWarning
      answer warning someWarning
      go to stack vName
      exit to top
   end if
   return vName
end library_AskNewViewName

private function _isTemplate viewObject
   if exists (viewObject )is false then return false
   
   put the view_Name of viewObject into vName
   if vName = empty then
      return false
   else
      put the view_Template of viewObject into templateObject
      return templateObject = viewObject
   end if
end _isTemplate

function view_ListNestedNames tObject
   put the view_NestedData of tObject into nestedViewArray
   put viewArray_GetInner (nestedViewArray) into innerViewArray
   put keys (innerViewArray) into innerViewNames
   return innerViewNames   
end view_ListNestedNames


--> Global | View | Update | Menu
-
on menu_UpdateProjectArray sView
   put the project_Name of sView into projectName
   display_UpdateProjectArray projectName
   display_ProjectArray projectName, true
end menu_UpdateProjectArray

on menu_UpdateModuleArray viewObject
   put the module_Name of viewObject into moduleStackName
   module_Update moduleStackName
   put the result into moduleArray
   
   # Check
   put project_GetArrayFromFolder (moduleFolder) into moduleArray
   display_Data moduleArray, moduleStackName, "Module Array"
   put the result into dView
   return  dView
end menu_UpdateModuleArray

getprop checked_UpdateModuleArray [viewObject]
   put the module_JsonFile of viewObject into moduleJsonFile
   return there is a file moduleJsonFile   
end checked_UpdateModuleArray

getprop disabled_UpdateModuleArray [viewObject]
   put the module_Name of viewObject into moduleStackName
   return moduleStackName is empty
end disabled_UpdateModuleArray
   
on menu_DisplayNestedViewArray viewObject
   display_NestedViewArray viewObject
end menu_DisplayNestedViewArray

private on _
end _

on menu_Swap sView, vName
   put the mobile_Name of sView into mTarget
   set the view_Swap [false] of mTarget to vName
end menu_Swap

getprop swap_Params [sView]
   return LocalArray ["nestedViews"]
end swap_Params

getprop disabled_Swap [sView]
   put view_ListNestedNames (sView) into nestedViews
   put nestedViews into LocalArray ["nestedViews"]
   return nestedViews is empty
end disabled_Swap

on menu_DisplayViewOutline sView, pDisplayView
   put the view_NestedData of sView into nestedViewArray
   put the name of sView into someTitle
   
   put viewArray_GetInner (nestedViewArray) into innerViewArray
   put nestedViewArray ["dictionary"][1] into metadataArray
   --
   display_Tool innerViewArray, someTitle, "View Outline", pDisplayView
   --   
   put the result into displayView
   set the displayed_Object of displayView to sView
   set the displayed_NestedViewArray of displayView to nestedViewArray
end menu_DisplayViewOutline

private on ___
end ___

on menu_GoAndCheckVersion mTarget
   view_CheckVersion mTarget
end menu_GoAndCheckVersion

on menu_UpdateLibraryView mTarget
   view_AskUpdate mTarget
end menu_UpdateLibraryView

on menu_UpdateToLibraryView mTarget
   view_AskUpdate mTarget
end menu_UpdateToLibraryView

on ____
end ____

on menu_CreateNewComponent sView
   put the view_Name of sView into vName
   put library_AskNewViewName (vName) into vName
   
   library_CreateComponent vName, sView
   put the result into copiedView
   put the filename of stack vName into someFile
end menu_CreateNewComponent

on menu_DefaultBahaviorScript sView
   put the template_DefaultScript of sView
end menu_DefaultBahaviorScript

on submenu_Development
   return menu_DevTitle ("Global | View | Update | Menu")
end submenu_Development
