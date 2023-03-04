script "Global | Module | Behavior | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Module | Behavior | Line | Menu
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
   put the display_View of tObject into dView
   return dView
end menu_Target

getprop menu_CheckTarget [dView]
   put item 2 of the selected_Path of dView into shortFile
   if shortFile is not empty then
      --  if exists (stack bStackName) then
      return true
   else
      return false
   end if
end menu_CheckTarget

private function _GetShortFile dView
   put item 2 of the selected_Path of dView into shortFile
   return shortFile
end _GetShortFile

private function _GetModuleView dView
   put _GetModuleStackName (dView) into moduleStackName
   if exists (control 1 of cd 1 of stack moduleStackName) is false then return empty
   
   put the long id of control 1 of cd 1 of stack moduleStackName into moduleView
   return moduleView
end _GetModuleView

private function _GetModuleStackName dView
   put the title_Text of dView into moduleStackName
   return moduleStackName
end _GetModuleStackName

private function _GetModuleFolder dView
   put _GetModuleStackName (dView) into moduleStackName
   put the module_Folder of stack moduleStackName into moduleFolder
   return moduleFolder
end _GetModuleFolder

private function _GetStackPath dView
   get the selected_Path of dView
   put item 1 of it into shortFolder
   put item 2 of it into shortFile
   --
   put _GetModuleFolder (dView) into moduleFolder
   put folder_AddShort (moduleFolder, shortFolder) & shortFile into stackPath
   --
   return stackPath
end _GetStackPath

private function _ConstructModulePath dView
   put _GetModuleFolder (dView) into moduleFolder
   put project_ConstructHomeStackPath (moduleFolder) into mStackPath
   return mStackPath
end _ConstructModulePath


--> Global | Module | Behavior | Line | Menu
-
on menu_EditStackScript dView
   put _GetStackPath (dView) into stackPath
   --
   edit the script of stack stackPath
end menu_EditStackScript

on menu_NewBehavior dView
   put lcw_Ask ("What name do you want to give this new behavior?", "behavior_New") into newBehaviorName
   if there is a stack newBehaviorName then
      lcw_AnswerWarning "A stack named '[[newBehaviorName]]' already exists!", dView, newBehaviorName
   end if
   --
   put _GetModuleStackName (dView) into moduleStackName
   put the module_Folder of stack moduleStackName into moduleFolder
   --
   put newBehaviorName & ".livecodescript" into bShortPath
   put module_ConstructBehaviorPath (newBehaviorName, moduleFolder, bShortPath) into newBehaviorStackPath
   if there is a stack newBehaviorStackPath then
      put newBehaviorStackPath
      lcw_AnswerWarning "A stack at this path already exists!", dView
   end if
   --
   module_CreateBehavior moduleFolder, newBehaviorName
   put the result into newBehaviorStackPath
   --
   menu_Refresh dView
end menu_NewBehavior

on menu_RenameBehavior dView
   put _GetStackPath (dView) into stackPath
   --
   put the script_Name of stack stackPath into oName
   put _GetModuleStackName (dView) into moduleStackName
   put project_DefaultBehaviorName (moduleStackName) into newBehaviorName
   --
   put "Do you want to rename the current behavior '[[oName]]' to the default name '[[newBehaviorName]]'?" into someQuestion
   lcw_Answer someQuestion, dView, oName, newBehaviorName
   --
   module_MoveRenameBehavior stackPath, newBehaviorName
   put the result into newBehaviorPath
   --
   edit the script of stack newBehaviorPath
end menu_RenameBehavior

on _
end _

on menu_Reveal dView
   put _ConstructModulePath (dView) into mStackPath
   finder_Reveal mStackPath
end menu_Reveal

on menu_CheckBehavior dView
   put _GetModuleView (dView) into moduleView
   put moduleView
end menu_CheckBehavior

on menu_Refresh dView
   put _ConstructModulePath (dView) into mStackPath
   display_ModuleTools mStackPath
end menu_Refresh

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on _EditShortFile dView
   breakpoint
   put "behavior_ZZZ" into newBehaviorName
   --
   put _GetStackPath (dView) into stackPath
   module_RenameBehavior stackPath, newBehaviorName
   --
   edit the script of stack stackPath
end _EditShortFile

on _TextSimpleRename dView
   put "behavior_ZZZ" into newBehaviorName
   --
   put _GetStackPath (dView) into stackPath
   module_RenameBehavior stackPath, newBehaviorName
   --
   edit the script of stack stackPath
end _TextSimpleRename

on _TestMoveRename dView
   put "behavior_XXX" into afds
   --
   put _GetStackPath (dView) into stackPath
   put the script_Name of stack stackPath into oName
   put project_DefaultBehaviorName (moduleStackName) into newBehaviorName
   --
   module_MoveRenameBehavior stackPath, newBehaviorName
   put the result into newBehaviorPath
   --
   edit the script of stack newBehaviorPath
end _TestMoveRename

on _RevealBehaviorFolder dView
   put _GetStackPath (dView) into behaviorStackPath
   --
   finder_Reveal behaviorStackPath
end _RevealBehaviorFolder

on _RenameBehavior dView
   put _GetStackPath (dView) into stackPath
   put _GetModuleStackName (dView) into moduleStackName
   put project_DefaultBehaviorName (moduleStackName) into newBehaviorName
   --
   module_RenameBehavior stackPath, newBehaviorName
   --
   edit the script of stack newBehaviorName
end _RenameBehavior


