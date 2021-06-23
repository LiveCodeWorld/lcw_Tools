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

on menu_Init tObject
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
end menu_Init

-- getprop disabled_CreateModuleMenu [displayView]
put _GetModuleMenuTitle (displayView) into gMenuTitle
if menu_Exists (gMenuTitle) then
   return true
else
   return false
end if
end disabled_CreateModuleMenu

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

getprop disabled_CreateModuleBehavior [viewObject]
   put _GetModuleBehaviorName() into bStackName
   if exists (stack bStackName) then
      return true
   else
      return false
   end if
end disabled_CreateModuleBehavior

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

private function _askMenuTitle moduleStackName, projectName
   put line 1 of the clipboarddata ["text"] into maybeMenuTitle
   if word -1 of maybeMenuTitle = "Menu" then
      put maybeMenuTitle into gMenuTitle
   else
      put module_ConstructGlobalMenuTitle (moduleStackName) into gMenuTitle
   end if
   put "What is the name of your global menu...." into someQuestion
   put lcw_Ask (someQuestion, gMenuTitle) into gMenuTitle
   return gMenuTitle
end _askMenuTitle


--> Global | Module | Menu
-
on menu_OpenModule
   put LocalArray ["moduleStackName"] into moduleStackName
   --
   go to stack moduleStackName
end menu_OpenModule

on menu_CloseModuleStack
   put LocalArray ["moduleStackName"] into moduleStackName
   --
   module_CloseStackAndTools moduleStackName
end menu_CloseModuleStack

on _
end _

on menu_CreateModuleMenu
   put LocalArray ["moduleStackName"] into moduleStackName
   --
   put _askMenuTitle (moduleStackName) into gMenuTitle
   if menu_Exists (gMenuTitle) then
      lcw_AnswerWarning "Menu [[gMenuTitle]] already exists!", displayView, gMenuTitle
   end if
   --
   put the module_Folder of stack moduleStackName into moduleFolder
   module_CreateMenu moduleFolder, gMenuTitle
   put the result into controllerStackObject
   --
   edit the script of controllerStackObject
end menu_CreateModuleMenu

on menu_RemoveModuleMenu displayView
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
end menu_RemoveModuleMenu

on menu_EditModuleMenu displayView
   put _GetModuleMenuTitle (displayView) into gMenuTitle
   edit the script of stack gMenuTitle
end menu_EditModuleMenu

on _
end _

on menu_CreateModuleBehavior viewObject
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
end menu_CreateModuleBehavior

on menu_EditModuleBehavior displayView
   put _GetModuleBehaviorName (displayView) into bStackName
   edit the script of stack bStackName
end menu_EditModuleBehavior

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_EditModuleToolMenu displayView
   menu_Edit "Global | Module | Tree | Menu"
   menu_Edit "Global | Module | Menu"
end menu_EditModuleToolMenu

on menu_SetModuleBehavior
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
end menu_SetModuleBehavior

on _
end _

on menu_RevealModuleFolder
   put LocalArray ["moduleStackName"] into moduleStackName
   --
   put the module_Folder of stack moduleStackName into moduleFolder
   --
   finder_Reveal moduleFolder
end menu_RevealModuleFolder

on menu_ResetMenus
   put LocalArray ["viewObject"] into viewObject
   put LocalArray ["displayView"] into displayView
   --
   put view_ConstructToolMenu (viewObject) into mTitles
   set the title_Menu of displayView to mTitles
end menu_ResetMenus
