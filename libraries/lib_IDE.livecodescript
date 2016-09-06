script "lib_IDE"
put env_ListBehaviorPaths()v3
name: lib_IDE
type: libraries
version: 0.1


--> Script Field
-
command scriptField_DoTabkey selText, scriptField
   -- if the shiftkey is "Up" then pass tabkey
   
   put word 2 of the selectedChunk of scriptField into firstCharNum
   put word 4 of the selectedChunk of scriptField into lastCharNum
   put the text of scriptField into someScript
   put rev_ScriptObject() into scriptObject
   
   put scriptField_ConstructHkeyLine (selText, someScript, lastCharNum, scriptObject) into hkeyLine
   if hkeyLine is empty then return false
   
   hkey_Edit hkeyLine
   return true
end scriptField_DoTabkey

command scriptField_DoTabCompletion
   scriptField_TabComplete shortHkey, firstCharNum, lastCharNum, selText, scriptObject, scriptField
   if the result is empty then
      put item 1 of shortHkey into hName
      put empty into pTriggerHKey
      hkey_DisplayHandlerKeywordIndex hName, pTriggerHKey
   end if
end scriptField_DoTabCompletion

function scriptField_ConstructHkeyLine selText, someScript, lastCharNum, scriptObject
   put char 1 to lastCharNum of someScript into testScript
   put the number of lines of testScript into lineNum
   put line lineNum of someScript into scriptLine
   put line lineNum of testScript into testScriptLine
   
   scriptField_SetTokenInfo scriptLine, testScriptLine, thisTokenNum, nextTokenNum, prevTokenNum, thisToken, nextToken, previousToken
   switch
      case previousToken is among the items of "then,else"
         delete token 1 to prevTokenNum of scriptLine
         delete token 1 to prevTokenNum of testScriptLine
         scriptField_SetTokenInfo scriptLine, testScriptLine, thisTokenNum, nextTokenNum, prevTokenNum, thisToken, nextToken, previousToken
         break
   end switch
   
   -- put selText into hName
   put thisToken into hName
   switch
      case ide_IsDictionaryTerm (thisToken) is true
         return empty
      case previousToken = "command" and thisTokenNum = 2
      case thisTokenNum = 1
         -- maybe complete / incomplete command
         put "c" into hType
         break
      case nextToken = "("
         put "f" into hType
         break
      case previousToken = "the"
         put token (thisTokenNum - 2) of line lineNum of someScript into setOrGetToken
         if setOrGetToken = "set" then 
            put "s" into hType
         else
            put "g" into hType
         end if
         break
      case previousToken = "function" and thisTokenNum = 2
      case previousToken = "put"
         -- an unfinished function
         put "f" into hType
         break
      case previousToken is among the items of "call,send,dispatch"
         put token 1 of thisToken into hName
         put "c" into hType
         break 
      case the number of words of thisToken > 1
         -- it was a quoted string
         return empty
      default
         return empty
   end switch
   
   -- could search in heirarchy
   -- simple search of libs for now
   put hType && hName into shortHkey
   put hkey_GetPlace (shortHkey) into hObject
   put hKeyLine_FromTripple (hName, hType, hObject) into hkeyLine
   return hkeyLine
end scriptField_ConstructHkeyLine

command scriptField_SetTokenInfo scriptLine, testScriptLine, @thisTokenNum, @nextTokenNum, @prevTokenNum, @thisToken, @nextToken, @previousToken
   if word 1 of scriptLine is among the items of "--,#,/*" then
      -- another hack to allow looking up words in comments
      delete word 1 of scriptLine
      delete word 1 of testScriptLine
   end if
   
   -- hack in case a piece of quoted text is chopped in half
   put quote after testScriptLine
   
   put the number of tokens of testScriptLine into thisTokenNum
   put token thisTokenNum of scriptLine into thisToken
   
   put thisTokenNum + 1 into nextTokenNum
   put token nextTokenNum of scriptLine into nextToken
   
   put thisTokenNum - 1 into prevTokenNum
   if prevTokenNum = 0 then
      put empty into previousToken -- LiveCode bug: token 0 = the whole line
   else
      put token prevTokenNum of scriptLine into previousToken
   end if
end scriptField_SetTokenInfo

command scriptField_Tabkey selText, scriptField, pNoLibraryBehaviors
if pNoLibraryBehaviors is empty then put false into pNoLibraryBehaviors -- search normal heirarchy (set to true to skip library behaviors).

put word 2 of the selectedChunk of scriptField into firstCharNum
put word 4 of the selectedChunk of scriptField into lastCharNum
put the text of scriptField into someScript

put rev_ScriptObject() into scriptObject

try
   put scriptField_ConstructHkey (selText, someScript, lastCharNum) into shortHkey
   put shortHkey,scriptObject,1 into hKey -- should probably get the full hKey even if not first (ie hNum > 1)
   
   switch
      case shortHkey is empty
         opn_Notify "It's a Revolution language term or a variable!"
         break
      default
         switch
            case the optionKey is "Down"
               hArray_SearchAndEdit hKey
               break
            case the shiftKey is "Down"
               hArray_SearchHierarchyAndEdit shortHkey, scriptObject, true
               break
            default
               scriptField_TabComplete shortHkey, firstCharNum, lastCharNum, selText, scriptObject, scriptField
               if the result is empty then
                  put item 1 of shortHkey into hName
                  put empty into pTriggerHKey
                  hkey_DisplayHandlerKeywordIndex hName, pTriggerHKey
               end if
         end switch
   end switch
catch e
   put e
end try
end scriptField_Tabkey
