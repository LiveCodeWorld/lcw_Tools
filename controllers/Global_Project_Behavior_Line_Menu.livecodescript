script "Global | Project | Behavior | Line | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Project | Behavior | Line | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   -- called once for each menu
   return the display_View of tObject
end menu_Target

getprop menu_CheckTarget [mTarget]
   -- use to do initialisation
   pass menu_CheckTarget
end menu_CheckTarget

getprop moveBehavior_Params
   put env_ListActiveProjects() into projectNames
   return projectNames
end moveBehavior_Params


--> Global | Project | Behavior | Line | Menu
-
on menu_MoveBehavior dView, newProjectName
   put _GetStackName (dView) into oBehaviorName
   put _SelectedBehavior (dView) into bObject
   --
   ask_MoveBehavior mController, gMenuTitle, newProjectName, displayView
   
   put the title_Text of dView into oProjectName
   --
   switch
      case newProjectName is empty
         lcw_AnswerWarning "Something went wront with script. This menu item is supposed to list new project names?"
      case oProjectName = newProjectName
         lcw_AnswerWarning merge ("Stack is already in project '[[newProjectName]]'. Choose a new project to move this library to!")
   end switch
   
   put the selected_Line of dView into oBehaviorName
   breakpoint
   project_MoveStackRelative oBehaviorName, newProjectName
   --
   lcw_Notify merge ("Moved library to new project '[[newProjectName]]'!")
   --
   display_Project oProjectName
   display_Project newProjectName
end menu_MoveBehavior
