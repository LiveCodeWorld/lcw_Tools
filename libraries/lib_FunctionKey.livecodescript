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
   switch keyNumber
      case 1
         display_ProjectList
         break
      case 3
         put the view_Objects of cd 1 of the topStack
         -- display_View viewObject
         break
      case 6
         display_GitStatus the topStack
         break
      default
         put keyNumber
   end switch
   pass functionKey
end functionKey


