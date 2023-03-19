script "Global | Module | Menu"
--> MetaData
-
license: GPLv3
name: Global | Module | Menu
type: controller
version: 0.2


--> Menu | Props
-
local LocalArray

getprop menu_Target [tObject]
   put the display_View of tObject into displayView
   put the title_Text of displayView into moduleStackName
   --
   if exists (control 1 of cd 1 of stack moduleStackName) then
      put the long id of control 1 of cd 1 of stack moduleStackName into viewObject
   end if
   --
   put displayView into LocalArray ["displayView"]
   put moduleStackName into LocalArray ["moduleStackName"]
   put viewObject into LocalArray ["viewObject"]
   --
   return displayView
end menu_Target

getprop disabled_EditMenu [viewObject]
   put _GetModuleMenuTitle() into gMenuTitle
   if menu_Exists (gMenuTitle) then
      return false
   else
      return true
   end if
end disabled_EditMenu

getprop disabled_EditModuleBehavior [viewObject]
   put _GetModuleBehaviorName() into bStackName
   if exists (stack bStackName) then
      return false
   else
      return true
   end if
end disabled_EditModuleBehavior

-- getprop disabled_CreateModuleMenu [displayView]
put _GetModuleMenuTitle() into gMenuTitle
put menu_GetGlobalController (gMenuTitle) into mController
if exists (mController) then
   return true
else
   if exists (stack gMenuTitle) is true then
      -- needs indexing so lets do that and save the array
      set the menu_Update of stack gMenuTitle to true
      put the result into projectArray
      return true
   else
      -- could try and find from path
      -- put LocalArray ["viewObject"] into viewObject
      -- put the module_Folder of viewObject into moduleFolder
      return false
   end if
end if
end disabled_CreateModuleMenu

private function _GetModuleBehaviorName
   put LocalArray ["moduleStackName"] into moduleStackName
   put project_DefaultBehaviorName (moduleStackName) into bStackName
   return bStackName
end _GetModuleBehaviorName

private function _GetModuleMenuTitle
   put LocalArray ["moduleStackName"] into moduleStackName
   put module_ConstructGlobalMenuTitle (moduleStackName) into gMenuTitle
   return gMenuTitle
end _GetModuleMenuTitle


--> Global | Module | Menu
-
on menu_CreateModuleMenu displayView
   put LocalArray ["moduleStackName"] into moduleStackName
   --
   put _GetModuleMenuTitle() into gMenuTitle
   put menu_GetGlobalController (gMenuTitle) into mController
   if exists (mController) then
      put module_ConstructGlobalMenuTitle (moduleStackName & "|Test") into gMenuTitle
      ask_CreateModuleMenu moduleStackName, displayView, gMenuTitle
   else
      ask_CreateModuleMenu moduleStackName, displayView
   end if
   --
   put the result into mController
   if exists (mController) then
      edit the script of mController
   end if
end menu_CreateModuleMenu

on menu_EditModuleMenu displayView
   put _GetModuleMenuTitle() into gMenuTitle
   menu_Edit gMenuTitle
   --
   menu_Edit "Global | Module | Menu"
   menu_Edit "Global | Module | Tree | Menu"
end menu_EditModuleMenu

private on __
end __

on menu_EditModuleBehavior
   put _GetModuleBehaviorName() into bStackName
   edit the script of stack bStackName
end menu_EditModuleBehavior

on menu_CreateModuleBehavior
   put LocalArray ["moduleStackName"] into moduleStackName
   put project_DefaultBehaviorName (moduleStackName) into maybeBehaviorStackName
   put the module_Folder of stack moduleStackName into moduleFolder
   --
   put lcw_Ask ("What name would you like for this modules behavior?", maybeBehaviorStackName) into behaviorStackName
   --
   module_CreateBehavior moduleFolder, behaviorStackName
   put the result into moduleBehaviorStackPath
   --
   edit the script of stack moduleBehaviorStackPath
   --
   display_ModuleTools moduleStackName
end menu_CreateModuleBehavior

on menu_RenameModule
   put LocalArray ["moduleStackName"] into oldModuleName
   --
   put the project_Folder of stack oldModuleName into projectFolder
   put the project_Name of stack oldModuleName into projectName
   put lcw_Ask ("Give this module a new name...", oldModuleName) into newModuleName
   --
   module_Rename oldModuleName, newModuleName, projectName
   --
   display_ProjectLibs projectName
end menu_RenameModule

on menu_RemoveFromMemory displayView
   put LocalArray ["moduleStackName"] into moduleName
   put the project_Folder of stack moduleName into projectFolder
   --
   module_RemoveFromMemory moduleName, projectFolder
end menu_RemoveFromMemory

private on _
end _

on _DisplayModuleTools
   put LocalArray ["moduleStackName"] into moduleStackName
   --
   display_ModuleTools moduleStackName
end _DisplayModuleTools

on submenu_Tools
   return "Global | Module | Tree | Menu"
end submenu_Tools

on _RemoveModuleMenu displayView
   put _GetModuleMenuTitle() into gMenuTitle
   lcw_Answer merge ("Are you sure you want to remove the default menu '[[gMenuTitle]]' for this module from the global database?"), gMenuTitle
   --
   menu_RemoveGlobalController gMenuTitle
   put the result into mController
   if exists (mController) then
      get the script of mController
      if gMenuTitle is among the lines of it then
         edit the script of mController
      end if
   end if
end _RemoveModuleMenu

on _RevealModuleFolder
   put LocalArray ["moduleStackName"] into moduleStackName
   --
   put the module_Folder of stack moduleStackName into moduleFolder
   --
   finder_Reveal moduleFolder
end _RevealModuleFolder

on _
end _

on _OpenModule
   put LocalArray ["moduleStackName"] into moduleStackName
   --
   go to stack moduleStackName
end _OpenModule

on _CloseModuleStack
   put LocalArray ["moduleStackName"] into moduleStackName
   --
   module_CloseStackAndTools moduleStackName
end _CloseModuleStack

on _
end _

on _EditModuleToolMenu
   menu_Edit "Global | Module | Tree | Menu"
   menu_Edit "Global | Module | Menu"
end _EditModuleToolMenu

on _SetModuleBehavior
   put LocalArray ["moduleStackName"] into moduleStackName
   --
   put the module_Folder of stack moduleStackName into moduleFolder
   put module_ConstructBehaviorPath (moduleStackName, moduleFolder) into bPath
   --
   if there is a stack bPath then
      put LocalArray ["viewObject"] into viewObject
      --
      set the behavior of viewObject to the long id of stack bPath
      put the behavior of viewObject into bObject
      edit the script of bObject
   end if
end _SetModuleBehavior

on _
end _

on _ResetMenus
   put LocalArray ["viewObject"] into viewObject
   put LocalArray ["displayView"] into displayView
   --
   put view_ConstructToolMenu (viewObject) into mTitles
   set the title_Menu of displayView to mTitles
end _ResetMenus
