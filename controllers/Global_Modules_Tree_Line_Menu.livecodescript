script "Global_Modules_Tree_Line_Menu"
--> MetaData
-
license: GPLv3
name: Global_Modules_Tree_Line_Menu
type: controllers
version: 0.1


--> Menu | Props
-
getprop menu_Target
   put menu_GetTargetObject() into tObject
   put the index_View of tObject into indexView
   put the selected_Index of tObject into viewName
   put view_GetTemplateObject (viewName) into viewObject
   return viewObject
end menu_Target


--> Global | Modules | Tree | Line | Menu
-
on menu_RevealModuleFolder viewObject
   put the module_Folder of viewObject into moduleFolder
   if moduleFolder is empty then
      put the name of viewObject & CR & viewObject
      answer warning "Module folder is empty!"
      breakpoint
      exit to top
   end if
   
   finder_Reveal moduleFolder
end menu_RevealModuleFolder

on _
end _

on menu_AddModuleProject viewObject
   put the module_Folder of viewObject into moduleFolder
   put project_GetName (moduleFolder) into moduleName
   
   library_StoreProjectFolder moduleName, moduleFolder
   env_SetProjectFolder moduleName, moduleFolder
end menu_AddModuleProject

getprop disabled_AddModuleProject [viewObject]
   put the module_Folder of viewObject into moduleFolder
   put project_GetName (moduleFolder) into moduleName
   put library_FetchProjectFolder (moduleName) into moduleFolder
   if there is a folder moduleFolder then return "delete"
   
   return false
end disabled_AddModuleProject

on menu_DisplayModule viewObject
   put the module_Folder of viewObject into moduleFolder
   display_Module moduleFolder
end menu_DisplayModule
