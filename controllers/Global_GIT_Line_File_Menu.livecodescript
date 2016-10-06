script "Global_GIT_Line_File_Menu"
--> MetaData
-
license: GPLv3
name: Global_GIT_Line_File_Menu
type: controller
version: 0.1


--> Variables
-
local LocalArray


--> Menu | Props
-
on menu_Init tObject
   get the hilited_Element of tObject
   put item 1 of it into LocalArray ["topKey"]
   
   put the display_View of tObject into displayView
   put displayView into LocalArray ["displayView"]
   put the displayed_ScriptObject of displayView into LocalArray ["scriptObject"]
   put the displayed_GitCheckoutFolder of displayView into LocalArray ["gitCheckoutFolder"]
   put the displayed_Array of displayView into LocalArray ["displayedArray"]
end menu_Init

getprop menu_Target [mTiltlePath]
   pass menu_Target
end menu_Target


--> Private
-
private command refresh
   put LocalArray ["displayView"] into displayView
   put LocalArray ["gitCheckoutFolder"] into gitCheckoutFolder
   display_GitFolderStatus gitCheckoutFolder, displayView
end refresh


--> Global | GIT | Line | File | Menu
-
on menu_StageThenCommit arrayView
   put lcw_Ask ("Comment on this change...") into someComment
   put LocalArray ["gitCheckoutFolder"] into gitCheckoutFolder
   
   git_CommitChanges someComment, gitCheckoutFolder
   refresh
end menu_StageThenCommit

on menu_SwitchBranch arrayView
   breakpoint
   refresh
end menu_SwitchBranch

on menu_AddUntrackedFile arrayView
   -- Untracked files:,files,controllers/Global_GIT_Menu.livecodescript,
   put the hilited_Element of arrayView into pathItems
   get item 3 to -1 of pathItems
   put word 1 of it into relativePath
   
   breakpoint
   put LocalArray ["gitCheckoutFolder"] into gitCheckoutFolder
   --  git_AddChanged relativePath, gitCheckoutFolder
   
   put gitCheckoutFolder & relativePath into someFileOrFolder
   git_AddFolder someFileOrFolder -- this will work "cd to folder" then issue "git add ."
   
   refresh
end menu_AddUntrackedFile

on menu_AddAllUntracked arrayView
   put LocalArray ["gitCheckoutFolder"] into gitCheckoutFolder
   set the cursor to watch
   
   breakpoint
   git_AddEverything gitCheckoutFolder  
   put the result into shellResult
   
   if shellResult is not empty then
      lcw_Notify shellResult
   end if
   refresh
end menu_AddAllUntracked

-- on menu_RevertToLastCommit
breakpoint
-- should be "  use "git checkout -- <file>..." to discard changes in working directory)"
--  git_CommitFile someFile, someComment, pAddIfNew, pViewDiff
put the result into shellResult
refresh
end menu_RevertToLastCommit

on menu_ResetToLastCommit
   breakpoint
end menu_ResetToLastCommit

on _
end _

on menu_StashChanges
   breakpoint
end menu_StashChanges

on menu_StageAllChanges
   git_AddChanged
end menu_StageAllChanges

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Global | GIT | Line | File | Menu | Props
-

--> Global | GIT | Line | File | Menu | Disabled
-
getprop disabled_ResetToLastCommit
   if LocalArray ["topKey"] = "Branch" then
      return "delete"
   else
      return false
   end if
end disabled_ResetToLastCommit

getprop disabled_RevertToLastCommit [arrayView]
   put the hilited_Element of arrayView into pathItems
   if LocalArray ["topKey"] = "Branch" or the number of items of pathItems < 3 then
      return "delete"
   else
      return false
   end if
end disabled_RevertToLastCommit

getprop disabled_StageAllChanges
   if LocalArray ["topKey"] = "Changes not staged for commit:" then
      return false
   else
      return "delete"
   end if
end disabled_StageAllChanges

getprop disabled_SwitchBranch [arrayView]
   if LocalArray ["topKey"] = "Branch" then
      return false
   else
      return "delete"
   end if
end disabled_SwitchBranch

getprop disabled_AddAllUntracked [arrayView]
   put the hilited_Element of arrayView into pathItems
   put LocalArray ["topKey"] into topKey
   put the number of items of pathItems into pathNum
   -- if topKey = "Untracked files:" and the number of items of pathItems < 3 then
   if topKey is among the items of "Untracked files:,Changes not staged for commit:" and pathNum <3 then
      return false
   else
      return "delete"
   end if
end disabled_AddAllUntracked

getprop disabled_AddUntrackedFile [arrayView]
   put the hilited_Element of arrayView into pathItems
   
   put LocalArray ["topKey"] into topKey
   put the number of items of pathItems into pathNum
   --  if topKey is among the items of "Untracked files:" and pathNum > 2 then
   if topKey is among the items of "Untracked files:,Changes not staged for commit:" and pathNum > 2 then
      return false
   else
      return "delete"
   end if
end disabled_AddUntrackedFile

getprop disabled_StashChanges
   if LocalArray ["topKey"] = "Changes to be committed:" then
      return false
   else
      return "delete"
   end if
end disabled_StashChanges

getprop disabled_StageThenCommit [arrayView]
   put LocalArray ["displayedArray"] into displayedArray
   put displayedArray ["Changes to be committed:"] into cArray
   put displayedArray ["Changes not staged for commit:"] into nsArray
   union cArray with nsArray
   if cArray is empty then return "delete"
   
   return false
   
   -- not sure of logic yet
   put LocalArray ["topKey"] into topKey
   if topKey = "Branch" or topKey = "Changes to be committed:" then
      return false
   else
      return "delete"
   end if
end disabled_StageThenCommit


--> Dev | Menu
-
on menu_Edit arrayView
   put the behavior of arrayView into bObject
   edit the script of bObject
end menu_Edit

on menu_OpenRevision arrayView
   if asfd then
      git_DisplayTempStackRevision someObject, commitHash
   else
      -- assume it is a text file
      git_ExportFileRevision relativePath, commitHash
      put the result into tempFile
      
      -- edit_TextFile tempFile
      launch document tempFile
   end if
end menu_OpenRevision


