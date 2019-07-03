script "lib_Test"
--> MetaData
-
license: GPLv3
name: lib_Test
type: library
version: 0.1


--> Test
-
function test_Run testArray, pTestCommand
   if pTestCommand is empty then put "test_Command" into pTestCommand
   --
   repeat with testNum = 1 to item 2 of the extents of testArray
      set the cursor to busy
      put testArray [testNum]["input"] into inputValue
      put testArray [testNum]["resultValue"] into resultValue
      --
      dispatch pTestCommand to the target with inputValue
      if it is "handled" then
         put the result into actualResult
      else
         put "not handled" into actualResult
      end if
      --
      set the caseSensitive to true
      if actualResult = resultValue then
         put inputValue into resultArray ["good"][testNum]["input value"]
         put actualResult into resultArray ["good"][testNum]["good result"]
      else
         put inputValue into resultArray ["bad"][testNum]["input value"]
         put actualResult into resultArray ["bad"][testNum]["actual result"]
         put resultValue into resultArray ["bad"][testNum]["should be"]
      end if
   end repeat
   --
   return resultArray
end test_Run

command test_AddToArray @testArray, inputValue, resultValue
   put item 2 of the extents of testArray + 1 into testNum
   put inputValue into testArray [testNum]["input"]
   put resultValue into testArray [testNum]["resultValue"]
end test_AddToArray
