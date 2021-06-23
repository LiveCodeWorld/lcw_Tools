script "Global | Module | Tree | Menu"
--> MetaData
-
license: GPLv3
name: Global | Module | Tree | Menu
target: indexView
type: controller
version: 0.2


--> Menu | Init
-
local LocalArray

on menu_Init tObject
   put the display_View of tObject into displayView
   --
   put the displayed_Object of displayView into viewObject
   put the displayed_ModuleFolder of displayView into moduleFolder
   put the displayed_ModuleName of displayView into moduleStackName
   put the displayed_ProjectName of displayView into projectName
   put the displayed_ProjectFolder of displayView into projectFolder
   --
   put the title_Text of tObject into moduleName -- only sometimes the same as viewName
   if there is not a stack moduleStackName then return empty
   
   put moduleStackName into LocalArray ["moduleName"]
   --
   if exists (control 1 of cd 1 of stack moduleStackName) is false then return false
   
   put the long id of control 1 of cd 1 of stack moduleStackName into testViewObject
   if testViewObject is not viewObject then
      breakpoint
   end if
   
   put _GetClonedStackNames (viewObject) into clonedStackNames
   put clonedStackNames into LocalArray ["clonedStackNames"]
   --
   put displayView into LocalArray ["displayView"]
   put moduleStackName into LocalArray ["moduleStackName"]
   put viewObject into LocalArray ["viewObject"]
end menu_Init

getprop disabled_CloseModuleStack
   if LocalArray ["clonedStackNames"] is empty then
      return true
   else
      return false
   end if
end disabled_CloseModuleStack

getprop closeModuleStack_Params
   return LocalArray ["clonedStackNames"]
end closeModuleStack_Params

getprop disabled_ModuleStackTools
   if LocalArray ["clonedStackNames"] is empty then
      return "delete"
   else
      return false
   end if
end disabled_ModuleStackTools

getprop moduleStackTools_Params
   return LocalArray ["clonedStackNames"]
end moduleStackTools_Params

command _importMenus viewObject
   put the module_Controllers of viewObject into cObjects
   repeat for each line cObject in cObjects
      if exists (cObject) is false then 
         breakpoint
         next repeat
      end if
      
      if word 1 of cObject is not "stack" then
         breakpoint
         next repeat
      end if
      
      put the stack_Name of cObject into cStackName
      put cStackName && "Dep"
      
      clone cObject
      put it into clonedBehaviorStack
      set the name of clonedBehaviorStack to newName
   end repeat
end _importMenus

private function _GetClonedStackNames viewObject
   put the openstacks into sNames
   put the stack_Name of viewObject into stackName
   put stackName && "*" into someFilter
   filter sNames with someFilter
   --
   replace "|" with ":" in sNames
   return sNames
end _GetClonedStackNames

getprop disabled_SelectModule
   if the selobj is empty then
      return false
   else
      return "delete"
   end if
end disabled_SelectModule

getprop disabled_DeselectModule
   if the selobj is empty then
      return "delete"
   else
      return false
   end if
end disabled_DeselectModule


--> Global | Module | Tree | Menu
-
on submenu_Module
   return "Global | Module | Menu"
end submenu_Module

on _
end _

on menu_SelectModule viewObject
   select viewObject
end menu_SelectModule

on menu_DeselectModule viewObject
   select empty
end menu_DeselectModule

on menu_CloneModule
   put LocalArray ["moduleName"] into moduleName
   --
   stack_Clone moduleName
   put the result into clonedStack
   set the original_ModuleName of clonedStack to moduleName
   --
   put the stack_Name of clonedStack into moduleStackName
   display_ModuleTools moduleStackName
end menu_CloneModule

on menu_CloseModuleStack viewObject, moduleStackName
   replace ":" with "|" in moduleStackName
   --
   module_CloseStackAndTools moduleStackName
end menu_CloseModuleStack

on menu_ModuleStackTools viewObject, moduleStackName
   replace ":" with "|" in moduleStackName
   --
   display_ModuleTools moduleStackName
end menu_ModuleStackTools

on _
end _

on menu_ExportMenusAndStackFiles viewObject
   put the module_Folder of viewObject into moduleFolder
   --
   project_ExportMenusAndStackFiles moduleFolder
   put the result into projectArray
   --
   put the view_Name of viewObject into moduleName
   display_Data projectArray, moduleName, "Module Array"  
end menu_ExportMenusAndStackFiles

on menu_RefreshProps viewObject
   put LocalArray ["displayView"] into displayView
   --
   put the view_Props of viewObject into viewProps
   set the displayed_Data of displayView to viewProps
end menu_RefreshProps

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_ModuleInfo viewObject
   put the module_Array of viewObject into moduleArray
   put moduleArray ["moduleName"] into moduleName
   put merge ("[[moduleName]],Module Array") into someTitle
   display_Array moduleArray, someTitle
end menu_ModuleInfo

on menu_DisplayToolMenuTitles viewObject
   put LocalArray ["viewObject"] into viewObject
   put view_ConstructToolMenu (viewObject)
end menu_DisplayToolMenuTitles

on menu_EditViewMenuFunction
   -- find the function that creates the menu table for the tree
   
   hkey_Edit "F view_ConstructToolMenu"
   --
   if the result is empty then 
      edit the script of stack "lib_DisplayView"
   end if
end menu_EditViewMenuFunction

on menu_EditDisplayModuleTools
   hkey_Edit "M display_ModuleTools"
   --
   if the result is empty then 
      edit the script of stack "lib_DisplayModule"
   end if
end menu_EditDisplayModuleTools

on _
end _

on menu_EditMenus
   menu_Edit "Global | View | Card | Tools | Menu"
   menu_Edit "Global | View | Card | Create | Menu"
end menu_EditMenus

on menu_ResetMenus viewObject
   put LocalArray ["displayView"] into displayView
   --
   put view_ConstructToolMenu (viewObject) into mTitles
   set the title_Menu of displayView to mTitles
end menu_ResetMenus

on _
end _

on menu_CreateStandAlone viewObject
   put LocalArray ["displayView"] into displayView
   --
   put the view_Name of viewObject into vName
   put view_GetTemplateObject (vName) into templateObject
   if exists (templateObject) is false then
      breakpoint
   end if
   
   put the stack_Name of templateObject into stackName
   clone stack stackName
   put it into clonedStack
   set the destroyStack of clonedStack to true
   set the destroyWindow of clonedStack to true
   
   put the long id of cd 1 of clonedStack into clonedTemplateCard
   put the long id of control 1 of clonedTemplateCard into clonedView
   
   -- put the module_Behaviors of viewObject into bObjects
   set the imported_ViewBehaviors of clonedView to true
   
   -- set the behavior of clonedTemplateCard to empty
   
   display_ViewBehaviors clonedView, empty, clonedStack
end menu_CreateStandAlone
