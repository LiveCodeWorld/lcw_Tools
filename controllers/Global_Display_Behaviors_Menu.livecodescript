script "Global_Display_Behaviors_Menu"
--> MetaData
-
license: GPLv3
name: Global_Display_Behaviors_Menu
type: modules
version: 0.1


--> Global | Display | Behaviors | Menu
-
on menu_DisplayBehaviors treeView
   put the displayed_Object of treeView into cardObject
   put the stack_Object of treeView into stackObject
   put the label of stackObject
   -- put the title_text of treeView
end menu_DisplayBehaviors


--> Global | Display | Behaviors | Line | Menu
-
on menu_EditBrokenView treeView
   _SetModuleFolder treeView, someView, moduleStackName, moduleFolder
   display_Module moduleFolder
end menu_EditBrokenView

private command _SetModuleFolder treeView, @someView, @moduleStackName, @moduleFolder
   put the displayed_Object of treeView into cardObject
   put the selected_Value of treeView into shortObject
   
   put shortObject && "of" && cardObject into someView -- hack
   put the long id of of someView into someView
   put revRuggedID (someView) into someView
   
   put the view_Name of someView into moduleStackName
   if exists (stack moduleStackName) is false then
      breakpoint
      return empty
   end if
   put the module_Folder of stack moduleStackName into moduleFolder
   return moduleFolder
end _SetModuleFolder

on menu_FixBrokenBehavior treeView
   _SetModuleFolder treeView, someView, moduleStackName, moduleFolder
   
   put the module_Behaviors of stack moduleStackName into moduleBehaviors
   set the behavior_Objects of someView to moduleBehaviors
end menu_FixBrokenBehavior

on _
end _

on menu_DisplayValue treeView
   put the displayed_Object of treeView into cardObject
   put the module_Array of cardObject into moduleArray
   
   put the parent_Array of treeView into parentArray
   put the selected_Value of treeView into someValue
   put the hilited_Element of treeView
   
   -- put the parent_Array of treeView into parentArray
   -- put the hilited_Element of treeView into hilitedElement
   -- put item -1 of hilitedElement into brokenBehavior
end menu_DisplayValue

