script "Global | Assets | Menu"
--> MetaData
-
license: GPLv3
name: Global | Assets | Menu
type: controller
version: 0.2


--> Menu | Init
-


--> Global | Assets | Menu
-
on menu_Test
   put the params
end menu_Test

on submenu_ViewAssets
   return "Global | View | Assets | Menu"
end submenu_ViewAssets
