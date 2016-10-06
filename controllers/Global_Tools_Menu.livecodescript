script "Global_Tools_Menu"
--> MetaData
-
license: GPLv3
name: Global_Tools_Menu
type: controller
version: 0.2


--> Global | Tools | Menu
-
on menu_DisplayLibraryArray mTarget, libraryArrayName
   put library_FetchArray (libraryArrayName) into libraryArray
   display_Array libraryArray, merge ("[[libraryArrayName]],library_FetchArray()")
end menu_DisplayLibraryArray

on menu_DisplayProjectArray indexView, someName
   put project_FetchArray (someName) into projectArray
   display_Array projectArray, merge ("[[someName]],project_FetchArray()")
end menu_DisplayProjectArray


--> Global | Tools | Menu | Props
-
getprop some_Names
   put env_GetHomeArrayFileData() into envProjectArrayFileArray
   put envProjectArrayFileArray ["projectNames"] into projectNameArray
   put keys (projectNameArray) into projectNames
   sort projectNames
   return projectNames
end some_Names

getprop library_ArrayNames
   return library_ListArrayNames()
end library_ArrayNames

--> Global | Tools | Menu | Disabled
-

--> Dev | Menu
-
on menu_TestModel
   -- check we are not overiding an important model
   breakpoint
   -- grab some test data
   put model_GetArray ("model_Library", "ProjectDataLibrary") into oldModelArray
   
   put "model_Environment" into modelStackName
   set the model_Array [modelStackName] of stack modelStackName to oldModelArray
   put the model_Array [modelStackName] of stack modelStackName into modelArray
   display_Array modelArray
end menu_TestModel

