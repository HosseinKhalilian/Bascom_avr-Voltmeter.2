'======================================================================='

' Title: 4-Digit 7Segment LED Voltmeter 0-25
' Last Updated :  03.2022
' Author : A.Hossein.Khalilian
' Program code  : BASCOM-AVR 2.0.8.5
' Hardware req. : ATmega8 + 4-Digit 7Segment

'======================================================================='

$regfile = "m8def.dat"
$crystal = 4000000

Config Timer0 = Timer , Prescale = 8
Config Adc = Single , Prescaler = Auto , Reference = Internal

Config Pinc.5 = Input
Config Portd = Output
Portd = 0
Config Pinb.0 = Output
Portb.0 = 0
Config Pinb.1 = Output
Portb.1 = 0
Config Pinb.2 = Output
Portb.2 = 0
Config Pinb.3 = Output
Portb.3 = 0

Enable Interrupts
Enable Ovf0
On Ovf0 Overflow_isr
Tcnt0 = &H19

Dim Timecount As Word : Timecount = 0
Dim I As Byte

Dim L(10) As Byte
L(1) = &B11111001
L(2) = &B10100100
L(3) = &B10110000
L(4) = &B10011001
L(5) = &B10010010
L(6) = &B10000010
L(7) = &B11111000
L(8) = &B10000000
L(9) = &B10010000
L(10) = &B11000000
Dim Le(10) As Byte
Le(1) = &B01111001
Le(2) = &B00100100
Le(3) = &B00110000
Le(4) = &B00011001
Le(5) = &B00010010
Le(6) = &B00000010
Le(7) = &B01111000
Le(8) = &B00000000
Le(9) = &B00010000
Le(10) = &B01000000
Dim Channel As Byte
Dim W As Long
Dim Ss As Byte
Dim Ad As Long
Dim S(4) As String * 1
Dim Sa As String * 5
Dim Sl(4) As Byte

'-----------------------------------------------------------

Do

W = 0
Ss = 1
Ad = 0
For Ss = 1 To 20
Start Adc
Channel = 5
W = Getadc(channel)
Stop Adc
Ad = Ad + W
Next Ss
Ad = Ad / 20
Ad = Ad * 2560
Ad = Ad / 1023
Ad = Ad * 10

If Ad < 1000 Then
Sa = Str(ad)
Sa = Format(sa , "000")

S(1) = Mid(sa , 3 , 1)
S(2) = Mid(sa , 2 , 1)
S(3) = Mid(sa , 1 , 1)
I = Val(s(1))
If I = 0 Then
Sl(1) = L(10)
Else
Sl(1) = L(i)
End If

I = Val(s(2))
If I = 0 Then
Sl(2) = L(10)
Else
Sl(2) = L(i)
End If

I = Val(s(3))
If I = 0 Then
Sl(3) = L(10)
Else
Sl(3) = L(i)
End If


Sl(4) = Le(10)

End If

If Ad >= 1000 And Ad < 10000 Then
Sa = Str(ad)
Sa = Format(sa , "0000")

S(1) = Mid(sa , 4 , 1)
S(2) = Mid(sa , 3 , 1)
S(3) = Mid(sa , 2 , 1)
S(4) = Mid(sa , 1 , 1)
I = Val(s(1))
If I = 0 Then
Sl(1) = L(10)
Else
Sl(1) = L(i)
End If

I = Val(s(2))
If I = 0 Then
Sl(2) = L(10)
Else
Sl(2) = L(i)
End If

I = Val(s(3))
If I = 0 Then
Sl(3) = L(10)
Else
Sl(3) = L(i)
End If

I = Val(s(4))
If I = 0 Then
Sl(4) = Le(10)
Else
Sl(4) = Le(i)
End If

End If

If Ad >= 10000 And Ad < 100000 Then
Sa = Str(ad)
Sa = Format(sa , "0000")
S(1) = Mid(sa , 4 , 1)
S(2) = Mid(sa , 3 , 1)
S(3) = Mid(sa , 2 , 1)
S(4) = Mid(sa , 1 , 1)
I = Val(s(1))
If I = 0 Then
Sl(1) = L(10)
Else
Sl(1) = L(i)
End If

I = Val(s(2))
If I = 0 Then
Sl(2) = L(10)
Else
Sl(2) = L(i)
End If

I = Val(s(3))
If I = 0 Then
Sl(3) = Le(10)
Else
Sl(3) = Le(i)
End If

I = Val(s(4))
If I = 0 Then
Sl(4) = L(10)
Else
Sl(4) = L(i)
End If
End If

Waitms 200

Loop

End

'-----------------------------------------------------------

T1:
Disable Timer0
Do
   Portb.0 = 1
   Portd = &B10011001
Loop
Return

''''''''''''''''''''''''''''''

Overflow_isr:

Tcnt0 = &H19
Incr Timecount
If Timecount = 15 Then                                      '1 m 502 = 1s 4m 2008 = 1s
Timecount = 0
Portb.0 = 1
Portd = Sl(1)
Waitms 5
Portb.0 = 0
Portb.1 = 1
Portd = Sl(2)
Waitms 5
Portb.0 = 0
Portb.1 = 0
Portb.2 = 1
Portd = Sl(3)
Waitms 5
Portb.0 = 0
Portb.1 = 0
Portb.2 = 0
Portb.3 = 1
Portd = Sl(4)
Waitms 5
Portb.3 = 0

End If
Return
'-----------------------------------------------------------