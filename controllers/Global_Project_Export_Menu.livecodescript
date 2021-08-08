script "Global | Project | Export | Menu"
--> MetaData
-
license: GPLv3
name: Global | Project | Export | Menu
type: controller
version: 0.1


--> Variables
-
local LocalArray

getprop menu_Target [tObject]
   put the title_Text of tObject into projectName
   if exists (stack projectName) is false then return empty
   return the namme of stack projectName
end menu_Target


--> Global | Project | Export | Menu
-
on menu_ExportScriptObject stackObject
   script_ExportHandlersAndCalls stackObject, true
end menu_ExportScriptObject

on menu_ExportAndIndexProject stackObject
   put the project_Name of stackObject into projectName
   
   env_ExportAndIndexProject projectName
   put the result into hkeyPlaceArray
   
   display_Array hkeyPlaceArray
end menu_ExportAndIndexProject

on _
end _

on menu_ExportMenusAndStackFiles
   env_ExportMenusAndStackFiles
end menu_ExportMenusAndStackFiles

on menu_ExportAndIndexHandlers
   env_ExportAndIndexProjects
   answer "Exported all stacks!"
end menu_ExportAndIndexHandlers
