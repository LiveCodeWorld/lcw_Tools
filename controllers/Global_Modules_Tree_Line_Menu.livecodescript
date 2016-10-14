script "Global_Modules_Tree_Line_Menu"
--> MetaData
-
license: GPLv3
name: Global_Modules_Tree_Line_Menu
type: controllers
version: 0.1


--> Variables
-
local LocalArray


--> Menu | Props
-
on menu_Init tObject
   put the index_View of tObject into indexView
   put the selected_Index of indexView into moduleName
   put the displayed_HomeStackName of indexView into projectHomeStackName
   put the displayed_ProjectFolder of indexView into projectFolder
   
   put module_GetFolder (moduleFolderName, projectFolder) into moduleFolder
   put project_ConstructHomeStackPath (moduleFolder) into moduleHomeStackPath
   
   --  if exists (stack moduleHomeStackPath) is false then return empty
   --  put view_GetTemplateObject (moduleName) into viewObject
   put moduleFolder into LocalArray ["moduleFolder"]
   put moduleHomeStackPath into LocalArray ["moduleHomeStackPath"]
   put projectFolder into LocalArray ["projectFolder"]
end menu_Init

getprop menu_Target
   put menu_GetTargetObject() into tObject
   put the selected_Index of tObject into moduleName
   return moduleName
end menu_Target


--> Global | Modules | Tree | Line | Menu
-
on menu_RevealModuleFolder moduleName
   put LocalArray ["moduleFolder"] into moduleFolder
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

on menu_AddModuleProject moduleName
   put LocalArray ["moduleFolder"] into moduleFolder
   
   library_StoreProjectFolder moduleName, moduleFolder
   env_SetProjectFolder moduleName, moduleFolder
end menu_AddModuleProject

on menu_DisplayModule moduleName
   put LocalArray ["moduleFolder"] into moduleFolder
   display_Module moduleFolder
end menu_DisplayModule


--> Global | Modules | Tree | Line | Menu | Props
-

--> Global | Modules | Tree | Line | Menu | Disabled
-
getprop disabled_AddModuleProject [moduleName]
   put the module_Folder of viewObject into moduleFolder
   put project_GetName (moduleFolder) into moduleName
   put library_FetchProjectFolder (moduleName) into moduleFolder
   if there is a folder moduleFolder then return "delete"
   
   return false
end disabled_AddModuleProject
