script "Global | View | Old | Line | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | View | Old | Line | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
on menu_Init tObject
   -- called only once for top menu
   pass menu_Init
end menu_Init

getprop menu_Target [tObject]
   -- called once for each menu
   return the display_View of tObject
end menu_Target

getprop createModule_Params
   put env_ListLocalProjects() into projectNames
   return projectNames
end createModule_Params

getprop disabled_EditBehavior [displayView]
   put _GetBehavior (displayView) into bObject
   return bObject is empty
end disabled_EditBehavior

private function _GetBehavior displayView
   put _SelectedOldViewObject (displayView) into viewObject
   put the behavior of viewObject into bObject
   return bObject
end _GetBehavior

private function _SelectedOldViewObject displayView
   put _SelectedOldViewFile (displayView) into oldViewFile
   if exists (control 1 of card 1 of stack oldViewFile) is false then return empty
   --
   put the long id of control 1 of card 1 of stack oldViewFile into viewObject
   return viewObject
end _SelectedOldViewObject

private function _SelectedOldViewFile displayView
   put the selected_Line of displayView into shortFile
   put view_OldFolder() & shortFile into oldViewFile
   return oldViewFile
end _SelectedOldViewFile


--> Global | View | Old | Line | Menu
-
on menu_EditBehavior displayView
   put _GetBehavior (displayView) into bObject
   edit the script of bObject
end menu_EditBehavior

on menu_DispatchLayoutControl displayView
   put _SelectedOldViewObject (displayView) into viewObject
   --
   dispatch "LayoutControl" to viewObject
end menu_DispatchLayoutControl

on _
end _

on menu_CreateModule displayView, projectName
   put _SelectedOldViewFile (displayView) into oldViewFile
   put _SelectedOldViewObject (displayView) into viewObject
   --
   put the view_Name of viewObject into moduleStackName
   module_DeleteStacks moduleStackName
   --
   put project_NameToShortFolder (moduleStackName) into moduleFolderName 
   put project_GetModuleFolder (moduleFolderName, projectName) into moduleFolder
   --
   put stack_ConstructNewCloneName (moduleStackName) into tempStackName
   module_Create moduleFolder, tempStackName, pScript
   put the result into resultArray
   --
   copy viewObject to cd 1 of stack tempStackName
   put it into copiedView
   --
   if exists (control 1 of card 2 of stack oldViewFile) then
      put the long id of control 1 of card 2 of stack oldViewFile into bObject
      put the script of bObject into bScript
      put resultArray ["moduleBehaviorStackPath"] into moduleBehaviorStackPath
      --
      lcw_Answer "Do you want to set the behavior script?", displayView
      set the script of stack moduleBehaviorStackPath to bScript
      --
      put the name of stack moduleBehaviorStackPath into newStackBehaviorObject
      set the behavior of copiedView to newStackBehaviorObject
   end if
   --
   delete stack oldViewFile
   set the name of stack tempStackName to moduleStackName
   --
   save stack moduleStackName
   set the stack_IsKnown of stack moduleStackName to true
   --
   display_ModuleTools moduleStackName
   display_ProjectModules projectName
end menu_CreateModule

on _
end _

on menu_CopyView displayView
   put _SelectedOldViewFile (displayView) into oldViewFile
   --
   put the short name of stack oldViewFile into oldName
   delete stack oldName
   --
   put the long id of control 1 of card 1 of stack oldViewFile into viewObject
   copy viewObject
   --
   delete stack oldViewFile
end menu_CopyView

on menu_CopyBehavior displayView
   put _SelectedOldViewFile (displayView) into oldViewFile
   --
   put the short name of stack oldViewFile into oldName
   delete stack oldName
   --
   put the long id of control 1 of card 2 of stack oldViewFile into bObject
   put the script of bObject into bScript
   set the clipboarddata ["text"] to bScript
   delete stack oldViewFile
end menu_CopyBehavior

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_CloseView displayView
   put _SelectedOldViewFile (displayView) into oldViewFile
   if exists (stack oldViewFile) then
      delete stack oldViewFile
   end if
end menu_CloseView
