﻿script "Global | View | Assets | Menu"
--> MetaData
-
license: GPLv3
name: Global | View | Assets | Menu
type: controller
version: 0.1

/*
Here you can describe this menu.
Full help text should be provided on the linked wiki.
*/

--> Variables
-
local LocalArray
local LocalWatchName = "watch assets"

--> Menu | Init
-
getprop menu_CheckTarget [browserView]
   -- get's called too many times
   if exists (browserView) is false then
      -- here we should be able to override mTarget
      return false
   else
      put the project_ShortHtmlFiles of browserView into shortFiles
      put shortFiles into LocalArray ["project_ShortHtmlFiles"]
      return true
   end if
end menu_CheckTarget


--> Events | Watch
-
command watch_FileChanged someFile, watchName
   set the itemdelimiter to slash
   put item -1 of someFile into shortFile
   put merge ("File [['shortFile']] has changed!") into someMessage
   
   display_SlideShow someFile
   lcw_Notify someMessage
end watch_FileChanged


--> Menu | Props
-
getprop watch_Files [browserView]
   put watch_GetActive (LocalWatchName) into isActive
   return isActive
end watch_Files

getprop short_Files [browserView]
   put LocalArray ["project_ShortHtmlFiles"] into shortFiles
   return shortFiles
end short_Files


--> Global | Assets | Menu | Disabled
-
getprop disabled_EditHtml
   put LocalArray ["project_ShortHtmlFiles"] into shortFiles
   return shortFiles is empty
end disabled_EditHtml

getprop disabled_StopWatchingEverything
   put LocalArray ["project_ShortHtmlFiles"] into shortFiles
   return shortFiles is empty
end disabled_StopWatchingEverything

getprop disabled_WatchFile
   put LocalArray ["project_ShortHtmlFiles"] into shortFiles
   return shortFiles is empty
end disabled_WatchFile

getprop disabled_WatchFile
   put LocalArray ["project_ShortHtmlFiles"] into shortFiles
   return shortFiles is empty
end disabled_WatchFile

getprop disabled_DisplayLocalFile
   put LocalArray ["project_ShortHtmlFiles"] into shortFiles
   return shortFiles is empty
end disabled_DisplayLocalFile

getprop disabled_DisplayHtmlText
   put LocalArray ["project_ShortHtmlFiles"] into shortFiles
   return shortFiles is empty
end disabled_DisplayHtmlText

getprop disabled_DisplayInBrowser
   put LocalArray ["project_ShortHtmlFiles"] into shortFiles
   return shortFiles is empty
end disabled_DisplayInBrowser


--> Global | View | Assets | Menu
-
on menu_EditHtml browserView, shortHtmlFile
   put the project_HtmlFile [shortHtmlFile] of browserView into localFile
   atom_DisplayFile localFile
end menu_EditHtml

private on _
end _

on menu_StopWatchingEverything
   watch_Stop
end menu_StopWatchingEverything

on menu_WatchFile browserView, shortHtmlFile
   put the project_HtmlFile [shortHtmlFile] of browserView into localFile
   put watch_ListShortWatchFiles (LocalWatchName) into shortWatchFiles
   
   if shortHtmlFile is among the lines of shortWatchFiles then
      watch_StopWatchingFile localFile, LocalWatchName
   else
      watch_Files localFile, LocalWatchName
   end if
end menu_WatchFile

getprop watchFile_Params
   put LocalArray ["project_ShortHtmlFiles"] into shortFiles
   return shortFiles
end watchFile_Params

getprop watchFile_Param
   put watch_ListShortWatchFiles (LocalWatchName) into shortWatchFiles
   return shortWatchFiles
end watchFile_Param

on menu_WatchFiles browserView, someBoolean
   if someBoolean is false then
      watch_Stop LocalWatchName
   else
      put the project_HtmlFiles of browserView into filesToWatch
      watch_Files filesToWatch, LocalWatchName
   end if
end menu_WatchFiles

getprop disabled_WatchFiles
   put LocalArray ["project_ShortHtmlFiles"] into shortFiles
   return shortFiles is empty
end disabled_WatchFiles

private on __
end __

on menu_DisplayLocalFile browserView, shortHtmlFile
   put the project_HtmlFile [shortHtmlFile] of browserView into localFile
   set the url of browserView to localFile
end menu_DisplayLocalFile

on menu_DisplayHtmlText browserView, shortHtmlFile
   put the project_Html [shortHtmlFile] of browserView into someHTML
   set the htmltext of browserView to someHTML
end menu_DisplayHtmlText

on menu_DisplayInBrowser browserView, shortHtmlFile
   put the project_HtmlFile [shortHtmlFile] of browserView into localFile
   launch url ("file:///" & localFile)
end menu_DisplayInBrowser

private on ___
end ___

on menu_CreateHtmlFile browserView
   put lcw_Ask ("What file name would you like for the new HTML file?", "xxx.html") into shortHtmlFile
   put the project_HtmlFile [shortHtmlFile] of browserView into localFile
   if there is a file localFile then
      display_Text localFile
      answer warning merge ("There is already a file named '[[shortHtmlFile]]' in the modules asset folder! Do you want to overwrite it?") with "Yes" or "Cancel"
      if it is "Cancel" then exit to top
   end if
   
   put the clipboarddata ["text"] into maybeText
   put maybeText into url ("file:" & localFile)
   atom_DisplayFile localFile
end menu_CreateHtmlFile

private on ____
end ____

on menu_ModuleAssetFolder browserView
   put the module_AssetFolder of browserView into assetFolder
   finder_Reveal assetFolder
end menu_ModuleAssetFolder

on menu_ProjectAssetFolder browserView
   put the project_AssetFolder of browserView into assetFolder
   finder_Reveal assetFolder
end menu_ProjectAssetFolder
