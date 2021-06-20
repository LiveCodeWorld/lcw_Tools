script "Global | Layout | Placeholder | Replace | Menu"
--> MetaData
-
license: GPLv3
name: Global | Layout | Placeholder | Replace | Menu
type: controller
version: 0.7


--> Menu | Props
-
local LocalArray

getprop replaceWithControl_Params
   return "field,button,field,image,scrollbar,graphic,player"
end replaceWithControl_Params

getprop replaceWithWidget_Params
   return "headerBar,navBar,segmented,browser,tree"
end replaceWithWidget_Params

getprop replaceWithView_Params
   put env_ListViewStackNames() into viewNames
   put view_GetIndexMenu (viewNames) into viewMenu
   return viewMenu
end replaceWithView_Params

getprop replaceWithModule_Params
   put env_ListModuleNames() into moduleNames
   put outline_FromPathIndex (moduleNames, "_") into mmoduleMenu
   return mmoduleMenu
end replaceWithModule_Params

function view_GetIndexMenu viewNames
   replace ("View|") with empty in viewNames
   get outline_FromPathIndex (viewNames, "|")
   if it is empty then 
      return "Place Holder"
   else
      return it & CR & "-" & CR & "Place Holder"
   end if
end view_GetIndexMenu


--> Global | Layout | Placeholder | Replace | Menu
-
on menu_ReplaceWithPlaceholder tObject
   put the short name of tObject into oName
   set the control_Type [oName] of tObject to "placeHolder"
   put the result into newView
end menu_ReplaceWithPlaceholder

on _
end _

on menu_ReplaceWithWidget tObject, widgetName 
   set the header_Height of tObject to 64
   set footer_Height of tObject to 49
   set the control_Type of tObject to widgetName
end menu_ReplaceWithWidget

on menu_ReplaceWithControl tObject, revControlName 
   set the control_Type of tObject to revControlName
end menu_ReplaceWithControl

on menu_ReplaceWithView tObject, viewPathFragment 
   -- set the view_Swap [true] of tObject to viewPathFragment
   set the control_Type of tObject to viewPathFragment
end menu_ReplaceWithView

on menu_ReplaceWithModule tObject, viewPathFragment 
   set the control_Type of tObject to viewPathFragment
end menu_ReplaceWithModule
