Program Halom;
{****************************************************************************}
{***                                                                      ***}
{***                         HalomrendezÇs demo                           ***}
{***                            1.0a Verzi¢                               ***}
{***               (C) TwinNet 2000  (P) Szab¢ Andr†s 2000                ***}
{***                      2000.01.18.  - 2000.01.18.                      ***}
{***                                                                      ***}
{****************************************************************************}

{$A+,B-,D+,E+,F+,G+,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 32768,0,655360}
Uses TWSys{V1.2a},TObject{4.2c},TObjects{4.1e},Heap{1.0a};

{****************************************************************************}
{***                              Konstansok                              ***}
{****************************************************************************}

Const
 VMode                 :  word    = _640x480_256;   { Vide¢m¢d k¢dja         }
 ProgramName           :  string  = 'HeapSort 1.0a (C) Szab¢ Andr†s 2000';
 Info1                 :  string  = 'e-mail:szaboand@mail.petrikl.sulinet.hu';
 MDVX                  :  word    = $0003;  { Mouse X oszt†sar†ny (SHR)      }
 MDVY                  :  word    = $0003;  { Mouse X oszt†sar†ny (SHR)      }
 PixRat                :  word    = $0001;  { Mouse Pixel/Ratio              }
 MouseAct              :  boolean = TRUE;   { Saj†t mouse megjelen°tÇs       }
 BackgroundColor       :  byte    = $07;    { H†ttÇrszin                     }
 DBackgroundColor      :  byte    = $08;    { SîtÇt h†ttÇrszin               }
 DDBackgroundColor     :  byte    = $00;    { SîtÇt h†ttÇrszin               }
 LBackgroundColor      :  byte    = $0F;    { Vil†gos h†ttÇrszin             }
 InfoTextColor         :  byte    = $0F;    { Info textszin                  }
 DInfoTextColor        :  byte    = $08;    { SîtÇt info textszin            }
 TimeTextColor         :  byte    = $08;    { Idã textsz°n                   }

 _ExitButtonCode                  = $0001;  { Command k¢dok                  }
 _GoOnButtonCode                  = $0002;  { Command k¢dok                  }


 _ExitButtonString                = ' KilÇp ';   { Exit Button felirat       }
 _GoOnButtonString                = ' Start ';   { Start Button felirat      }

{****************************************************************************}
{***                               T°pusok                                ***}
{****************************************************************************}

Type
 MyButtonType   = object(ButtonType)
  Procedure DoButton;virtual;
  Procedure SetInit;virtual;
 end;

 TimeType       = object(TextType)
  TF           : boolean;
  Time         : word;
  Constructor  Init(IDd,XX,YY:word);
  Procedure    SetInit;virtual;
  Procedure    Draw;virtual;
  Procedure    Timer;virtual;
 end;

{****************************************************************************}
{***                               V†ltoz¢k                               ***}
{****************************************************************************}

Var
 ExitButton           : MyButtonType;
 GoOnButton           : MyButtonType;
 TimeText             : TimeType;

 CommandCode          : word;
 _WTime               : word;

{****************************************************************************}
{***              Halomszerkezet objektumos megval¢s°t†sa                 ***}
{****************************************************************************}
Const
 MaxHeapItemNum                   = 31; { Halom maxim†lis eleminek sz†ma     }
 IX:array [1..63] of word =(40,20,60,10,30,50,70,5,15,25,35,45,55,65,75,2,8,12,18,22,28,32,38,42,48,52,58,62,68,72,78,
                            1,3,7,9,11,13,17,19,21,23,27,29,31,33,37,39,41,43,47,49,51,53,57,59,61,63,67,69,71,73,77,79);
 IY:array [1..63] of word =(1,2,2,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
                            6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6);

Type
 MyHeapObjectType = object(HeapObjectType)
  _Exit        : boolean;
  Constructor  Init;
  Procedure    DemoShow(PTR,PAR:word);virtual;
 end;

Constructor MyHeapObjectType.Init;
Begin
Inherited Init;
_Exit:=False;
End;

Procedure MyHeapObjectType.DemoShow(PTR,PAR:word);
const dy=40;
var I:word;S:string;
Begin
If _Exit then Exit;
For I:=1 to N
 do begin
    SetColor(1);
    If I>1 then Line(IX[I]*8,IY[I]*DY,IX[I div 2]*8-2,IY[I div 2]*DY+14);
    Str(Tree[I],S);
    If I=PTR then SetColor(4) else If I=PAR then SetColor(2) else SetColor(15);
    SetTextOver(1);SetTextBackColor(BackgroundColor);ROM_8x14;
    OutStringXY(IX[I]*8-8,IY[I]*DY,S);
    end;
CommandCode:=0;
repeat TObjectProcess until (CommandCode<>0) or (SystemExitFlag);
If (CommandCode=_ExitButtonCode) or (SystemExitFlag) then _Exit:=True;
End;

{****************************************************************************}
{***                    MyButtonType objektum met¢dusai                   ***}
{****************************************************************************}

Procedure MyButtonType.DoButton;
Begin
CommandCode:=ID;
End;

Procedure MyButtonType.SetInit;
Begin
End;

{****************************************************************************}
{***                         TimeType objektum met¢dusai                  ***}
{****************************************************************************}

Constructor TimeType.Init(IDd,XX,YY:word);
Begin
Inherited Init(IDd,XX,YY,11,2,nil);
End;

Procedure TimeType.SetInit;
Begin
Chars:=1;LineSpace:=1;DY:=CDY*(8+LineSpace);
TextColor:=TimeTextColor;TextBackColor:=BackgroundColor;
End;

Procedure TimeType.Timer;
Begin
If _WTime>0 then Dec(_WTime);
Draw;
End;

Procedure TimeType.Draw;
var t:string;tt:^byte;mh:boolean;
Begin
If Time<18 then begin Inc(Time);Exit;end;
T:='C-TW '+GetTimeStr(0);
If TF then T:=T+' ' else T:=T+'.';TF:=Not(TF);
T:=T+chr(10)+GetDateStr(false)+chr(0);
TT:=@T;Inc(TT);TextPointer:=TT;mh:=false;
If (GetMouseX<X+DX+16) and (GetMouseY+16>Y) then begin mh:=true;MouseHide;end;
Inherited Draw;If MH then MouseShow;
Time:=0;
End;

{****************************************************************************}
{***                         Inicializ†l†sok                              ***}
{****************************************************************************}

Function Init_Video:word;
var I,II,JJ:byte;
Begin
If SetGraphMode(VMode)<>0 then begin Init_Video:=1;Exit;end;
ClearScreen(BackGroundColor);
SetColor(BackGroundColor);Bar(0,GetMaxY-26,GetMaxX-1,GetMaxY-1);
SetColor(DBackGroundColor);Line(0,GetMaxY-27,GetMaxX-1,GetMaxY-27);
SetColor(DDBackGroundColor);Line(0,GetMaxY-28,GetMaxX-1,GetMaxY-28);
BorderDraw_2b(2,GetMaxY-25,90,18,BackGroundColor,DBackGroundColor,LBackGroundColor);
Init_Video:=0;
End;

Function Init_Mouse:byte;
Begin
If MouseInit(MouseAct,PixRat,MDVX,MDVY)=0
   then Init_Mouse:=1
   else begin Init_Mouse:=0;MouseShow;end;
End;

Procedure VideoDone;
Begin
Asm mov  ax,0003h;int 10h End;
WriteLn(ProgramName);
End;

{****************************************************************************}
{***                  Objektumok inicializ†l†sa/lez†r†sa                  ***}
{****************************************************************************}

Procedure ObjectInit;
Begin
GoOnButton.Init(_GoOnButtonCode,GetMaxX-132,GetMaxY-24,_GoOnButtonString);
ExitButton.Init(_ExitButtonCode,GetMaxX-66,GetMaxY-24,_ExitButtonString);
TimeText.Init(0,6,GetMaxY-21);TimeText.Time:=20;
SetTimer(1,1,0,0,Seg(TimeText),Ofs(TimeText));
End;

Procedure ObjectDone;
Begin
SetTimer(1,0,0,0,0,0);
TimeText.Done;
ExitButton.Done;
GoOnButton.Done;
End;

{****************************************************************************}
{***                     Inicializ†l†s/lez†r†s                            ***}
{****************************************************************************}

Procedure Init;
Begin
If Init_Video<>0
   then begin WriteLn('Nem sikerÅlt a videom¢d inicializ†l†sa!');Halt;end;
Init_Mouse;
ObjectInit;
End;

Procedure Done;
Begin
ObjectDone;
VideoDone;
End;

{****************************************************************************}
{***                             Fãprogram                                ***}
{****************************************************************************}

Procedure HalomEpit;
var H:MyHeapObjectType;I:word;
Begin
SetColor(BackgroundColor);MouseHide;Bar(0,0,GetMaxX-1,GetMaxY-30);MouseShow;
H.Init;ClearCommandPuffer;CommandCode:=0;I:=1;
while (I<=MaxHeapItemNum) and (not SystemExitFlag) and (CommandCode<>_ExitButtonCode) do
  begin H.DemoInsert(random(89)+10);H.DemoShow(0,0);I:=I+1;end;
H.Done;
End;

Procedure Main;
var I:byte;
Begin
ClearCommandPuffer;I:=0;
repeat
      Case I of
           0 : begin end;
           1 : begin CommandCode:=0;GoOnButton.SetKeyFocus;end;
           2 : repeat TObjectProcess until (CommandCode=_GoOnButtonCode) or (CommandCode=_ExitButtonCode) or (SystemExitFlag);
           3 : Case CommandCode of
                    _GoOnButtonCode : begin
                                      HalomEpit;
                                      end;
                    end;
           end;
      Inc(I);If I>4 then I:=1;
until (CommandCode=_ExitButtonCode) or (SystemExitFlag);
End;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}

BEGIN
Init;
TProcOn;
Main;
TProcOff;
Done;
END.