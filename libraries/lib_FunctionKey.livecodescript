script "lib_FunctionKey"
--> MetaData
-
license: GPLv3
name: lib_FunctionKey
type: library
version: 0.3

--> Private
-
private command _DraftScriptHelp
   put scriptEditor_Object() into sObject
   if exists (sObject) is false then breakpoint
   --
   draft_ScriptHelp sObject
end _DraftScriptHelp


--> FKey
-
on functionKey keyNumber
   if the optionKey is "Down" then breakpoint
   switch keyNumber
      case 1
         display_Environment
         break
      case 2
         put display_GetHidden() is empty into sBoolean
         display_SetHidden sBoolean
         break
      case 3
         put scriptEditor_Object() into sObject
         if exists (sObject) is false then breakpoint
         --
         display_ScriptDeps sObject, "sfdp"
         --
         draft_ScriptHelp sObject
         break
      case 4
         wikiServer_Toggle
         break
      case 5
         _SearchContext
         break
      case 6
         if the shiftKey is "Down" then
            display_Wiki "myth.garden"
         else
            put platform_LivecodeDomain() into wikiDomain
            display_Wiki wikiDomain
         end if
         break
      case 8
         put line 1 to 3 of stack_OpenIndex() into stackNames
         stack_SetToMainScreen stackNames
         break
      case 9
         display_GitStatus the topStack
         break
      case 10
         -- stack_ToggleShrink
         break
      case 12
         display_NotUpToDate true
         break
      default
         --
   end switch
   pass functionKey
end functionKey


--> Private
-
command _ToggleCameras cameraViews
   -- put camera_ListNames() into cameraViews
   put stack_ListNamedView ("View|Camera") into cameraViews
   if cameraViews is empty then return false
   --
   put line 1 of cameraViews into testView
   put the camera_IsOpen of testView into isOpen
   put isOpen is false into sBoolean
   --
   set the cursor to watch
   repeat for each line cameraView in cameraViews
      if exists (cameraView) is false then next repeat
      --
      set the camera_IsOpen of cameraView to sBoolean
      put cameraView & CR after goodCameraViews
   end repeat
   delete char -1 of goodCameraViews
   --
   return goodCameraViews
end _ToggleCameras

private command _ToggleCameraDecorations
   put stack_FindNames ("View|Camera") into cNames
   stack_ToggleDecorations cNames, empty
end _ToggleCameraDecorations

private command _SearchContext
   switch
      case the short name of the topStack begins with "View|Wiki|Browser"
         put the long id of control 1 of cd 1 of the topStack into wikiView
         --
         put the wiki_Domain of wikiView into wikiDomain
         -- put the lineUp_Info of wikiView
         get the last_PageInfo of wikiView
         put item 1 of it into wikiDomain
         put item 2 of it into pSlug
         --
         put pageArray_FetchText (wikiDomain, pSlug)
         break
      default
         put the name of the topStack into sInfo
         put CR & the defaultStack after sInfo
         --
         put CR & the name of the top_Card of the topStack after sInfo
         put CR after sInfo
         
         put CR & the openstacks after sInfo
         
         put sInfo
   end switch
end _SearchContext

private command _TopCard
   put the top_Card of the topStack into topCard
   if the shiftKey is "Down" then
      _TopCardViewDisplays topCard
   else
      _TopViewDisplays topCard
   end if
end _TopCard

private command _TopCardViewDisplays topCard
   put the view_Objects of topCard into viewObjects
   repeat for each line viewObject in viewObjects
      display_ViewIndex viewObject
   end repeat
end _TopCardViewDisplays

private command _TopViewDisplays topCard
   put the top_ViewObjects of topCard into topViewObjects
   put the loc of the defaultstack into oLoc
   repeat for each line viewObject in topViewObjects
      -- display_NestedViewArray viewObject
      
      display_ViewIndex viewObject
      put the result into indexView
      put the stack_Object of indexView into stackObject
      set the loc of stackObject to oLoc
      
      display_ViewBehaviors viewObject
      put the result into indexView
      put the stack_Object of indexView into stackObject
      set the loc of stackObject to oLoc
   end repeat
end _TopViewDisplays

private command _DisplayBrokenBehaviors
   put the top_ViewObjects of topCard into topViewObjects
   repeat for each line viewObject in topViewObjects
      display_BrokenBehaviors viewObject, true
   end repeat
end _DisplayBrokenBehaviors
