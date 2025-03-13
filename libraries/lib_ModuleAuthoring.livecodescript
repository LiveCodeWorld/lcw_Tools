script "lib_ModuleAuthoring"
--> MetaData
-
license: GPLv3
name: lib_ModuleAuthoring
type: library
version: 0.4


--> Working on
-
command stack_Remove stackPaths
   repeat for each line stackPath in stackPaths
      if exists (stack stackPath) then
         delete stack stackPath
         put stackPath & CR into removedStackPaths
      end if
   end repeat
   delete char -1 of removedStackPaths
   return removedStackPaths
end stack_Remove

command module_RenameBehavior stackPath, newBehaviorName
   if exists (stack stackPath) is false then return "Error, behavior does exist:" && stackPath
   
   put the name of stack stackPath into oldScriptObject
   scriptEditor_CloseTab oldScriptObject
   --
   set the script_Name of stack stackPath to newBehaviorName
   set the name of stack stackPath to newBehaviorName
   save stack stackPath
   --
   return newBehaviorName
end module_RenameBehavior

setprop module_AddBehavior vName
   put the long id of the target into tObject
   --
   put the module_Behaviors of tObject into moduleBehaviors
   --
   put view_GetTemplateBehavior (vName) into bObject
   line_Add bObject, moduleBehaviors
   --
   set the behavior_Objects of tObject to moduleBehaviors
   return moduleBehaviors
end module_AddBehavior

command module_Trash moduleName   
   ## Get moduleFolder before closing
   put the module_Folder of stack moduleName into moduleFolder
   put the project_Folder of stack moduleName into projectFolder
   
   ## Close and rremove from memory
   module_RemoveFromMemory moduleName, projectFolder
   
   ## Move folder
   revDeleteFolder moduleFolder
   --
   return the result
end module_Trash


--> Module | Metadata
-
setprop module_ViewMetaData [setNameAndBehaviors] viewName
   put the long id of the target into viewObject
   
   ## Set Script Metadata (and uRIP)
   put metadata_ConstructArray (viewName, "view") into uripArray
   set the script_MetaData of viewObject to uRipArray
   put the result into uRipArray
   
   if setNameAndBehaviors is true then
      ## Set the Name
      set the name of viewObject to viewName
      
      ## Set Behaviors   
      put the module_Behaviors of viewObject into moduleBehaviors
      set the behavior_Objects of viewObject to moduleBehaviors
   end if
   return viewObject
end module_ViewMetaData

command module_TrashStack stackName
   put the filename of stack stackName into stackPath
   --
   put the module_HomeStack of stack stackName into moduleHomeStack
   put the project_HomeStack of stack stackName into projectHomeStack
   --
   stack_Remove stackPath
   revDeleteFile stackPath
   --
   set the stack_IsKnown of moduleHomeStack to false
   set the stack_IsKnown of projectHomeStack to false
   return stackPath
end module_TrashStack

command module_RemoveFromMemory moduleName, pProjectFolder
   if there is a folder pProjectFolder then
      put the module_StackPaths of stack moduleName into stackPaths
   else
      put module_ListStackPaths (moduleName, pProjectFolder) into moduleStackPaths
   end if
   stack_Remove stackPaths
   return the result
end module_RemoveFromMemory

command module_Move oldModuleName, newProjectName
   set the cursor to watch
   put the project_Folder of stack oldModuleName into oldProjectFolder
   put the module_Folder of stack oldModuleName into oldModuleFolder
   put the project_Name of stack oldModuleName into oldProjectName
   
   set the itemdelimiter to slash
   put item -1 of oldModuleFolder into oldModuleShortFolder
   --
   put library_FetchProjectFolder (newProjectName) into newProjectFolder
   put module_GetFolder (oldModuleShortFolder, newProjectFolder) into newModuleFolder
   
   ## Remove from memory
   -- module_RemoveFromMemory oldModuleName, oldProjectFolder
   put directory_ListNestedPaths (oldModuleFolder) into oldModuleStackPaths
   stack_Remove oldModuleStackPaths
   
   ## Move folder
   revMoveFolder oldModuleFolder, newModuleFolder
   
   if the shiftKey is "Up" then
      ## Re-index and re-load
      project_ExportMenusAndStackFiles oldProjectFolder
      project_ExportMenusAndStackFiles newProjectFolder
   end if
   
   ## Refresh index views
   display_Project oldProjectName
   display_Project newProjectName   
   
   -- display_ProjectModules oldProjectName
   -- display_ProjectModules newProjectName   
end module_Move

command module_CreateWithObject moduleName, pProjectName, pObject, pDisplayView
   -- not implemented "pObject" yet
   -- defaults to creating a module in the "lcw_Forms" project
   if pProjectName is empty then put "lcw_Forms" into pProjectName
   put module_ConstructFolder (moduleName, pProjectName) into moduleFolder
   
   put view_GetTemplateObject (moduleName) into moduleTemplate
   if exists (moduleTemplate) then
      lcw_AnswerWarning  "A view or module called '[[moduleName]]' already exists!", pDisplayView, moduleName
   end if
   
   ## Copy
   put exists (pObject) into objectExists
   if objectExists then
      put the behavior of pObject into bObject
      if exists (bObject) is false then
         put bObject
         breakpoint
         put empty into oScript
      else
         put the script of bObject into oScript
      end if
      put the view_Name of pObject into oldViewName
      --
      put the stack_Name of pObject into oStackName
      put the rect of stack oStackName into oRect
      --
      copy pObject
   end if
   
   ## Create Fresh Module
   module_Create moduleFolder, moduleName
   put the result into resultArray
   put resultArray ["moduleHomeStackPath"] into moduleHomeStackPath
   put resultArray ["moduleBehaviorStackPath"] into moduleBehaviorStackPath
   put resultArray ["moduleControllerStackPath"] into moduleControllerStackPath
   
   ## Exit if nothing copied
   if objectExists is false then
      save stack moduleName
      return resultArray
   end if
   
   ## Set stack rect
   set the rect of stack moduleHomeStackPath to oRect
   
   ## Go and Paste
   go to stack moduleName
   paste
   -- copy pObject to cd 1 of stack moduleHomeStackPath
   put it into copiedView
   
   ## Rename and Reset view_Name
   set the module_ViewMetaData [true] of copiedView to moduleName
   
   ## Copy script and replace default of new module
   if exists (pObject) then
      put project_DefaultBehaviorName (moduleName) into bStackName
      if oScript is not empty then
         put metadata_ConstructArray (bStackName, "behavior") into uRipArray
         script_SetMetadataArray oScript, uRipArray
         set the script of stack moduleBehaviorStackPath to oScript
      end if
      save stack moduleBehaviorStackPath
   end if
   
   ## Move main menu if it exists
   put menu_GlobalTitleFromViewName (oldViewName) into oldMenuTitle
   put menu_GetGlobalController (oldMenuTitle) into oldController
   if exists (oldController) then
      put the script of oldController into oldMenuScript
      --
      put metadata_ConstructArray (moduleName, "controller") into uRipArray
      script_SetMetadataArray oldMenuScript, uRipArray
      set the script of stack moduleControllerStackPath to oldMenuScript
      save stack moduleControllerStackPath
   end if
   
   save stack moduleName
   --
   put the project_Name of stack moduleName into projectName
   display_Project projectName
   display_ModuleFromStackName moduleName
   display_ModuleTools moduleName, true
   --
   lcw_AnswerWarning "May not have moved all menus or behaviors!"
   return resultArray
end module_CreateWithObject


--> To Trash?
-
command module_MoveController moduleStackName, moduleFolder
   put module_ConstructGlobalMenuTitle (moduleStackName) into globalMenuTitle
   put menu_GetGlobalController (globalMenuTitle) into mController
   
   if exists (mController) then
      if word 1 of mController = "stack" then
         put the filename of mController into oldControllerStackPath
         set the itemdelimiter to slash
         put item -1 of oldControllerStackPath into pShortFile
         put module_ConstructControllerPath (moduleStackName, moduleFolder, pShortFile) into newModuleBehaviorStackPath
         project_MoveStack oldControllerStackPath, newModuleBehaviorStackPath
         return newModuleBehaviorStackPath
      else
         answer warning "Menu controller is not a stack.  Please move manually?"
         edit the script of mController
         breakpoint
         return empty
      end if
   else
      module_CreateMenuFromFolder moduleFolder -- ,moduleStackName
      put the result into newModuleBehaviorStackPath
      return newModuleBehaviorStackPath
   end if
end module_MoveController

function module_ConstructControllerPath moduleName, moduleFolder, pShortFile
   breakpoint
   if pShortFile is empty then
      put moduleName & ".livecodescript" into pShortFile
   end if
   put folder_AddShort (moduleFolder, "controllers") into moduleControllerFolder
   put pShortFile & pShortFile into moduleControllerPath
   return moduleControllerPath
end module_ConstructControllerPath


--> Module | Move
-
command module_MoveRenameBehavior oldBehaviorStackPath, newBehaviorName, pModuleFolder
   set the itemdelimiter to slash
   put item -1 of oldBehaviorStackPath into shortFile
   if pModuleFolder is empty then
      put the module_Folder of stack oldBehaviorStackPath into pModuleFolder
   end if
   --
   put newBehaviorName & ".livecodescript" into newShortBehaviorFile
   put pModuleFolder & "behaviors/" into moduleBehaviorFolder
   if there is not a folder moduleBehaviorFolder then 
      return merge ("Error, behavior folder '[[moduleBehaviorFolder]]' does not exist!")
   end if
   
   put moduleBehaviorFolder & newShortBehaviorFile into newBehaviorStackPath
   -- put project_DefaultBehaviorName (newBehaviorName) into newModuleStackName
   -- put module_ConstructBehaviorPath (newBehaviorName, pModuleFolder) into newBehaviorStackPath
   --
   breakpoint
   module_RenameBehavior oldBehaviorStackPath, newBehaviorName
   project_MoveStack oldBehaviorStackPath, newBehaviorStackPath
   --
   get the result
   return newBehaviorStackPath
end module_MoveRenameBehavior

function module_GetHomePath moduleName, pProjectName
   if pProjectName is empty then
      put lcw_PipesToUnderscore (moduleName) into moduleFolderName
      put env_GetModuleHomePath (moduleFolderName) into homeStackPath
   else
      put project_GetFolder (pProjectName) into projectFolder
      if projectFolder is empty then return empty
      put module_ConstructHomeStackPath (moduleName, projectFolder) into homeStackPath
   end if
   
   # Return if it exists
   if exists (stack homeStackPath) then
      return homeStackPath
   else
      return empty
   end if
end module_GetHomePath

command module_Create moduleFolder, moduleStackName, pScript
   _StackAlreadyExists moduleStackName
   --
   module_DeleteStacks moduleStackName
   --
   project_CreateHomeStack moduleFolder, moduleStackName, pScript
   put the result into resultArray ["moduleHomeStackPath"]
   --
   module_SetCardBehavior moduleStackName
   --
   project_CreateStandardFolders moduleFolder, "behaviors,controllers"
   --
   module_CreateBehavior moduleFolder
   put the result into resultArray ["moduleBehaviorStackPath"]
   --
   module_CreateMenuFromFolder moduleFolder
   put the result into resultArray ["moduleControllerStackPath"]
   --
   return resultArray
   --
   put resultArray ["moduleHomeStackPath"] into moduleHomeStackPath
   put resultArray ["moduleBehaviorStackPath"] into moduleBehaviorStackPath
   put resultArray ["moduleControllerStackPath"] into moduleControllerStackPath
end module_Create

command module_DeleteStacks moduleStackName
   if exists (stack moduleStackName) then delete stack moduleStackName
   --
   put module_ConstructGlobalMenuTitle (moduleStackName) into gMenuTitle
   if exists (stack gMenuTitle) then delete stack gMenuTitle
   --
   put project_DefaultBehaviorName (moduleStackName) into bStackName
   if exists (stack bStackName) then delete stack bStackName
end module_DeleteStacks

command module_UpdateToolsMenu moduleStackName
   set the itemdelimiter to slash
   put item -1 of moduleFolder into moduleFolder
   put display_FindView ("Module Tools", moduleStackName) into displayView
   if exists (displayView) is false then return false
   --
   put the displayed_Object of displayView into viewObject
   --  put the displayed_ModuleFolder of displayView into moduleFolder
   --
   put view_ConstructToolMenu (viewObject) into mTitles
   set the title_Menu of displayView to mTitles
end module_UpdateToolsMenu

command module_CreateBehavior moduleFolder, pBehaviorStackName, pBehaviorScript
   if pBehaviorStackName is empty then
      set the itemdelimiter to slash
      put item -1 of moduleFolder into shortFolderName
      put project_DefaultBehaviorName (shortFolderName) into pBehaviorStackName
   end if
   if pBehaviorScript is empty then
      put module_ConstructBehaviorScript (pBehaviorStackName) into pBehaviorScript
   end if
   --
   project_CreateStack moduleFolder, pBehaviorStackName, "behaviors", "behavior", pBehaviorScript
   put the result into moduleBehaviorStackPath
   return moduleBehaviorStackPath
end module_CreateBehavior

function module_ConstructBehaviorScript bName
   put scaffold_Get ("View Behavior Template") into tScript
   put lcw_GetAuthor() into authorName
   put merge (tScript) into behaviorScript
   return behaviorScript
end module_ConstructBehaviorScript


--> Module | Behavior
-
command module_MoveBehavior moduleStackName, shortFolderName, moduleFolder
   put view_GetTemplateObject (moduleStackName) into templateView
   if exists (templateView) is false then
      answer warning "Cannot locate view!"
      breakpoint
      return empty
   end if
   
   put the behavior of templateView into bObject
   if exists (bObject) is false then
      answer "There is no behavior for this view. Would you like to create one?" with "Create" and "No"
      if it is "Create" then
         breakpoint
         module_CreateBehavior moduleFolder
         put the result into moduleBehaviorStackPath
         
         edit the script of stack moduleBehaviorStackPath
         breakpoint
         return moduleBehaviorStackPath
      else
         return empty
      end if
   end if
   
   if word 1 of bObject is "stack" then
      put the filename of bObject into oldBehaviorStackPath 
      module_MoveRenameBehavior oldBehaviorStackPath, moduleStackName, moduleFolder
      return moduleBehaviorStackPath
   else
      answer warning "Behavior is not a stack. Move manually!"
      put the script of bObject into bScript
      module_CreateBehavior moduleFolder, empty, bScript
      put the result into moduleBehaviorStackPath
      
      put the module_Behaviors of templateView into moduleBehaviors
      set the behavior_Objects of templateView to moduleBehaviors
      
      answer warning "Check new module behavior scriptonly stack. Then remove old button behavior?"
      edit the script of bObject
      edit the script of stack moduleBehaviorStackPath
      return moduleBehaviorStackPath
   end if
end module_MoveBehavior

command module_SetCardBehavior moduleStackName
   -- lets name the views card for convenience
   put moduleStackName into shortViewName
   set the itemdelimiter to "|"
   if item 1 of shortViewName = "View" then delete item 1 of shortViewName
   set the name of card 1 of stack moduleStackName to shortViewName
   
   put the long id of stack "behavior_ViewTemplateCard" into cardViewBehavior
   set the behavior of card 1 of stack moduleStackName to cardViewBehavior
end module_SetCardBehavior


--> Module | Menu
-
/*
A lcw controller is also know less formally as a "menu".
*/

command module_ReIndexMenus templateView
   local moduleMenuTitleArray
   put the module_Controllers of templateView into menuStackObjects
   repeat for each line menuStackObject in menuStackObjects
      set the menu_Update of menuStackObject to true -- false
      put the result into mTitleArray
      union moduleMenuTitleArray with mTitleArray recursively
   end repeat
   return moduleMenuTitleArray
end module_ReIndexMenus


--> Project
-
command project_CreateModule moduleStackName, rootModuleFolder, pViewStackPath, pScript
   text_AddTrailing rootModuleFolder, slash
   if there is not a folder rootModuleFolder then
      answer warning "Modules folder does not exist!"
      breakpoint
      put rootModuleFolder
      exit to top
   end if
   
   put lcw_PipesToUnderscore (moduleStackName) into shortFolderName
   put rootModuleFolder & shortFolderName & slash into moduleFolder
   
   switch
      case exists (stack pViewStackPath)
         -- let's move everything
         breakpoint
         put project_ConstructStandardFile (moduleStackName, rootModuleFolder, shortFolderName, "livecode") into moduleHomeStackPath
         
         folder_CreateNested moduleFolder
         project_MoveStack pViewStackPath, moduleHomeStackPath
         
         project_CreateStandardFolders moduleFolder, "behaviors,controllers"
         module_SetCardBehavior moduleStackName
         module_MoveBehavior moduleStackName, shortFolderName, moduleFolder
         put the result into moduleBehaviorStackPath
         module_MoveController moduleStackName, moduleFolder
         put the result into moduleControllerStackPath
         break
      case pViewStackPath is not empty
         put pViewStackPath
         answer warning "Cannot locate view stack!"
         breakpoint
         exit to top
         break
      default
         module_Create moduleFolder, moduleStackName, pScript
         put the result into resultArray
         put resultArray ["moduleControllerStackPath"] into moduleControllerStackPath
         put resultArray ["moduleHomeStackPath"] into moduleHomeStackPath
         put resultArray ["moduleBehaviorStackPath"] into moduleBehaviorStackPath
   end switch
   
   edit the script of stack moduleHomeStackPath
   edit the script of stack moduleBehaviorStackPath
   edit the script of stack moduleControllerStackPath
end project_CreateModule

command project_CreateView viewName, pViewFilePath
   _StackAlreadyExists viewName
   -- project_CreateStack projectName, stackName, "modules"
   
   -- create the stack and set the basics
   create stack viewName
   set the destroystack of stack viewName to true
   set the destroywindow of stack viewName to true
   
   module_SetCardBehavior viewName
   
   put the width of viewTemplate into sWidth
   put the height of viewTemplate into sHeight
   stack_SetDimensions templateStackObject, sWidth, sHeight
   
   if pViewFilePath is not empty then
      set the fileName of stack viewName to pViewFilePath
      save stack viewName
      set the stack_IsKnown of stack viewName to true
   end if
end project_CreateView


--> Private
-
private command _StackAlreadyExists viewName, pDontExit
switch
   case there is a stack viewName
   case viewName is among the lines of env_ListViewStackNames()
      put "There is already a view template stack" && kwote (viewName) & "!" into someComment
      answer warning someComment
      show stack viewName
      go to stack viewName
      if pDontExit is true then
         return true
      else
         exit to top
      end if
   default
      return false
end switch
end _StackAlreadyExists
