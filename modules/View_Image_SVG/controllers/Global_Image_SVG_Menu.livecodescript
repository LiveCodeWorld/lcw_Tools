script "Global | Image | SVG | Menu"
--> MetaData
-
license: GPLv3
name: Global | Image | SVG | Menu
type: controller
target: svgView
version: 0.2


--> Menu | Init
-
getprop menu_Target [tObject]
   put the svg_View of tObject into svgView
   if exists(svgView) is false then
      -- could be a index tool palette
      put the displayed_Object of tObject into svgView
   end if
   return svgView
end menu_Target

getprop menu_CheckTarget [mTarget]
   if exists (mTarget) is true then
      return true
   else
      return false
   end if
end menu_CheckTarget

private function _DisplayedObject svgView
   -- put the displayed_Object of svgView into hObject
   put the stack_Name of svgView into stackName
   put the label of stack stackName into hKey
   hkey_Deconstruct hKey, hName, hType, hObject, hNum
   return hObject
end _DisplayedObject

private function _ShortAssetFiles svgView
   put _DisplayedObject (svgView) into hObject
   if exists (hObject) is false then return empty
   --
   put the project_Folder of hObject into projectFolder
   put asset_ListFiles (projectFolder, empty, true) into shortAssetFiles
   return shortAssetFiles
end _ShortAssetFiles

getprop displayAsset_Params [svgView]
   put _ShortAssetFiles (svgView) into shortAssetFiles
   return shortAssetFiles
end displayAsset_Params

getprop fluidSvg_Param [svgView]
   put the svg_IsFluid of svgView into someBoolean
   return someBoolean
end fluidSvg_Param

getprop fluidSvg_Params
   return "true,false"
end fluidSvg_Params

getprop deleteHeaderKey_Params [svgView]
   -- strange bug trying to set this to header_Keys, or some_Keys
   put the svg_HeaderArray of svgView into svgHeaderArray
   return keys (svgHeaderArray)
end deleteHeaderKey_Params

getprop disabled_DownloadAssets [svgView]
   put _ShortAssetFiles (svgView) into shortAssetFiles
   if shortAssetFiles is empty then
      return true
   else
      return false
   end if
end disabled_DownloadAssets

getprop disabled_DisplayAsset [svgView]
   put _ShortAssetFiles (svgView) into shortAssetFiles
   if shortAssetFiles is empty then
      return true
   else
      return false
   end if
end disabled_DisplayAsset


--> Global | Image | SVG | Menu
-
on submenu_Library
   return "Global | Svg | Library | Menu"
end submenu_Library

on _
end _

on menu_DisplaySvgPathText svgView
   put the svg_XML of svgView into svgXML
   put svg_GetPathText (svgXML)
end menu_DisplaySvgPathText

on menu_SvgTools svgView
   put the view_Props of svgView into svgIndex
   put the stack_Name of svgView into pTitle
   --
   display_Data svgIndex, pTitle, "SVG Tools"
   put the result into displayView
   display_SetInteractions displayView, "Image | SVG", "mDoubleUp_SvgProp"
   --
   set the displayed_Object of displayView to svgView
   -- put _DisplayedObject (svgView) into hObject
end menu_SvgTools

on mDoubleUp_SvgProp
   breakpoint
end mDoubleUp_SvgProp

on menu_FluidSvg svgView, someBoolean
   set the svg_IsFluid of svgView to someBoolean
end menu_FluidSvg

on _
end _

on submenu_Assets
   return "Global | Svg | Assets | Menu"
end submenu_Assets

on submenu_Handler
   return "Handler | Menu"
end submenu_Handler

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Handler | Menu
-
on menu_ObjectProcessedArray svgView
   put _DisplayedObject (svgView) into hObject
   --
   put the projectOverlay_Array ["processedHkey.array"] of hObject into processedHkeyArray  
   display_Array processedHkeyArray, "processedHkeyArray"
end menu_ObjectProcessedArray

on menu_HandlerArray svgView
   put the displayed_Hkey of svgView into hKey
   hkey_Deconstruct hKey, hName, hType, hObject, hNum
   
   put hkey_SvgFile (hKey) into svgFile
   
   put the projectOverlay_Array ["processedHkey.array"] of hObject into processedHkeyArray  
   display_Array processedHkeyArray, "processedHkeyArray"
end menu_HandlerArray

on _
end _

on menu_HandlerFolder svgView
   put the displayed_Hkey of svgView into hKey
   put hkey_Folder (hKey) into hFolder
   finder_Reveal hFolder
end menu_HandlerFolder

on menu_HandlerMetadataFolder svgView
   put the displayed_Hkey of svgView into hKey
   --
   put hkey_MetadataFolder (hKey) into someFolder
   -- put the metadata_Folder [hKey] of hObject into someFolder
   finder_Reveal someFolder
end menu_HandlerMetadataFolder

on menu_ObjectMetadataFolder svgView
   put _DisplayedObject (svgView) into hObject
   --
   put the metadata_Folder of hObject into someFolder
   finder_Reveal someFolder
end menu_ObjectMetadataFolder


--> Dev | Menu
-
on menu_SetUrl svgView, whichUrl
   breakpoint
   switch whichUrl
      case "Compound"
         put "http://livecode.world/graphs/graph.html" into someUrl
         break
      case "Paths"
         put "https://livecode.world/graphs/graphviz.html" into someUrl
         -- put "http://js.cytoscape.org/demos/6c9907e7896f8ae23f9f/" into someUrl
         break
      case "Huge"
         -- put "http://js.cytoscape.org/demos/57e7cc43342193d9d21a/" into someUrl
         put "http://js.cytoscape.org/demos/f64e811fc3311414e083/" into someUrl
         break
      case "Cats"
         put "http://js.cytoscape.org/demos/aedff159b0df05ccfaa5/" into someUrl
         break
      case "Wine"
         put "http://js.cytoscape.org/demos/cde4db55e581d10405f5/" into someURL
         break
      default
         answer file "Enter a url..."
         if it is empty then exit to top
         put it into someURL
   end switch
   -- put someURL
   set the url of svgView to someURL
end menu_SetUrl

on menu_DisplaySvgPane svgView
   put the svg_File of svgView into svgFile
   --
   display_SVG svgFile
end menu_DisplaySvgPane

on menu_DisplaySvgPane svgView
   put the svg_File of svgView into svgFile
   set the svg_File of svgView to svgFile
   --
   put scriptEditor_PaneObject ("Deps") into paneObject
   set the svg_File [true] of control 1 of paneObject to imageFile
   --
   put the svg_File [true] of control 1 of paneObject & CR & svgFile
end menu_DisplaySvgPane

on menu_DisplaySvgHeader svgView
   put the svg_HeaderArray of svgView into svgHeaderArray
   display_Array svgHeaderArray
end menu_DisplaySvgHeader

on menu_DisplaySvgxml svgView
   put the svg_XML of svgView
end menu_DisplaySvgxml

on _
end _

on menu_DeleteHeaderKey svgView, headerType
   put the svg_HeaderArray of svgView into svgHeaderArray
   delete variable svgHeaderArray [headerType]
   set the svg_HeaderArray of svgView to svgHeaderArray
end menu_DeleteHeaderKey

on menu_SetScale svgView
   put the svg_Scale of svgView into svgScale
   put lcw_Ask ("Change the scale of the svg view?", svgScale) into svgScale
   set the svg_Scale of svgView to svgScale
end menu_SetScale

on _
end _

on menu_EditSvgBehavior svgView
   put the behavior of svgView into bObject
   edit the script of bObject
end menu_EditSvgBehavior

on _
end _

on menu_RevealSvgFile svgView
   put the svg_File of svgView into svgFile
   finder_Reveal svgFile
end menu_RevealSvgFile

on menu_RevealHkeyOverlayFolder svgView
   put the displayed_Hkey of svgView into hKey
   put project_HandlerMetadataFolder (hKey, true) into hkeyMetadataFolder
   put "put project_HandlerMetadataFolder (hKey):" && hkeyMetadataFolder
   finder_Reveal hkeyMetadataFolder
end menu_RevealHkeyOverlayFolder

on menu_RevealProjectOverlayFolder svgView
   put _DisplayedObject (svgView) into scriptObject
   --
   put the project_OverlayFolder of scriptObject into projectOverlayFolder
   put "the project_OverlayFolder:" && projectOverlayFolder
   finder_Reveal projectOverlayFolder
end menu_RevealProjectOverlayFolder

on menu_RevealStackOverlayFolder svgView
   put _DisplayedObject (svgView) into scriptObject
   --
   put the overlay_Folder of scriptObject into overlayFolder
   put "the overlay_Folder:" && overlayFolder
   finder_Reveal overlayFolder
end menu_RevealStackOverlayFolder

on menu_RevealTextStackFolder svgView
   put _DisplayedObject (svgView) into scriptObject
   --
   put the textStack_Folder of scriptObject into textStackFolder
   put "the textStack_Folder:" && textStackFolder
   finder_Reveal textStackFolder
end menu_RevealTextStackFolder

