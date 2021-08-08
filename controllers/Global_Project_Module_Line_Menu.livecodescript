script "Global | Project | Module | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Project | Module | Line | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
private function _GetStackName displayView
   put the selected_Line of displayView into stackName
   return stackName
end _GetStackName

private function _GetModuleStackPath displayView
   put _GetStackName (displayView) into moduleName
   put the title_Text of displayView into projectName
   put module_GetHomePath (moduleName, projectName) into stackPath
   return stackPath
end _GetModuleStackPath 


--> Global | Project | Module | Line | Menu
-
on menu_DisplayModule displayView
   put _GetModuleStackPath (displayView) into stackPath
   --
   toplevel stack stackPath
end menu_DisplayModule

on menu_DisplayModuleTools displayView
   put _GetModuleStackPath (displayView) into stackPath
   --
   display_ModuleTools stackPath
end menu_DisplayModuleTools

on _
end _

on menu_CreateModule displayView
   put the title_Text of displayView into projectName
   put lcw_Ask ("What name would you like for this module?", "View|Something") into moduleName
   module_CreateWithObject moduleName, projectName
end menu_CreateModule

on menu_RemoveFromMemory displayView
   put _GetStackName (displayView) into stackName
   --
   delete stack stackName
end menu_RemoveFromMemory


