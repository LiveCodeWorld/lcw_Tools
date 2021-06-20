script "Global | Display | Behaviors | Menu"
--> MetaData
-
license: GPLv3
name: Global_Display_Behaviors_Menu
type: controller
version: 0.2


--> Menu | Init
-
local LocalArray

on menu_Init tObject
   put the display_View of tObject into displayView
   put displayView into LocalArray ["displayView"]
   
   /*
   put the displayed_ProjectName of displayView into LocalArray ["projectName"]
   put the displayed_ProjectFolder of displayView into LocalArray ["projectFolder"]
   put the displayed_ModuleFolder of displayView into LocalArray ["moduleFolder"]
   put the displayed_ModuleName of displayView into LocalArray ["moduleName"]
   put the displayed_ModuleHomeStackPath of displayView into LocalArray ["moduleHomeStackPath"]
   */
end menu_Init


--> Global | Display | Behaviors | Menu
-
on menu_DisplayBehaviors displayView
   put the displayed_Object of displayView into cardObject
   put the stack_Object of displayView into stackObject
   put the label of stackObject
   -- put the title_text of displayView
end menu_DisplayBehaviors


--> Global | Display | Behaviors | Line | Menu
-
on menu_EditBrokenView displayView
   put the displayed_Object of displayView into cardObject
   display_Module moduleFolder
end menu_EditBrokenView

on menu_FixBrokenBehavior displayView
   put LocalArray ["displayView"] into displayView
   --
   _SetModuleFolder displayView, viewObject, moduleStackName, moduleFolder
   put the module_Behaviors of stack moduleStackName into moduleBehaviors
   set the behavior_Objects of viewObject to moduleBehaviors
end menu_FixBrokenBehavior

on _
end _

on menu_DisplayValue someView
   put the module_Array of someView into moduleArray
   
   put the parent_Array of displayView into parentArray
   put the selected_Value of displayView into someValue
   put the hilited_Element of displayView
   
   -- put the parent_Array of displayView into parentArray
   -- put the hilited_Element of displayView into hilitedElement
   -- put item -1 of hilitedElement into brokenBehavior
end menu_DisplayValue


--> Private
-
private command _SetModuleFolder displayView, @someView, @moduleStackName, @moduleFolder
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
