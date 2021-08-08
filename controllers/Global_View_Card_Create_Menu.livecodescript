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

getprop disabled_MakeFirstControlAView [cardObject]
   if exists (control 1 of cardObject) then
      return false
   else
      return true
   end if
end disabled_MakeFirstControlAView

getprop disabled_CreateViewGroup [cardObject]
   if exists (control 1 of cardObject) then
      return true
   else
      return false
   end if
end disabled_CreateViewGroup

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
         lcw_Answer "Behaviors still nto fixed!"
         break
   end switch
end _TestLayoutControl

--> Global | View | Card | Create | Menu
-
on menu_FixBehaviorObjects cardObject
   put the long id of control 1 of cardObject into viewObject
   --
   get the behavior_Objects of viewObject
   set the behavior_Objects of viewObject to it
   --
   _TestLayoutControl viewObject
end menu_FixBehaviorObjects

on menu_SetModuleBehavior cardObject
   put the long id of control 1 of cardObject into viewObject
   --
   put the module_Behaviors of viewObject into moduleBehaviors
   set the behavior_Objects of viewObject to moduleBehaviors
   --
   _TestLayoutControl viewObject
end menu_SetModuleBehavior

on menu_CreateViewGroup cardObject
   put the stack_Name of cardObject into viewName
   go to stack viewName -- sets the topstack
   
   create group viewName
   put it into createdObject
   select createdObject
   choose pointer tool
   
   dispatch "resizeStack" to createdObject
   
   put metadata_ConstructArray (viewName, "view") into uripArray
   set the object_Metadata of createdObject to uripArray
   
   put the module_Behaviors of createdObject into moduleBehaviors
   set the behavior_Objects of createdObject to moduleBehaviors
   
   set the lockloc of createdObject to true
   set the showborder of createdObject to true
   display_ObjectProperties createdObject
   edit the script of the behavior of createdObject
end menu_CreateViewGroup

on menu_MakeFirstControlAView cardObject
   -- menu_SetViewMetadata
   put the long id of control 1 of cardObject into viewObject
   put the stack_Name of cardObject into viewName
   --
   put metadata_ConstructArray (viewName, "view") into uripArray
   -- set the view_Name ["view"] of viewObject to viewName
   set the script_MetaData of viewObject to uRipArray
   put the result into uRipArray
   
   set the name of viewObject to viewName
   put the module_Behaviors of viewObject into moduleBehaviors
   set the behavior_Objects of viewObject to moduleBehaviors
   
   display_ObjectProperties viewObject
   edit the script of viewObject
end menu_MakeFirstControlAView

on _
end _

on menu_ViewScript cardObject
   edit the script of control 1 of cardObject
end menu_ViewScript

on menu_ViewBehavior cardObject
   put the behavior of control 1 of cardObject into bObject
   edit the script of bObject
end menu_ViewBehavior

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_TemplateCardBehavior cardObject
   put the behavior of cardObject into bObject
   edit the script of bObject
end menu_TemplateCardBehavior
