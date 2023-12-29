script "Global | View | Card | Create | Dev | Menu"
--> MetaData
-
license: GPLv3
name: Global | View | Card | Create | Dev | Menu
type: controller
author: David Bovill
version: 0.1

/*
Here you can describe this developer menu.
Full help text should be provided on the linked wiki.

Consider improving by creating with same menu_Target as no-developer menu is is based on.
*/

--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   return the card_Object of tObject
end menu_Target

-- getprop menu_CheckTarget [mTarget]
return exists (mTarget)
end menu_CheckTarget

getprop disabled_CreateViewGroup [cardObject]
   if exists (control 1 of cardObject) then
      return true
   else
      return false
   end if
end disabled_CreateViewGroup


--> Global | View | Card | Create | Dev | Menu
-
on menu_SetModuleBehavior cardObject
   put the long id of control 1 of cardObject into viewObject
   --
   put the module_Behaviors of viewObject into moduleBehaviors
   
   breakpoint
   set the behavior_Objects of viewObject to moduleBehaviors
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
