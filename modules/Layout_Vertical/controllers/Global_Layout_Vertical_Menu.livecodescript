script "Global | Layout | Vertical | Menu"
--> MetaData
-
license: GPLv3
name: Global | Layout | Vertical | Menu
type: controller
version: 0.2

--> Menu | Props
-
local LocalArray

getprop viewIsFluid_Params [layoutView]
   put the layout_Views of layoutView into viewNames
   return viewNames
end viewIsFluid_Params

getprop addControl_Params
   return "field,button,field,image,scrollbar,graphic,player"
end addControl_Params

getprop addWidget_Params
   return "headerBar,navBar,segmented,browser,tree"
end addWidget_Params

getprop addView_Params
   put env_ListViewStackNames() into viewNames
   put view_GetIndexMenu (viewNames) into viewMenu
   return viewMenu
end addView_Params

getprop addModule_Params
   put env_ListModuleNames() into moduleNames
   put outline_FromPathIndex (moduleNames, "_") into moduleMenu
   return moduleMenu
end addModule_Params

function view_GetIndexMenu viewNames
   replace ("View|") with empty in viewNames
   get outline_FromPathIndex (viewNames, "|")
   if it is empty then 
      return "Place Holder"
   else
      return it & CR & "-" & CR & "Place Holder"
   end if
end view_GetIndexMenu


--> Global | Layout | Vertical | Menu
-
on menu_AddModule layoutView, lastMenuBit
   put mArray_GetActiveItem() into moduleName
   --
   set the module_Add of layoutView to moduleName
end menu_AddModule

on menu_AddView layoutView, lastMenuBit
   put mArray_GetActiveItem() into viewName
   set the itemdelimiter to "|"
   put "View" into item 1 of viewName
   --
   set the view_Add of layoutView to viewName
end menu_AddView

on menu_EmptyLayout layoutView
   set the layout_Views of layoutView to empty
end menu_EmptyLayout

on _
end _

on menu_ViewIsFluid layoutView, vewNames
   put the fdsa of layoutView
end menu_ViewIsFluid

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_TestAddViews layoutView
   put "View|Layout|Placeholder" & CR after viewNames
   put "View|Layout|Placeholder" & CR after viewNames
   delete char -1 of viewNames
   --
   set the layout_Views of layoutView to viewNames
end menu_TestAddViews
