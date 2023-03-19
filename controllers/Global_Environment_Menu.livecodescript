script "Global | Environment | Menu"
--> MetaData
-
license: GPLv3
name: Global | Environment | Menu
type: controller
version: 0.3

/*
This menu needs tidying - removing the old stuff at the bottom.
*/


--> Variables
-
local LocalArray


--> Menu | Init
-
getprop disabled_Server
   put mArray_GetSimple() into isSimple
   return isSimple
end disabled_Server

getprop disabled_SaveEditedStacks
   put stack_ListEditedNames() into editedStackNames
   if editedStackNames is empty then
      -- return true
      return "delete"
   else
      return false
   end if
end disabled_SaveEditedStacks


--> Global | Environment | Menu
-
on menu_SaveEditedStacks
   stack_SaveEdited "all"
end menu_SaveEditedStacks

on menu_NotUpToDate dView
   put env_ListLocalProjects() into projectNames
   repeat for each line projectName in projectNames
      set the cursor to busy
      put env_ConstructHomePath (projectName) into homeStackPath
      if exists (stack homeStackPath) is false then
         breakpoint
         next repeat
      end if
      put the project_Folder of stack homeStackPath into gitFolder
      put git_IsUpToDate (gitFolder) into isUpToDate
      --
      if isUpToDate is false then
         put projectName & CR after needsUpdating
      end if
   end repeat
   delete char -1 of needsUpdating
   --
   -- put needsUpdating
   set the displayed_Index ["Not Up-to-Date"] of dView to needsUpdating
end menu_NotUpToDate

on _
end _

on submenu_TransportServer
   return "Global | Transport | Model | Menu"
end submenu_TransportServer

on submenu_Atopia
   return "Global | Environment | Atopia | Menu"
end submenu_Atopia

on menu_FederationModels
   display_FederationModels
end menu_FederationModels

on menu_FederationTools
   put fedray_FetchModel() into fedray
   display_Tools fedray, "Federation Model", "Federation", "LCW", "lcw_Server"
end menu_FederationTools

on menu_ServerTools
   display_Tools someData, "Federation Servers", "Federation | Server", "LCW", "lcw_Server"
end menu_ServerTools

on __
end __

on submenu_Projects
   return "Global | LCW | Projects | Menu"
end submenu_Projects

on submenu_Display
   return "Global | Environment | Display | Menu"
end submenu_Display

on submenu_Gather
   return "Global | Environment | Gather | Menu"
end submenu_Gather

on ___
end ___

on submenu_Server
   return "Global | Environment | Server | Menu"
end submenu_Server

on submenu_Ide
   return "Global | ScriptEditor | Menu"
end submenu_Ide

on submenu_Dev
   return "Global | Environment | Dev | Menu"
end submenu_Dev

on ____
end ____

on menu_RecentExports mTarget
   put 60 * 60 into howLong
   display_RecentExports howLong
end menu_RecentExports

on menu_InstallBrew
   /*
   -- https://github.com/Homebrew/install/#install-homebrew-on-macos-or-linux
   NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   
   ==> Running in non-interactive mode because `$NONINTERACTIVE` is set.
   ==> Checking for `sudo` access (which may request your password)...
   Need sudo access on macOS (e.g. the user david needs to be an Administrator)!
   
   https://unix.stackexchange.com/questions/275505/run-a-sudo-command-specifying-the-password-on-the-same-line
   */
   
   put "/bin/bash" into sShell
   put space & "-c" after sShell
   -- put space & kwote ("$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)") after sShell
   put space & "\'$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\'" after sShell
   --
   -- put "NONINTERACTIVE=1" & space before sShell
   -- put shell (sShell)
   --
   -- put sShell
   --
   terminal_PasteScript sShell
   if line 1 of the result is "Execution error" then
      lcw_Answer "Give Livecode permissions to use shell, then try again!"
   end if
end menu_InstallBrew

on menu_InstallNvm
   put "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash" into sShell
   terminal_PasteScript sShell
end menu_InstallNvm

on menu_InstallNpm
   put "nvm install node" into sShell
   terminal_PasteScript sShell
end menu_InstallNpm

-- on menu_UpdateNpm
   put "npm install -g npm" into sShell
   terminal_PasteScript sShell
end menu_UpdateNpm

on menu_InstallXterm
   put "npm install xterm" into sShell
   terminal_PasteScript sShell
end menu_InstallXterm

on _Refresh
   display_Environment
end _Refresh
