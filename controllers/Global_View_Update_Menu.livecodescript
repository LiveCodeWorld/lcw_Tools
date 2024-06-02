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

getprop disabled_InsertMenuGroup [sView]
   put the menubar_View of sView into mGroup
   if exists (mGroup) then
      return "delete"
   else
      return false
   end if
end disabled_InsertMenuGroup

getprop disabled_DeleteMenuGroup [sView]
   put the menubar_View of sView into mGroup
   if exists (mGroup) then
      return false
   else
      return "delete"
   end if
end disabled_DeleteMenuGroup


--> Global | View | Update | Menu
-
on menu_InsertMenuGroup sView
   put the menubar_View of sView into mGroup
   if exists (mGroup) is true then
      breakpoint
   end if
   
   put the card_Object of sView into cardObject
   lcw_Answer "Sure you want to create a menubar view on this card?", cardObject
   --
   view_InsertFromPath "View|Menu|Group", cardObject
   put the result into mGroup
   set the topleft of mGroup to 0,0
   --
   set the show_menu of mGroup to true
end menu_InsertMenuGroup

on menu_ShowMenu sView
   put the menubar_View of sView into mGroup
   --
   menuBar_ToggleShowMenu mGroup
end menu_ShowMenu

getprop disabled_ShowMenu [sView]
   put the menubar_View of sView into mGroup
   if exists (mGroup) then
      return false
   else
      return "delete"
   end if
end disabled_ShowMenu

getprop checked_ShowMenu [sView]
   put the menubar_View of sView into mGroup
   if exists (mGroup) is false then return false
   --
   put the show_Menu of mGroup into sBoolean
   return sBoolean
end checked_ShowMenu

on menu_DeleteMenuGroup sView
   put the menubar_View of sView into mGroup
   if exists (mGroup) is false then
      breakpoint
   end if
   --
   put the stack_Name of mGroup into stackName
   save stack stackName
   --
   delete mGroup
   --
   set the menuBar of stack stackName to empty
   set the defaultMenuBar to ide_DefaultMenuGroup()
end menu_DeleteMenuGroup

private on __
end __

on menu_CreateNewComponent someView
   put the view_Name of someView into vName
   put library_AskNewViewName (vName) into vName
   
   library_CreateComponent vName, someView
   put the result into copiedView
   put the filename of stack vName into someFile
end menu_CreateNewComponent

on menu_Swap someView, vName
   put the mobile_Name of someView into mTarget
   set the view_Swap [false] of mTarget to vName
end menu_Swap

on menu_DisplayViewOutline someView
   put the view_NestedArray of someView into nestedViewArray
   put nestedViewArray ["viewOutline"] into viewOutline
   
   put the name of someView into someTitle
   put the title_Text of someView into projectName
   put comma & projectName after someTitle
   display_Lines viewOutline, someTitle, "mDoubleUp_View"
   put the result into displayView
   set the displayed_NestedViewArray of displayView to nestedViewArray
end menu_DisplayViewOutline

command mDoubleUp_View displayView, viewName
   get the clickLine
   put word 2 of it into lineNum
   put the displayed_NestedViewArray of displayView into nestedViewArray
   put nestedViewArray ["dictionary"] into viewDictionary
   put viewDictionary [lineNum] into metaDataArray
   put metaDataArray ["rObject"] into viewObject
   put metaDataArray ["view"] into viewName
   
   answer merge ("What would you like to do with the view '[[viewName]]'?") with "Cancel" or "Placeholder" or "Update"
   switch it
      case "Placeholder"
         set the control_Type of viewObject to "placeholder"
         break
      case "Update"
         view_Update viewObject
         break
      default
         exit to top
   end switch
end mDoubleUp_View

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

on menu_DefaultBahaviorScript someView
   put the template_DefaultScript of someView
end menu_DefaultBahaviorScript

on submenu_Development
   return menu_DevTitle ("Global | View | Update | Menu")
end submenu_Development
