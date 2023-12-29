script "Global | Tools | Menu"
--> MetaData
-
license: GPLv3
name: Global | Tools | Menu
type: controller
version: 0.2


--> Menu | Props
-
local LocalArray

getprop menu_Target [tObject]
   put the browser_View of tObject into browserView
   return browserView
end menu_Target

getprop scale_Params
   return "0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9-,1,-,1.5"
end scale_Params

getprop shrinkPage_Params [wikiView]
   return the lineup_Titles of wikiView
end shrinkPage_Params

getprop disabled_EditMode
   if LocalArray ["footer_IsVisible"] is true then
      return false
   else
      return true
   end if
end disabled_EditMode

getprop checked_EditMode [wikiView]
   put the wiki_EditMode of wikiView into sBoolean
   return sBoolean
end checked_EditMode

getprop checked_Footer [wikiView]
   -- return LocalArray ["footer_IsVisible"]
   return the footer_IsVisible of wikiView
end checked_Footer

getprop checked_BrowserVisible [wikiView]
   put the visible of wikiView into isVisible
   return isVisible
end checked_BrowserVisible

getprop checked_SetMenuBar [wikiView]
   put the show_Menu of wikiView into sBoolean
   return sBoolean
end checked_SetMenuBar

getprop setMenuTitle_Params [wikiView]
   return _MenuButtonNames(wikiView)
end setMenuTitle_Params

getprop menuButtonInspector_Params [wikiView]
   return _MenuButtonNames(wikiView)
end menuButtonInspector_Params

private function _MenuButtonNames wikiView
   put the menu_Bar of wikiView into mBar
   return the menu_Names of mBar
end _MenuButtonNames


--> Global | Tools | Menu
-
on menu_SetMenuTitle wikiView, mName
   put the menu_Bar of wikiView into mBar
   --
   put the menu_Title [mName] of mBar into mTitle
   put lcw_Ask ("Edit menu_Title...", mTitle, "Edit Menu Titles", wikiView) into mTitle
   set the menu_Title [mName] of mBar to mTitle
end menu_SetMenuTitle

on menu_MenuButtonInspector wikiView, mName
   put the menu_Bar of wikiView into mBar
   display_ObjectProperties mBar
end menu_MenuButtonInspector

on menu_DisplayWikiTools wikiView
   set the page_Title of wikiView to "Tools"
end menu_DisplayWikiTools

on menu_Scale wikiView, sSale
   -- put wikijs_SetPageScale (sSale) into sJavascript
   -- set the browser_Javascript of wikiView to sJavascript
   set the wiki_Scale of wikiView to sSale
end menu_Scale

on menu_ShrinkPage wikiView, pageTitle
   put wikijs_SetPageScale (sSale) into sJavascript
   set the browser_Javascript of wikiView to sJavascript
end menu_ShrinkPage

private on __
end __

on menu_Footer wikiView
   put the footer_IsVisible of wikiView into sBoolean
   set the footer_IsVisible of wikiView to (sBoolean is false)
end menu_Footer

on menu_BrowserVisible wikiView
   put the visible of wikiView into isVisible
   set the visible of wikiView to (isVisible is false)
end menu_BrowserVisible

on menu_TestRect.T wikiView
   put the card_Rect of wikiView into oRect
   --
   put the rect of wikiView into sInfo
   put CR & oRect &CR& the rect of cd 1 of stack "View|Obeya|Studio" after sInfo
   put CR & the view_RectOnCard of cd 1 of stack "View|Obeya|Studio" after sInfo
   put sInfo
   --
   dispatch "LayoutControl" to wikiView with oRect
   -- set the rect of wikiView to oRect
end menu_TestRect.T

on menu_SetMenuBar.B wikiView
   -- put the rect of wikiView into oRect
   put the card_Rect of wikiView into oRect
   put the show_Menu of wikiView into sBoolean
   set the show_Menu of wikiView to (sBoolean is false)
   set the rect of wikiView to oRect
end menu_SetMenuBar.B


