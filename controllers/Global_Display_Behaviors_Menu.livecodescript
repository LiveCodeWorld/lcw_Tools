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

getprop menu_Target [tObject]
   put the display_View of tObject into displayView
   put displayView into LocalArray ["displayView"]
   put the displayed_Object of displayView into moduleView
   
   /*
   put the displayed_ProjectName of displayView into LocalArray ["projectName"]
   put the displayed_ProjectFolder of displayView into LocalArray ["projectFolder"]
   put the displayed_ModuleFolder of displayView into LocalArray ["moduleFolder"]
   put the displayed_ModuleName of displayView into LocalArray ["moduleName"]
   put the displayed_ModuleHomeStackPath of displayView into LocalArray ["moduleHomeStackPath"]
   */
   return moduleView
end menu_Target


--> Global | Display | Behaviors | Menu
-
on menu_SetModuleBehavior moduleView
   put the module_DefaultBehavior of moduleView
   
end menu_SetModuleBehavior

private on __
end __

on submenu_Dev
   return menu_DevTitle()
end submenu_Dev

