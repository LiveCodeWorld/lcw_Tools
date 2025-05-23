﻿script "lib_DisplayBehaviors"
--> MetaData
-
license: GPLv3
name: lib_DisplayBehaviors
type: library
version: 0.1


--> Working on
-
command display_ModuleBehaviors mView
   -- put the behavior_Objects of mView into bObjects
   
   put the behavior_StackNames of mView into aNames
   put the module_BehaviorStackNames of mView into sNames
   
   put the view_Name of mView into vName
   put vName && "Behaviors" into pTitle
   --
   display_Tool sNames, pTitle, "Display Behaviors"
   put the result into dView
   --
   set the displayed_Object of dView to mView
   set the coloured_Lines ["red"] of dView to aNames
   set the hilited_Lines of dView to empty
   --
   return dView
end display_ModuleBehaviors


--> Display | Behaviors
-
command display_Behaviors
   put behavior_ListNames() into bNames
   
   put "doDrag" into dragCommand
   put empty into upCommand
   put empty into doubleUpCommand
   
   put "Global | Behavior | Display | Menu" into titleMenu
   put "Global | Behavior | Display | Line | Menu" into lineMenu
   
   display_Index bNames, "Behaviors", titleMenu, lineMenu, upCommand, doubleUpCommand, dragCommand
   put the result into displayView
   set the multiple_Hilites of displayView to false
end display_Behaviors

function behavior_ListNames
   put hArray_ListBehaviorNames() into bNames
   return bNames
end behavior_ListNames

command display_BrokenBehaviors viewObject, pDisplayArray   
   put the behavior_BrokenArray of viewObject into testArray
   
   if pDisplayArray is true then
      display_Array testArray, the name of viewObject, "Views with behaviors"
      put the result into displayView
      display_SetInteractions displayView, "Display | Behaviors", pDoubleUp
      set the displayed_Object of displayView to viewObject
   end if
   return testArray
end display_BrokenBehaviors

command stack_FixBrokenBehaviors stackName
   local searchArray
   search_Stack stackName, "behavior", searchArray
   put keys (searchArray) into foundBehaviors
   repeat for each line foundBehavior in foundBehaviors
      put searchArray [foundBehavior] into objectsWithBehavior
      repeat for each line someObject in objectsWithBehavior
         set the cursor to busy
         if exists(someObject) is false then
            -- should not be possible
            breakpoint
            put searchArray [foundBehavior] into displayArray ["impossible error"][foundBehavior]
            next repeat
         end if
         
         if exists (foundBehavior) is false then
            -- probably not in stackfiles
            put searchArray [foundBehavior] into displayArray ["behavior does not exist"][foundBehavior]
            next repeat
         end if
         
         set the behavior of someObject to foundBehavior
         put searchArray [foundBehavior] into displayArray ["good behavior"][foundBehavior]
      end repeat
   end repeat
   return displayArray
end stack_FixBrokenBehaviors

getprop behavior_BrokenArray
   -- put the card_Object of the target into pCardObject
   put the long id of the target into tObject
   
   put the rugged_Views of tObject  into ruggedViews
   put the stack_Name of tObject  into stackName
   
   set the defaultstack to stackName
   repeat for each line ruggedView in ruggedViews
      put the name of ruggedView into namedRuggedView
      put the behavior of ruggedView into bObject
      switch
         case bObject is empty
            put namedRuggedView into testArray ["empty"][bObject]
            break
         case exists (bObject)
            put namedRuggedView into testArray ["exists"][bObject]
            set the behavior of ruggedView to bObject
            break
         default
            -- behavior exists and is broken
            put namedRuggedView into testArray ["exists and is broken"][bObject]
      end switch
   end repeat
   return testArray
end behavior_BrokenArray


command display_ProjectBehaviors homeStackName, pIndexView
   put project_ListBehaviorPaths (homeStackName) into behaviorPaths
   put stack_PathsToNames (behaviorPaths) into stackNames
   
   put merge ("[[homeStackName]],Project Behaviors") into someTitle
   display_Index stackNames, someTitle, "Global | View | Tree | Menu", mLineTitle, mUp, "mDouble_DisplayStack"
end display_ProjectBehaviors
