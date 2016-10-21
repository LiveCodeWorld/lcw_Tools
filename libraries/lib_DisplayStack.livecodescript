script "lib_DisplayStack"
--> MetaData
-
license: GPLv3
name: lib_DisplayStack
type: library
version: 0.1


--> Display | Events
-
command mDouble_DisplayStack indexView, stackName
   switch
      case exists (stack stackName) is false
         answer merge("Could not find stack '[[stackName]]'.")
         break
      case the scriptonly of stack stackName is true
         edit the script of stack stackName
         break
      default
         go to stack stackName
   end switch
end mDouble_DisplayStack

on mDouble_DisplayStackDeps treeView, stackName
   if the controlkey is "Down" then return false
   
   put the name of stack stackName into stackObject
   if the optionKey is "Down" then
      display_StackDeps stackObject
   end if
   edit the script of stackObject
   return true
end mDouble_DisplayStackDeps


--> Display | Stack
-
command display_StackDeps stackObject
   put the project_Name of stackObject into projectName
   put the stack_PlaceArray of stackObject into pDepArray
   
   put merge ("[[stackObject]],[[projectName]]") into someTitle
   
   put "Global | HkeyArray | Tree | Deps | Menu" into mTitle
   put "Global | HkeyArray | Menu" into mLineTitle
   display_Array pDepArray, someTitle, mTitle, mLineTitle, "mouse_EditHkey", "mouse_EditHkey"
   put the result into indexView
   set the displayed_Object of indexView to stackObject
   set the multiple_Hilites of indexView to false
   return indexView
end display_StackDeps

command display_Stacks stackNames, pIndexView, pStackTitle
   if pStackTitle is empty then put "Stacks,Environment" into pStackTitle
   
   put "mDouble_DisplayStack" into mDoubleUp
   
   if exists (pIndexView) is false then
      put empty into mUp
      display_Index stackNames, pStackTitle, mTitle, mLineTitle, mUp, mDoubleUp
      put the result into displayView
      return displayView
   else
      lock screen
      set the view_Index of pIndexView to stackNames
      set the stack_Title of pIndexView to pStackTitle
      set the mouse_DoubleUpEvent of pIndexView to mDoubleUp
      unlock screen
      return pIndexView
   end if
end display_Stacks

