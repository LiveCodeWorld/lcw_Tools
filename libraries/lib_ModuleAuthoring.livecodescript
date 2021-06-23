script "lib_ModuleAuthoring"
--> MetaData
-
license: GPLv3
name: lib_ModuleAuthoring
type: library
version: 0.3


--> Working on
-
on mDoubleUp_OldView displayView, shortFile
   -- put the selected_Line of displayView into shortFile
   put view_OldFolder() & shortFile into oldViewFile
   --
   put the short name of stack oldViewFile into oldName
   delete stack oldName
   --
   go to stack oldViewFile
end mDoubleUp_OldView

command display_OldViewFiles
   put view_ListOldShortPaths() into oldViewShortFiles
   --
   display_Data oldViewShortFiles, "Old Views", "Revolution"
   put the result into displayView
   display_SetInteractions displayView, "View | Old", "mDoubleUp_OldView"
   return displayView
end display_OldViewFiles

function view_ListOldShortPaths
   put view_OldFolder() into oldViewFolder
   put files (oldViewFolder) into oldViewShortFiles
   sort lines of oldViewShortFiles
   return oldViewShortFiles
end view_ListOldShortPaths

function view_ListOldPaths
   put view_OldFolder() into oldViewFolder
   put file_ListLong (oldViewFolder) into oldViewFiles
   return oldViewFiles
end view_ListOldPaths

function view_OldFolder
   put the documents folder into oldViewFolder
   put "/My Revolution Enterprise/Plugins/opn_Plugins/opn_Components/views/" after oldViewFolder
   return oldViewFolder
end view_OldFolder

command module_CreateWithObject moduleName, pProjectName, pObject, pDisplayView
   -- not implemented "pObject" yeet
   -- defaults to creating a module in the "lcw_Forms" project
   if pProjectName is empty then put "lcw_Forms" into pProjectName
   
   put view_GetTemplateObject (moduleName) into rowTemplate
   if exists (rowTemplate) then
      lcw_AnswerWarning  "A view or module called '[[moduleName]]' already exists!", pDisplayView, moduleName
   end if
   --
   put module_ConstructFolder (moduleName, pProjectName) into moduleFolder
   module_Create moduleFolder, moduleName
   put the result into resultArray
   --
   go to stack moduleName
   save stack moduleName
   display_ModuleTools moduleName, true
   --
   return resultArray
   --
   put resultArray ["moduleHomeStackPath"] into moduleHomeStackPath
   put resultArray ["moduleBehaviorStackPath"] into moduleBehaviorStackPath
   put resultArray ["moduleControllerStackPath"] into moduleControllerStackPath
end module_CreateWithObject

command project_CreateModule moduleStackName, rootModuleFolder, pViewStackPath, pScript
   text_AddTrailing rootModuleFolder, slash
   if there is not a folder rootModuleFolder then
      answer warning "Modules folder does not exist!"
      breakpoint
      put rootModuleFolder
      exit to top
   end if
   
   put project_NameToShortFolder (moduleStackName) into shortFolderName
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

command module_Create moduleFolder, moduleStackName, pScript
   template_StackAlreadyExists moduleStackName
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
   module_CreateMenu moduleFolder
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

command module_CreateMenu moduleFolder, pGlobalMenuTitle
   set the itemdelimiter to slash
   put item -1 of moduleFolder into shortFolder
   put shortFolder into moduleStackName
   --
   if pGlobalMenuTitle is empty then
      put module_ConstructGlobalMenuTitle (moduleStackName, true) into gMenuTitle
   else
      put pGlobalMenuTitle into gMenuTitle
   end if
   put controller_ConstructMenuScript (gMenuTitle) into controllerScript
   --
   project_CreateMenu moduleFolder, gMenuTitle, controllerScript
   put the result into controllerStackObject
   --
   module_UpdateToolsMenu moduleStackName
   --
   return controllerStackObject
end module_CreateMenu

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
   if pBehaviorScript is emppty then
      put module_ConstructBehaviorScript (pBehaviorStackName) into pBehaviorScript
   end if
   --
   project_CreateStack moduleFolder, pBehaviorStackName, "behaviors", "behavior", pBehaviorScript
   put the result into moduleBehaviorStackPath
   return moduleBehaviorStackPath
end module_CreateBehavior

function module_ConstructBehaviorScript bName
   put scaffold_GetTemplate ("View Behavior Template") into tScript
   put lcw_GetAuthor() into authorName
   put merge (tScript) into behaviorScript
   return behaviorScript
end module_ConstructBehaviorScript

function controller_ConstructMenuScript mTitle
   put scaffold_GetTemplate ("Global Menu Template") into menuScriptTemplate
   put mTitle into controllerName
   put lcw_GetAuthor() into authorName
   put merge (menuScriptTemplate) into controllerScript
   return controllerScript
end controller_ConstructMenuScript

function module_ConstructBehaviorShortFile moduleStackName
   _CleanModuleStackName moduleStackName
   put "behavior_" & moduleStackName & ".livecodescript" into shortFile
   return shortFile
end module_ConstructBehaviorShortFile

function project_DefaultBehaviorName moduleStackName
   _CleanModuleStackName moduleStackName
   replace "_" with empty in moduleStackName
   --
   put "behavior_" & moduleStackName into behaviorStackName
   return behaviorStackName
end project_DefaultBehaviorName

private command _CleanModuleStackName @moduleStackName
   view_NormalizePiped moduleStackName -- just in case
   replace "|" with empty in moduleStackName
end _CleanModuleStackName

function controller_FolderNameFromTitle gMenuTitle
   return gMenuTitle
   
   -- not sure I want to use this any more
   view_NormalizePiped gMenuTitle
   replace "|" with "_" in gMenuTitle
   return gMenuTitle
end controller_FolderNameFromTitle


--> Module | Author
-
function module_ConstructBehaviorPath moduleName, moduleFolder, pShortFile
   if pShortFile is empty then
      put module_ConstructBehaviorShortFile (moduleName) into pShortFile
   end if
   put project_ConstructFolder ("behaviors", moduleFolder) into moduleControllerFolder
   put moduleControllerFolder & pShortFile into moduleControllerPath
   return moduleControllerPath
end module_ConstructBehaviorPath

function module_ConstructControllerPath moduleName, moduleFolder, pShortFile
   breakpoint
   if pShortFile is empty then
      put controller_FolderNameFromTitle (moduleName) & ".livecodescript" into pShortFile
   end if
   put project_ConstructFolder ("controllers", moduleFolder) into moduleControllerFolder
   put pShortFile & pShortFile into moduleControllerPath
   return moduleControllerPath
end module_ConstructControllerPath

function module_GetControllerStackPath controllerStackName, rootModuleFolder
   put controllerStackName & ".livecodescript" into shortControllerPath
   put rootModuleFolder & "controllers/" & shortControllerPath into moduleControllerStackPath
   return moduleControllerStackPath
end module_GetControllerStackPath


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
      set the itemdelimiter to slash
      put item -1 of oldBehaviorStackPath into shortFile
      put module_ConstructBehaviorPath (moduleStackName, moduleFolder, shortFile) into moduleBehaviorStackPath
      project_MoveStack oldBehaviorStackPath, moduleBehaviorStackPath
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

function module_GetBehaviorStackPath behaviorStackName, rootModuleFolder
   put behaviorStackName & ".livecodescript" into shortBehaviorPath
   put rootModuleFolder & "behaviors/" & shortBehaviorPath into moduleBehaviorStackPath
   return moduleBehaviorStackPath
end module_GetBehaviorStackPath

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


--> Module | Create
-
command project_CreateView viewName, pViewFilePath
   template_StackAlreadyExists viewName
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
      module_CreateMenu moduleFolder -- ,moduleStackName
      put the result into newModuleBehaviorStackPath
      return newModuleBehaviorStackPath
   end if
end module_MoveController


--> Private
-
command template_StackAlreadyExists viewName, pDontExit
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
end template_StackAlreadyExists
