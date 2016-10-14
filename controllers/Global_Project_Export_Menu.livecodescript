script "Global_Project_Export_Menu"
--> MetaData
-
license: GPLv3
name: Global_Project_Export_Menu
type: controller
version: 0.1


--> Global | Project | Export | Menu
-
on menu_ExportScriptObject treeView
   put the displayed_Object of treeView into stackObject
   script_ExportHandlersAndCalls stackObject, true
end menu_ExportScriptObject

on menu_ExportAndIndexProject treeView
   put the stack_Object of treeView into stackObject
   put the label of stackObject into projectName
   
   env_ExportAndIndexProject projectName
   put the result into hkeyPlaceArray
   
   display_Array hkeyPlaceArray
end menu_ExportAndIndexProject

on _
end _

on menu_ExportAllProjects
   env_ExportAndIndexProjects
   answer "Exported all stacks!"
end menu_ExportAllProjects
