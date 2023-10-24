script "Global | Environment | Gather | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Environment | Gather | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-

--> Global | Environment | Gather | Menu
-
on menu_GatherDataViews
   put display_ListStackNames() into stackNames
   repeat for each line stackName in stackNames
      set the cursor to busy
      set the loc of stack stackName to the screenloc
      show stack stackName
   end repeat
end menu_GatherDataViews

on menu_ListDataViews
   display_ListDataViews
end menu_ListDataViews

on _
end _

on menu_FindStack
   display_SpotlightStacks
end menu_FindStack

on menu_FindPodcast
   display_FindPodcast
end menu_FindPodcast
