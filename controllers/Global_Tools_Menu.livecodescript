script "Global | Tools | Menu"
--> MetaData
-
license: GPLv3
name: Global | Tools | Menu
type: controller
version: 0.2


--> Menu | Props
-
getprop displayProjectArray_Params
   put env_GetHomeArrayFileData() into envProjectArrayFileArray
   put envProjectArrayFileArray ["projectNames"] into projectNameArray
   put keys (projectNameArray) into projectNames
   sort projectNames
   return projectNames
end displayProjectArray_Params

getprop displayProjectArray_Params
   put model_ListModelFiles (true) into shortFiles
   put file_StripExtension (shortFiles) into libraryArrayNames
   return libraryArrayNames
end displayProjectArray_Params

function file_StripExtension shortFiles
   set the columndelimiter to "."
   split shortFiles by column
   put shortFiles [1] into shortFileNames
   sort shortFileNames
   return shortFileNames
end file_StripExtension


--> Global | Tools | Menu
-
on submenu_Export
   return "Global | Project | Export | Menu"
end submenu_Export

on menu_DisplayLibraryArray mTarget, libraryArrayName
   put lcw_FetchArray (libraryArrayName) into libraryArray
   display_Array libraryArray, libraryArrayName, "lcw_FetchArray()"
end menu_DisplayLibraryArray

on menu_DisplayProjectArray indexView, someName
   put project_FetchArray (someName) into projectArray
   display_Array projectArray, someName, "project_FetchArray()"
end menu_DisplayProjectArray


--> Dev | Menu
-
