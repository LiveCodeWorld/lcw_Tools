script "Global | Display | Behaviors | Dev | Menu"
--> MetaData
-
license: GPLv3
name: Global | Display | Behaviors | Dev | Menu
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
   -- return display_MenuTarget(tObject)
   return the display_View of tObject
end menu_Target

getprop menu_CheckTarget [mTarget]
   return exists (mTarget)
end menu_CheckTarget


--> Global | Display | Behaviors | Dev | Menu
-
on menu_ModuleProperties dView
   put the view_Name of dView into viewName
   display_Template viewName
   --
   put the result into moduleObject
   display_ObjectProperties moduleObject
end menu_ModuleProperties

on menu_DisplayModuleTools dView
   -- put the menu_Name of me into mName
   put the view_Name of dView into viewName
   --
   display_ModuleTools viewName
end menu_DisplayModuleTools

on menu_Behavior dView
   put the behavior of dView into bObject
   edit the script of bObject
end menu_Behavior

private on _
end _

on menu_FixBrokenBehavior moduleView
   breakpoint
   _SetModuleFolder viewObject, moduleStackName, moduleFolder
   put the module_Behaviors of stack moduleStackName into moduleBehaviors
   set the behavior_Objects of viewObject to moduleBehaviors
end menu_FixBrokenBehavior

private command _SetModuleFolder @someView, @moduleStackName, @moduleFolder
   put LocalArray ["displayView"] into displayView
   --
   put the displayed_Object of displayView into cardObject
   put the selected_Value of displayView into shortObject
   
   put shortObject && "of" && cardObject into someView -- hack
   put revRuggedID (someView) into someView
   
   put the view_Name of someView into moduleStackName
   if exists (stack moduleStackName) is false then
      breakpoint
      return empty
   end if
   put the module_Folder of stack moduleStackName into moduleFolder
   return moduleFolder
end _SetModuleFolder
