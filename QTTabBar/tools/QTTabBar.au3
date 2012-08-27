;Path and filename of the installer executable
$QTTabBarINSTALLER="""" & $CmdLine[1] & """"

; Run QTTabBar installer
Run("msiexec /i " & $QTTabBarINSTALLER, "", @SW_HIDE)
If @error <> 0  Then 
	MsgBox(0, "Run failed", "The ""Run"" command failed with error " & Hex(@error, 8) & " for " & $QTTabBarINSTALLER & " - exiting")
	Exit
EndIf
 
;Wait for the installation to complete and the Dropbox account entry dialog to appear, close the window
WinWaitActive("QTTabBar 1.5.0.0 Beta 2 Setup", "&Next")
Send("!n")
WinWaitActive("QTTabBar 1.5.0.0 Beta 2 Setup", "I &accept the terms in the License Agreement")
Send("!a")
Send("!n")
WinWaitActive("QTTabBar 1.5.0.0 Beta 2 Setup", "&Change...")
Send("!n")
WinWaitActive("QTTabBar 1.5.0.0 Beta 2 Setup", "Click Install to begin the installation")
Send("!i")
WinWaitActive("QTTabBar 1.5.0.0 Beta 2 Setup", "Click the Finish button")
Send("!F")
;Installation complete
Exit