script "Global | View | Card | Create | Menu"
--> MetaData
-
license: GPLv3
name: Global | View | Card | Create | Menu
type: controller
version: 0.1


--> Menu | Porps
-
getprop menu_Target [tObject]
   return the card_Object of tObject
end menu_Target

getprop disabled_ViewScript [cardObject]
   if exists (control 1 of cardObject) then
      return false
   else
      return true
   end if
end disabled_ViewScript

getprop disabled_ViewBehavior [cardObject]
   if exists (control 1 of cardObject) is false then return true
   
   put the behavior of control 1 of cardObject into bObject
   if exists (bObject) then
      return false
   else
      return true
   end if
end disabled_ViewBehavior

getprop disabled_SetViewMetadata [cardObject]
   if exists (control 1 of cardObject) is false then return true
   
   put the long id of control 1 of cardObject into viewObject
   put the view_Name of viewObject into viewName
   if viewName is empty then
      return false
   else
      return false
   end if
end disabled_SetViewMetadata

private command _TestLayoutControl viewObject
   dispatch "LayoutControl" to viewObject
   switch it
      case "unhandled"
         put the behavior_Objects of viewObject
         lcw_Answer "Behaviors still not fixed!"
         break
   end switch
end _TestLayoutControl

private function _FirstControl cardObject
   put the long id of control 1 of cardObject into viewObject
   return viewObject
end _FirstControl

getprop checked_MakeFirstControlAView [cardObject]
   if exists (control 1 of cardObject) is false then return false
   
   put the view_Object of control 1 of cardObject into viewObject
   return exists (viewObject)
end checked_MakeFirstControlAView


--> Global | View | Card | Create | Menu
-
on menu_MakeFirstControlAView cardObject
   put _FirstControl (cardObject) into viewObject
   put the stack_Name of viewObject into viewName
   --
   set the module_ViewMetaData [true] of viewObject to viewName
   --   
   display_ObjectProperties viewObject
   edit the script of viewObject
end menu_MakeFirstControlAView

private on _
end _

on menu_ViewBehavior cardObject
   put the behavior of control 1 of cardObject into bObject
   edit the script of bObject
end menu_ViewBehavior

on menu_ViewScript cardObject
   edit the script of control 1 of cardObject
end menu_ViewScript

on menu_TemplateCardBehavior cardObject
   put the behavior of cardObject into bObject
   edit the script of bObject
end menu_TemplateCardBehavior

private on __
end __

on menu_FixMenu cardObject
   put _FirstControl (cardObject) into viewObject
   put the stack_Name of viewObject into moduleName
   put menu_GlobalTitleFromViewName (moduleName) into mTitle
   breakpoint
   --  
   set the menu_Title of viewObject to mTitle
end menu_FixMenu

on menu_SetDefaultBehavior cardObject
   put _FirstControl (cardObject) into viewObject
   --
   put the stack_Folder of viewObject into moduleFolder
   put module_BehaviorPathFromFolder (moduleFolder) into bPath
   --
   -- put the module_DefaultBehavior of viewObject into bObject
   -- put the stack_Name of viewObject into moduleName
   -- put module_ConstructBehaviorPath (moduleName, moduleFolder) into bPath
   
   if exists (stack bPath) is false then
      breakpoint
      exit to top
   end if
   
   # Set behavior
   put the name of stack bPath into bObject
   set the behavior of viewObject to bObject
   --
   display_ObjectProperties viewObject
end menu_SetDefaultBehavior

on menu_FixBehaviorObjects cardObject
   put _FirstControl (cardObject) into viewObject
   --
   breakpoint
   put the module_Behaviors of viewObject into bObjects
   set the behavior_Objects of viewObject to bObjects
end menu_FixBehaviorObjects

private on ___
end ___

on submenu_Card
   return "Global | Card | Menu"
end submenu_Card

on submenu_Dev
   return menu_DevTitle ("Global | View | Card | Create | Menu")
end submenu_Dev

on menu_RefreshCard cardObject
   dispatch "refresh" to cardObject
end menu_RefreshCard
