﻿script "Global | Layout | HeaderAndFooter | Menu"
--> MetaData
-
license: GPLv3
name: Global | Layout | HeaderAndFooter | Menu
type: controller
version: 0.2

--> Menu | Props
-
getprop menu_Target [tObject]
   put the title_Text of tObject into titleText
   put the display_View of tObject into dView
   if titleText = "View|Layout|HeaderAndFooter" then
      put the displayed_ViewObject of dView into vObject 
      -- put the displayed_ModuleFolder of dView into moduleFolder 
      put the displayed_ModuleName of dView into moduleName
      return vObject
   else
      pass menu_Target
   end if
end menu_Target

getprop disabled_SwapFooter [layoutView]
   put the view_IsTemplate of layoutView into isTemplate
   return isTemplate
end disabled_SwapFooter

getprop updateComponents_Params
   put the hkey_CaseConditions ["M menu_UpdateComponents"] of me into cParams
   return cParams
end updateComponents_Params

getprop editBehavior_Params
   put the hkey_CaseConditions ["M menu_EditBehavior"] of me into cParams
   return cParams
end editBehavior_Params

getprop setOrientation_Params
   return "portrait,landscape"
end setOrientation_Params

getprop setOrientation_Param [layoutView]
   put the mobile_Orientation of layoutView into whichOrientation
   return whichOrientation
   
   if the landscape_Layout of layoutView is true then
      return "landscape"
   else
      return "portrait"
   end if
end setOrientation_Param

getprop checked_ShowFooter [layoutView]
   put the footer_IsVisible of layoutView into sBoolean
   return sBoolean
end checked_ShowFooter

getprop checked_ShowHeader [layoutView]
   put the header_IsVisible of layoutView into sBoolean
   return sBoolean
end checked_ShowHeader


--> Global | Layout | HeaderAndFooter | Menu
-
on menu_ShowHeader layoutView
   put the header_IsVisible of layoutView into sBoolean
   set the header_IsVisible of layoutView to (sBoolean is false)
end menu_ShowHeader

on menu_ShowFooter layoutView
   put the footer_IsVisible of layoutView into sBoolean
   set the footer_IsVisible of layoutView to (sBoolean is false)
end menu_ShowFooter

on _
end _

on menu_EditBehavior layoutView, whichBehavior
   switch whichBehavior
      case "layout"
         put layoutView into childView
         put the behavior of layoutView into bObject
         break
      case "-"
      case "header"
         put the header_View of layoutView into childView 
         put the behavior of childView into bObject
         break
      case "body"
         put the body_View of layoutView into childView 
         put the behavior of childView into bObject
         break
      case "footer"
         put the footer_View of layoutView into childView 
         put the behavior of childView into bObject
         break
      default 
   end switch
   
   if exists (bObject) then
      edit the script of bObject
   else
      answer "This view does not have a behavior!"
      edit the script of childView
   end if
end menu_EditBehavior

on _
end _

on menu_UpdateComponents layoutView, withWhat
   put the header_View of layoutView into headerView
   put the body_View of layoutView into bodyView
   put the footer_View of layoutView into footerView
   
   put "View|SivaSiva|Navigation|Bottom" into footerName
   -- put "placeholder" into pName
   put "Layout|Placeholder" into pName
   put "View|SivaSiva|Navigation|Bottom" into footerName
   
   
   lock screen
   switch withWhat
      case "Placeholders"
         set the control_Type of headerView to pName
         put the result into pButton
         set the background_Colour of pButton to "random"
         
         set the control_Type of bodyView to pName
         put the result into pButton
         set the background_Colour of pButton to "random"
         
         set the control_Type of footerView to pName
         put the result into pButton
         set the background_Colour of pButton to "random"
         break
      case "Log"
         set the control_Type of headerView to "headerBar" -- "View|SivaSiva|Navigation|Bottom"
         put the result into newHeaderView
         set the behavior of newHeaderView to the name of stack "behavior_ViewHeader"
         set the backgroundcolor of newHeaderView to white
         set the title_Text of newHeaderView to "Log"
         
         set the control_Type of bodyView to "field"
         put the result into newBodyView
         
         set the control_Type of footerView to footerName
         break
         break
      case "Browser"
         set the control_Type of headerView to "headerBar" -- "View|SivaSiva|Navigation|Bottom"
         put the result into newHeaderView
         set the behavior of newHeaderView to the name of stack "behavior_ViewHeader"
         set the backgroundcolor of newHeaderView to white
         
         set the control_Type of bodyView to "browser"
         put the result into newBodyView
         set the url of newBodyView to "https://google.com"
         set the behavior of newBodyView to the name of stack "behavior_ViewBrowser"
         
         set the control_Type of footerView to footerName
         break
   end switch
   unlock screen
end menu_UpdateComponents

on menu_SwapFooter layoutView, whichView
   put the footer_View of layoutView into footerView
   switch whichView
      case "navbar"
         set the control_Type of footerView to "navbar"
         put the result into newFooterView
         put the name of stack "behavior_ViewNavBar" into bObject
         set the behavior of newFooterView to bObject
         break
      case "Siva Siva navigation"
         set the control_Type of footerView to "View|SivaSiva|Navigation|Bottom"
         put the result into newFooterView
         break
   end switch
end menu_SwapFooter

on __
end __

on menu_SetTitle layoutView
   set the title_Text of layoutView to "Log"
end menu_SetTitle

on menu_SetOrientation layoutView, whichOrientation
   set the mobile_Orientation of layoutView to whichOrientation
end menu_SetOrientation

private command ___
end ___

on menu_DisplayKenBurns layoutView, shortHtmlFile
   put the body_View of layoutView into browserView 
   put the project_HtmlFile ["burns_data.html"] of browserView into htmlFile
   set the url of browserView to htmlFile
end menu_DisplayKenBurns

on menu_SetDiscord layoutView
   put the body_View of layoutView into browserView 
   set the url of browserView to "https://discord.gg/GreQPTw"
end menu_SetDiscord

on menu_JoinSlack layoutView
   put the body_View of layoutView into browserView 
   set the url of browserView to "https://slack.com/signin"
end menu_JoinSlack

on menu_Tiger layoutView
   put the body_View of layoutView into browserView 
   set the url of browserView to "http://timmywil.github.io/jquery.panzoom/demo/"
end menu_Tiger

