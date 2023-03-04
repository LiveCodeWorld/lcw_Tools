script "Global | Modules | Tree | Menu"
--> MetaData
-
license: GPLv3
name: Global | Modules | Tree | Menu
type: controller
version: 0.1


--> Menu | Props
-
-- getprop checked_AnimationEngine
   put ae_IsActive() into isOn
   return isOn
end checked_AnimationEngine


--> Global | Modules | Tree | Menu
-
on menu_CreateModule indexView
   put the title_Text of indexView into projectName
   
   put "Choose a name for your new module...." into someQuestion
   put the clipboarddata ["text"] into suggestedAnswer
   set the itemdelimiter to "|"
   if item 1 of suggestedAnswer is not "View" then
      put "View|Test" into suggestedAnswer
   end if
   put lcw_Ask (someQuestion, suggestedAnswer) into moduleStackName
   
   put project_GetFolder (projectName) into projectFolder
   put folder_AddShort (projectFolder, "modules") into rootModuleFolder
   --
   project_CreateModule moduleStackName, rootModuleFolder
end menu_CreateModule

on menu_ImportOldView
   put view_ListOldPaths()
end menu_ImportOldView

on menu_ExportModuleMenusAndStackFiles indexView
   put the title_Text of indexView into projectName
   --
   put the view_Index of indexView into moduleNames
   repeat for each line moduleName in moduleNames
      put module_ConstructFolder (moduleName, projectName) into moduleFolder
      if there is a folder moduleFolder then
         project_ExportMenusAndStackFiles moduleFolder
         put the result into moduleProjectArray
      end if
   end repeat
   --
   --
   display_ProjectLibs projectName
   display_GitRefreshProjectName projectName
end menu_ExportModuleMenusAndStackFiles

on _
end _

on menu_Refresh indexView
   put the title_Text of indexView into projectName
   display_ProjectModules projectName, indexView
end menu_Refresh

on menu_RevealModulesFolder indexView
   put the title_Text of indexView into projectName
   put project_GetFolder (projectName) into projectFolder
   put folder_AddShort (projectFolder, "modules") into rootModuleFolder
   --
   finder_Reveal rootModuleFolder  
end menu_RevealModulesFolder

on menu_CheckModules indexView
   put the title_Text of indexView into projectName
   put the view_Index of indexView into moduleNames
   
   repeat for each line moduleName in moduleNames
      put the long id of control 1 of cd 1 of stack moduleName into templateView
      dispatch "view_FixBehavior" to templateView with templateView
      go to stack moduleName
   end repeat
end menu_CheckModules
