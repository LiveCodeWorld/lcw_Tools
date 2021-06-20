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
on mDouble_DisplayModule indexView, moduleName
   put the title_Text of indexView into projectName
   --
   if projectName is "Modules" then
      -- Environment
      put module_FindFolder (moduleName) into moduleFolder
   else
      put module_ViewNameToShortFolder (moduleName) into moduleFolderName
      put project_GetModuleFolder (moduleFolderName, projectName) into moduleFolder
   end if
   --
   display_Module moduleFolder
end mDouble_DisplayModule

on mDouble_EditProp indexView, hName
   put the displayed_Object of indexView into viewObject
   put the behavior of viewObject into viewBehavior
   
   -- put revRuggedID (hObject) into hObject
   put "G" && hName into shortHkeyLine
   put hKeyLine_AddObject (shortHkeyLine, viewBehavior) into hkeyLine
   
   hkey_Edit hkeyLine
end mDouble_EditProp


--> Display | Modules
-
command display_ListModules pProjectNames
   put env_ListModuleNames (pProjectNames) into moduleNames
   --
   display_Data moduleNames, "Modules", "Environment"
   put the result into displayView
   --
   display_SetInteractions displayView, "Module | List", "mDouble_DisplayModule"
   -- set the env_ModuleArray of displayView to adfs
   --
   return displayView
end display_ListModules


--> Display | Module
-
command display_ModuleFromName moduleName, projectName
   put module_ConstructFolder (moduleName, projectName) into moduleFolder
   display_Module moduleFolder
end display_ModuleFromName

command display_Module moduleFolder
   put project_ConstructHomeStackPath (moduleFolder) into moduleHomeStackPath
   if moduleHomeStackPath is empty then
      put moduleFolder
      answer warning "Cannnot locate a module in this folder!"
      exit to top
   end if
   
   put project_GetHomeStackName (moduleFolder) into moduleName
   go to stack moduleHomeStackPath
   --
   display_ModuleTools moduleName, false
   --
   return the result
end display_Module

command display_ModuleTools stackName, pEditScripts
   if exists (control 1 of cd 1 of stack stackName) is true then
      put the long id of control 1 of cd 1 of stack stackName into viewObject   
      put the view_Props of viewObject into viewProps
      put view_ConstructToolMenu (viewObject, true) into mTitles
   else
      put empty into viewObject
      put "View does not exist!" into viewProps
      put empty into mTitles
   end if
   
   put the module_Folder of stack stackName into moduleFolder
   put the original_ModuleName of stack stackName into moduleName
   if moduleName is empty then put stackName into moduleName
   -- 
   display_Data viewProps, stackName, "Module Tools"
   put the result into displayView
   --
   set the itemdelimiter to tab
   put item 1 of line 1 of mTitles into mTitle
   if menu_GlobalControllerExists (mTitle) is false then
      put "Global | Module | Tree | Menu" into line 1 of mTitles
      display_SetInteractions displayView, "Module | Tree", "mDouble_EditProp"
   else
      set the title_Menu of displayView to mTitles
      set the line_Menu of displayView to "Global | Module | Tree | Line | Menu"
      set the mouse_DoubleUp of displayView to "mDouble_EditProp"
   end if
   --
   set the multiple_Hilites of displayView to false
   
   set the itemdelimiter to slash
   put item 1 to -3 of moduleFolder & slash into projectFolder
   put project_GetHomeStackName (projectFolder) into projectName
   --
   -- set the displayed_ViewObject of displayView to viewObject
   set the displayed_Object of displayView to viewObject
   set the displayed_ModuleFolder of displayView to moduleFolder
   set the displayed_ModuleName of displayView to moduleName
   set the displayed_ProjectName of displayView to projectName
   set the displayed_ProjectFolder of displayView to projectFolder
   --
   if pEditScripts is true then
      put the script of cd 1 of stack moduleName into cardScript
      if cardScript is not empty then
         edit the script of cd 1 of stack moduleName
      end if
      display_ModuleToolScripts moduleName, projectName
   end if
   return displayView
end display_ModuleTools


--> Display | Project | Modules
-
command display_ProjectModules projectName
   put project_ListModules (projectName) into moduleStackNames
   --
   display_Data moduleStackNames, projectName, "Modules"
   put the result into displayView
   --
   display_SetInteractions displayView, "Modules | Tree", "mDouble_DisplayModule"
   --
   put env_ConstructProjectFolder (projectName) into pProjectFolder
   --
   set the displayed_ProjectFolder of displayView to projectFolder
   set the displayed_ProjectName of displayView to projectName
   return displayView
end display_ProjectModules

command display_ModuleToolScripts moduleName, projectName
   -- put library_FetchProjectFolder (projectName) into projectFolder
   put env_ConstructProjectFolder (projectName) into projectFolder
   --
   put module_ListBehaviorStackNames (moduleName, projectFolder) into behaviorStackNames
   repeat for each line behaviorStackName in behaviorStackNames
      edit the script of stack behaviorStackName
   end repeat
   put module_ListControllerStackNames (moduleName, projectFolder) into controllerStackNames
   repeat for each line controllerStackName in controllerStackNames
      edit the script of stack controllerStackName
   end repeat
end display_ModuleToolScripts
