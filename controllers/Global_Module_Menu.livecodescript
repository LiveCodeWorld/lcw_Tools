script "Global_Module_Menu"
--> MetaData
-
license: GPLv3
name: Global_Module_Menu
type: controller
version: 0.2


--> Global | Module | Menu
-
on menu_EditMenu viewOrStack, menuStackName
   edit the script of stack menuStackName
end menu_EditMenu

on menu_CreateModuleMenu viewOrStack
   breakpoint
   put the project_Name of viewOrStack into moduleStackName
   put _askMenuTitle (moduleStackName) into moduleStackName
   
   put the module_Folder of viewOrStack into moduleFolder
   module_CreateController moduleStackName, moduleFolder
   put the result into moduleControllerStackPath
   edit the script of stack moduleControllerStackPath
end menu_CreateModuleMenu

on _
end _

on menu_RevealModuleFolder viewOrStack
   put the module_Folder of viewOrStack into moduleFolder
   finder_Reveal moduleFolder
end menu_RevealModuleFolder


--> Global | Module | Menu | Props
-
getprop menu_StackNames [someView]
   put the module_Controllers of someView into cObjects
   repeat for each line cObject in cObjects
      put the short name of cObject into cName
      put cName & CR after cNames 
   end repeat
   delete char -1 of cNames
   sort cNames
   return cNames
end menu_StackNames


--> Global | Module | Menu | Disabled
-
getprop disabled_EditMenu [someView]
   put the module_Controllers of someView into cObjects
   return cObjects is empty
end disabled_EditMenu


--> Deps
-
private function _askMenuTitle moduleStackName
   put line 1 of the clipboarddata ["text"] into maybeMenuTitle
   if word -1 of maybeMenuTitle = "Menu" then
      put maybeMenuTitle into suggestedAnswer
   else
      set the itemdelimiter to "_"
      put "Global |" && item -1 of moduleStackName && "| Menu" into suggestedAnswer
   end if
   
   put "What is the name of your global menu...." into someQuestion
   put lcw_Ask (someQuestion, suggestedAnswer) into gMenuTitle
   put module_FolderNameFromTitle (gMenuTitle) into moduleStackName
   return moduleStackName
end _askMenuTitle
