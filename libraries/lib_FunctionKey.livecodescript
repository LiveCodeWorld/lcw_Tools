﻿script "lib_FunctionKey"
--> MetaData
-
license: GPLv3
name: lib_FunctionKey
type: library
version: 0.2


--> FunctionKey
-
on functionKey keyNumber
   if the optionKey is "Down" then breakpoint
   switch keyNumber
      case 1
         display_Environment
         break
      case 2
         put stack_FindNames ("View|Camera") into cNames
         stack_ToggleDecorations cNames, empty
         break
      case 3
         break
      case 4
         put the top_Card of the topStack into topCard
         if the shiftKey is "Down" then
            _TopCardViewDisplays topCard
         else
            _TopViewDisplays topCard
         end if
         break
      case 5
         breakpoint
         
         global gLCW
         put gLCW ["temp"]["Record"]["What"] into recordWhat
         switch recordWhat
            case "camera"
               
               break
            case "screen"
            default
               screen_ToggleRecord "", true
         end switch
         break
      case 6
         camera_ToggleLoaded
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
         _SaveEverything
         break
      default
         --
   end switch
   pass functionKey
end functionKey

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

private command _SaveEverything
   stack_SaveEdited "all"
   --
   display_NotUpToDate
end _SaveEverything

private command _DisplayBrokenBehaviors
   put the top_ViewObjects of topCard into topViewObjects
   repeat for each line viewObject in topViewObjects
      display_BrokenBehaviors viewObject, true
   end repeat
end _DisplayBrokenBehaviors
