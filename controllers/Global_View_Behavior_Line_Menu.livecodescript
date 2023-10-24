script "Global | View | Behavior | Line | Menu"
--> MetaData
-
license: GPLv3
name: Global | View | Behavior | Line | Menu
type: controller
version: 0.1


--> Variables
-
local LocalArray


--> Menu | Props
-
on menu_Init tObject
   put the display_View of tObject into displayView
   put displayView into LocalArray ["displayView"]
   
   -- put the title_Text of displayView into LocalArray ["moduleName"]
   put the view_Index of displayView into LocalArray ["bObjects"]
   put the selected_Line of displayView into LocalArray ["bObject"]
   put the hilited_Lines of displayView into LocalArray ["lineNum"]
   
   put the displayed_ProjectName of displayView into LocalArray ["projectName"]
   put the displayed_ProjectFolder of displayView into LocalArray ["projectFolder"]
   put the displayed_ModuleFolder of displayView into LocalArray ["moduleFolder"]
   put the displayed_ModuleName of displayView into LocalArray ["moduleName"]
   put the displayed_ModuleHomeStackPath of displayView into LocalArray ["moduleHomeStackPath"]   
end menu_Init

getprop checked_AddBehavior [moduleView]
   put LocalArray ["displayView"] into displayView
   return the selected_LineColour of displayView is "0,255,0" -- "Green"
end checked_AddBehavior

private function _BehaviorStack
   -- put LocalArray ["displayView"] into displayView
   -- put the selected_Line of displayView into bObject
   put LocalArray ["bObject"] into bObject
   return bObject
end _BehaviorStack


--> Global | View | Behavior | Line | Menu
-
on menu_EditBehavior moduleView
   put _BehaviorStack() into bObject
   edit the script of bObject
end menu_EditBehavior

on menu_BehaviorInspector
   put _BehaviorStack() into bObject
   display_ObjectProperties bObject
end menu_BehaviorInspector

on menu_AddBehavior moduleView
   put LocalArray ["displayView"] into displayView
   put the selected_LineColour of displayView into sLineColours
   --
end menu_AddBehavior

on menu_SetViewBehavior moduleView
   put _BehaviorStack() into bObject
   set the behavior of moduleView to bObject
end menu_SetViewBehavior

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Dev | Menu
-
on menu_MakeRed
   -- put LocalArray ["lineNum"] into lineNum
   put LocalArray ["displayView"] into displayView
   -- put the index_Field of displayView into fieldObject
   -- set the textcolor of line lineNum of fieldObject to "red"
   set the line_Colour of displayView to "red"
end menu_MakeRed
