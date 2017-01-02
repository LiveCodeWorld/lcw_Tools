script "lib_FunctionKey"
--> MetaData
-
license: GPLv3
name: lib_FunctionKey
type: library
version: 0.1


--> FunctionKey
-
on functionKey keyNumber
   if the optionKey is "Down" then breakpoint
   put the top_Card of the topStack into topCard
   switch keyNumber
      case 1
         display_ProjectList
         break
      case 2
         display_LibrariesAndModels
         -- display_ProjectsAndModules
         break
      case 3
         put the top_ViewObjects of topCard into topViewObjects
         put the loc of the defaultstack into oLoc
         repeat for each line viewObject in topViewObjects
            -- display_NestedViewArray viewObject
            
            display_View viewObject
            put the result into indexView
            put the stack_Object of indexView into stackObject
            set the loc of stackObject to oLoc
            
            display_ViewBehaviors viewObject
            put the result into indexView
            put the stack_Object of indexView into stackObject
            set the loc of stackObject to oLoc
         end repeat
         break
      case 4
         put the view_Objects of topCard into viewObjects
         repeat for each line viewObject in viewObjects
            display_View viewObject
         end repeat
         break
      case 6
         display_GitStatus the topStack
         break
      case 10
         stack_ToggleShrink
         break
      case 12
         put the top_ViewObjects of topCard into topViewObjects
         repeat for each line viewObject in topViewObjects
            display_BrokenBehaviors viewObject, true
         end repeat
         break
      default
         put keyNumber
         breakpoint
   end switch
   pass functionKey
end functionKey


