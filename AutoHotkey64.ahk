GroupAdd("ECS", "ahk_exe vs.exe")
GroupAdd("ECS", "ahk_exe pycharm64.exe")
GroupAdd("ECS", "ahk_exe vs2.exe")
GroupAdd("ECS", "ahk_exe Code.exe")





lcPressed := false
kProcessing := false

~LCtrl:: {
    lcPressed := true
}

~LCtrl up:: {
    lcPressed := false
}


<^a::Send "{Home}"
<^+a::Send "+{Home}"

<^b::Send "{Left}"
<^+b::Send "+{Left}"

<^d::Send "{Delete}"
<^+d::Send "+{Delete}"

<^e::Send "{End}"
<^+e::Send "+{End}"

<^f::Send "{Right}"
<^+f::Send "+{Right}"

<^m::Send "{PgDn}"
<^+m::Send "^{End}"

<^n::Send "{Down}"
<^+n::Send "+{Down}"

<^p::Send "{Up}"
<^+p::Send "+{Up}"

<^u::Send "{PgUp}"
<^+u::Send "^{Home}"

<^w::{
	if(WinActive("ahk_group ECS")){
		Send "^w"
	}else{
		Send "^f"
	}
}

SingleKey(key){
	if(lcPressed){
		return
	}
	Send key
}


$a::SingleKey("a")
$b::SingleKey("b")
$d::SingleKey("d")
$e::SingleKey("e")
$f::SingleKey("f")
$m::SingleKey("m")
$n::SingleKey("n")
$p::SingleKey("p")
$u::SingleKey("u")
$k::{
	if(lcPressed || kProcessing){
		return
	}
	Send "k"
}


<^Space:: {
    KeyWait "Space"  ; Wait for Space to be released
    KeyWait "LCtrl"  ; Wait for LCtrl to be released
    Send "{LAlt down}{LShift down}{LAlt up}{LShift up}"
}

<^l::{
	if(WinActive("ahk_group ECS")){
		Send "^l"
	}
	else
	{
		CaretGetPos(&cX, &cY)

		if(cY == ""){
			return
		}
		
		RelPos := cY - 480
		RelPos := RelPos / 50
		Count := Abs(RelPos)
		
		LoopCount := 1


		while(LoopCount >= 1){
			CaretGetPos(&cX, &cY)
			if(cY = ""){
				return
			}

			CaretY0 := cY
			
			RelPos := CaretY0 - 480
			RelPos := RelPos / 50
			Count := Abs(RelPos)
			
			if(Count >= 1){
				if(RelPos >= 0){

					Loop Count
					{
						SendInput "{WheelDown}"
					}
				}
				else
				{
					Loop Count
					{
						SendInput "{WheelUp}"
					}
				}
			}
			else
			{
				break
			}
			LoopCount := LoopCount - 1
		}
	}
}


<^k::{
	if(WinActive("ahk_group ECS")){
		Send "^k"
	}else{
		kProcessing := true
		
		CaretGetPos(&cX, &cY)

		CaretX1 := cX
		Send "+{End}"

		Sleep 60
		CaretX2 := cX
		
		IsCaretEq := (CaretX1 = CaretX2)
		
		if(IsCaretEq){
			Send "{Delete}"
		}else{
			Send "^x"
		}
		
		kProcessing := false
	}
}


;Launcher
AppsKey:: {
    if KeyWait("AppsKey", "T0.3") {
        ; Key released within 0.3 seconds (short press)
        Send "{AppsKey}"
        KeyWait "AppsKey"
    } else {
        ; Key held longer than 0.3 seconds (long press)
        Run "d:/uni/bin2/plaunch.exe"
        KeyWait "AppsKey"
    }
}

CapsLock::
{
    if !KeyWait("CapsLock", "T0.3") 
    {
        if GetKeyState("CapsLock", "T")
            SetCapsLockState "Off"
        else
            SetCapsLockState "On"
            
        KeyWait "CapsLock"
    }
    else
    {
        Send "#h"
    }
}
