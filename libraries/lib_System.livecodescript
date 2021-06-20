script "lib_System"
--> MetaData
-
license: GPLv3
name: lib_System
type: library
version: 0.2


--> System
-
function system_TopTarget
   put item 1 of line 1 of the executioncontexts into topTarget
   return topTarget
end system_TopTarget

getprop screen_Rect [pWhichRect]
   put the stack_Name of the target into stackName
   put the loc of stack stackName into globalTargetLoc
   
   switch pWhichRect
      case "full"
         get the screenRects
         break
      case "effective"
         -- get the effective working screenRects -- rev bug: no longer works unless working is also there
         get the effective working screenRects
         break
      default -- "working"
         get the working screenRects
   end switch
   
   repeat for each line someScreenRect in it
      if globalTargetLoc is within someScreenRect then
         return someScreenRect
      end if
   end repeat
   return empty
end screen_Rect

getprop screen_Num
   put the stack_Name of the target into stackName
   put the loc of stack stackName into globalTargetLoc
   
   get the screenRects
   put 0 into screenNum
   repeat for each line someScreenRect in it
      add 1 to screenNum
      if globalTargetLoc is within someScreenRect then
         return screenNum
      end if
   end repeat
   return empty
end screen_Num

getprop screen_Width
   put the screen_Rect of the target into someRect
   return item 3 of someRect - item 1 of someRect
end screen_Width

getprop screen_Height
   put the screen_Rect of the target into someRect
   return item 4 of someRect - item 2 of someRect
end screen_Height

command screen_GatherStacks pResetTinyRects, pSomeGlobalLoc, pStackNames
   replace comma with CR in screen_GatherStacks
   if pStackNames is empty then
      put the openstacks into pStackNames
   end if
   --
   repeat for each line sName in pStackNames
      stack_RestorePosition sName, pSomeGlobalLoc, pResetTinyRects
   end repeat
end screen_GatherStacks

command stack_RestorePosition pStackName, pSomeGlobalLoc, pResetTinyRects
   if pStackName is empty then 
      put the short name of this stack into pStackName
   end if
   if pSomeGlobalLoc is empty then
      put the screenloc into pSomeGlobalLoc
   end if
   --
   if pResetTinyRects is not false then
      set the visible of stack pStackName to true
      --
      if the width of stack pStackName < 10 then
         breakpoint
         set the with of  stack pStackName to 200
      end if
      if the height of stack pStackName < 10 then
         breakpoint
         set the height of  stack pStackName to 200
      end if
   end if
   --
   set the loc of  stack pStackName to pSomeGlobalLoc
end stack_RestorePosition
   
function system_GetScreenRect screenNum, pWhichRect
   put word -1 of screenNum into screenNum -- allws for "Screen 2" as displayed in menus
   switch pWhichRect
      case "full"
         get the screenRects
         break
      case "effective"
         /*
         Adding the effective adjective to either form returns the area of the screen the application has to itself. 
         In particular, if the keyboard is activated, it take into account if the keyboard is taking up space on the screen. (Android and iOS only)
         */
         
         -- get the effective screenRects -- rev bug
         get the effective working screenRects
         break
      default -- "working"
         /*
         Adding the working adjective to either form returns the virtual co-ordinates of each screen's working-area. 
         The working-area of a screen is defined to be the area not covered by OS furniture (such as the task bar on Windows, and the Dock and Menubar on Mac OS X).
         */
         get the working screenRects
   end switch
   
   return line screenNum of it
end system_GetScreenRect

function system_ListScreenNames
   get the screenRects
   -- put "Primary" & CR into screenNames
   put "Screen 1" & CR into screenNames
   repeat with screenNum = 2 to the number of lines of it
      put "Screen" && screenNum & CR after screenNames
   end repeat
   delete char -1 of screenNames
   return screenNames
end system_ListScreenNames

 function system_NumberOfScreens
    get the screenRects
    return the number of lines of it
 end system_NumberOfScreens
