script "Global | Module | List | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Module | List | Line | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   put the display_View of tObject into LocalArray ["displayView"]
   put the selected_Line of tObject into shortModuleFolder
   --
   put env_GetModuleHomePath (shortModuleFolder) into moduleStackPath
   put the short name of stack moduleStackPath into LocalArray ["moduleName"]
   put the project_Name of stack moduleStackPath into LocalArray ["projectName"]
   put the project_Folder of stack moduleStackPath into LocalArray ["projectFolder"]
   put the module_Folder of stack moduleStackPath into LocalArray ["moduleFolder"]
   --
   return shortModuleFolder
end menu_Target

getprop moveModule_Param
   return LocalArray ["projectName"]
end moveModule_Param

getprop moveModule_Params
   return library_ListProjectNames()
end moveModule_Params


--> Global | Module | List | Line | Menu
-
on menu_DisplayModule shortModuleFolder
   display_ModuleFromShortModuleFolder shortModuleFolder
end menu_DisplayModule

on menu_DisplayModuleTools shortModuleFolder
   put LocalArray ["moduleName"] into moduleName
   --
   display_ModuleTools moduleName, true
end menu_DisplayModuleTools

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_RenameModule shortModuleFolder
   breakpoint
   
   put LocalArray ["moduleName"] into oldModuleName
   put LocalArray ["projectName"] into projectName
   --
   put lcw_Ask ("Give this module a new name...", oldModuleName) into newModuleName
   module_Rename oldModuleName, newModuleName, projectName
   --
   display_ProjectLibs projectName
   display_ProjectModules projectName
end menu_RenameModule

on menu_RevealModuleFolder shortModuleFolder
   put LocalArray ["moduleFolder"] into moduleFolder
   if moduleFolder is empty then
      answer warning "Module folder is empty!"
      breakpoint
      exit to top
   end if
   
   finder_Reveal moduleFolder
end menu_RevealModuleFolder

on menu_MoveModule moduleShortFolder, newProjectName
   set the cursor to watch
   put LocalArray ["moduleName"] into moduleName
   put LocalArray ["projectName"] into oldProjectName
   put LocalArray ["projectFolder"] into oldProjectFolder
   put LocalArray ["moduleFolder"] into oldModuleFolder
   --
   put library_FetchProjectFolder (newProjectName) into newProjectFolder
   put module_GetFolder (moduleShortFolder, newProjectFolder) into newModuleFolder
   
   breakpoint
   
   -- remove from memory
   module_RemoveFromMemory moduleName, oldProjectFolder
   
   -- move folder
   revMoveFolder oldModuleFolder, newModuleFolder
   
   if the shiftKey is "Up" then
      -- re-index and re-load
      project_ExportMenusAndStackFiles oldProjectFolder
      project_ExportMenusAndStackFiles newProjectFolder
   end if
   
   -- Refresh index views
   display_ProjectModules oldProjectName
   display_ProjectModules newProjectName   
end menu_MoveModule

on menu_ShowModule shortModuleFolder
   put env_GetModuleHomePath (shortModuleFolder) into moduleStackPath
   -- 
   toplevel stack moduleStackPath
   show stack moduleStackPath
   --
   put LocalArray ["displayView"] into displayView
   put globalLoc (the loc of displayView) into gLoc
   set the loc of stack moduleStackPath to gLoc
end menu_ShowModule
