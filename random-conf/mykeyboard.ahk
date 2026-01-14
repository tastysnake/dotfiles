#Requires AutoHotkey v2.0
InstallKeybdHook
; needs keyboard hook to recognize dead keys


; <^>! means left Ctrl and right Alt, which is how Windows interprets
; the AltGr key
<^>!u:: SendText "µ"
<^>!s:: SendText "β"
<^>!z:: SendText "<"
<^>!x:: SendText ">"
SC01A:: SendText "``"
+SC01A:: SendText "^"
<^>!-:: SendText "—"
<^>!ñ:: SendText "~"

<^>!j::PgDn
<^>!k::PgUp

; swap Caps Lock for Esc and double-Shift for Caps Lock
LShift & RShift::CapsLock
CapsLock::Esc


