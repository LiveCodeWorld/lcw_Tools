script "lib_DisplayModule"
--> MetaData
-
license: GPLv3
name: lib_DisplayModule
type: library
version: 0.3


--> Working on
-
command module_CloseStackAndTools moduleStackName
   put display_FindView ("Module Tools", moduleStackName) into displayView
   put the stack_Name of displayView into displayStackName
   --
   -- delete stack moduleStackName
   -- delete stack displayStackName
   send ("delete stack" && kwote (moduleStackName)) to me in 2 ticks
   send ("delete stack" && kwote (displayStackName)) to me in 2 ticks
   --
   return displayView
end module_CloseStackAndTools


--> Display | Events
-
on mDouble_DisplayModuleFromStackName indexView, moduleStackName
   display_ModuleFromStackName moduleStackName
end mDouble_DisplayModuleFromStackName

on mDouble_DisplayModuleFromShortFolder indexView, shortModuleFolder
   display_ModuleFromShortModuleFolder shortModuleFolder
end mDouble_DisplayModuleFromShortFolder

on mDouble_EditProp displayView, hName
   put the selected_Path of displayView into relPath
   replace comma with "/" in relPath
   --
   put the displayed_ModuleFolder of displayView into moduleFolder
   put moduleFolder & relPath into filePath
   --
   if there is a stack filePath then
      set the itemdelimiter to "."
      if item -1 of filePath = "livecode" then
         go to stack filePath
      else
         edit the script of stack filePath
      end if
   else
      put filePath
   end if
end mDouble_EditProp

private command _EditProperty displayView, hName
   put the displayed_Object of indexView into viewObject
   put the behavior of viewObject into viewBehavior
   
   -- put revRuggedID (hObject) into hObject
   put "G" && hName into shortHkeyLine
   put hKeyLine_AddObject (shortHkeyLine, viewBehavior) into hkeyLine
   
   hkey_Edit hkeyLine
end _EditProperty


--> Display | Module
-
command display_ModuleFromStackName moduleStackName
   put the module_Folder of stack moduleStackName into moduleFolder
   display_Module moduleFolder
end display_ModuleFromStackName

command display_ModuleFromShortModuleFolder shortModuleFolder
   put env_GetModuleFolder (shortModuleFolder) into moduleFolder
   --
   display_Module moduleFolder
end display_ModuleFromShortModuleFolder

command display_Module moduleFolder
   -- put project_ConstructHomeStackPath (moduleFolder) into moduleHomeStackPath
   put project_FirstStackPath (moduleFolder) into moduleHomeStackPath
   --
   go to stack moduleHomeStackPath
   --
   put the short name of stack moduleHomeStackPath into moduleName
   display_ModuleTools moduleName, false
   --
   return the result
end display_Module


--> Display | Module | List
-
command display_ProjectModules projectName
   put project_ListModules (projectName) into moduleStackNames
   --
   display_Data moduleStackNames, projectName, "Modules"
   put the result into displayView
   --
   display_SetInteractions displayView, "Modules | Tree", "mDouble_DisplayModuleFromStackName"
   --
   put env_ConstructProjectFolder (projectName) into pProjectFolder
   --
   set the displayed_ProjectFolder of displayView to projectFolder
   set the displayed_ProjectName of displayView to projectName
   return displayView
end display_ProjectModules

command display_ListModules pProjectNames
   put env_ListShortModuleFolders (pProjectNames) into moduleNames
   --
   display_Data moduleNames, "Modules", "Environment"
   put the result into displayView
   --
   display_SetInteractions displayView, "Module | List", "mDouble_DisplayModuleFromShortFolder"
   --
   return displayView
end display_ListModules


--> Deps
-
function env_GetModuleFolder shortModuleFolder
   put env_GetModuleShortFolderArray (shortModuleFolder) into shortFolderArray
   return shortFolderArray ["moduleFolder"]
end env_GetModuleFolder

function env_GetModuleHomePath shortModuleFolder
   put env_GetModuleShortFolderArray (shortModuleFolder) into shortFolderArray
   return shortFolderArray ["homeStackPath"]
end env_GetModuleHomePath

function env_GetModuleShortFolderArray shortModuleFolder
   put env_GetModuleArray() into moduleArray
   put moduleArray ["active"][shortModuleFolder] into shortFolderArray
   return shortFolderArray
end env_GetModuleShortFolderArray
