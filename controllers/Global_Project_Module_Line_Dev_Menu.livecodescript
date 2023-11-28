script "Global | Project | Module | Line | Dev | Menu"
--> MetaData
-
license: GPLv3
name: Global | Project | Module | Line | Dev | Menu
type: controller
author: David Bovill
version: 0.1

/*
Here you can describe this menu.
Full help text should be provided on the linked wiki.
*/

--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   _Init tObject
   return LocalArray ["moduleName"]
end menu_Target

command _Init tObject
   put the display_View of tObject into displayView
   put the selected_Line of displayView into moduleName
   put the title_Text of displayView into projectName
   
   if exists (stack moduleName) is false then
      breakpoint
      return empty
   end if
   
   put the stack_Folder of stack moduleName into moduleFolder
   put project_PathFromFolder (moduleFolder) into moduleHomeStackPath
   
   put the project_Folder of stack moduleName into LocalArray ["projectFolder"]
   put displayView into LocalArray ["displayView"]
   put moduleName into LocalArray ["moduleName"]
   put moduleFolder into LocalArray ["moduleFolder"]
   put moduleHomeStackPath into LocalArray ["moduleHomeStackPath"]
   put projectName into LocalArray ["projectName"]
end _Init

private function _GetProjectFolder
   return LocalArray ["projectFolder"]
end _GetProjectFolder

private function _GetModuleFolder
   return LocalArray ["moduleFolder"]
end _GetModuleFolder


--> Global | Project | Module | Line | Dev | Menu
-
on menu_ScriptOnly moduleName
   put the scriptonly of stack moduleName into isScriptOnly
   set the scriptonly of stack moduleName to isScriptOnly is false
end menu_ScriptOnly

on menu_RevealModuleFolder
   put _GetModuleFolder() into moduleFolder
   finder_Reveal moduleFolder
end menu_RevealModuleFolder

on menu_RemoveFromMemory moduleName
   -- delete stack moduleName
   put _GetProjectFolder() into projectFolder
   module_RemoveFromMemory moduleName, projectFolder
end menu_RemoveFromMemory

