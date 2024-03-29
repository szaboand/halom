Unit TWSys;
{****************************************************************************}
{***                                                                      ***}
{***                     Turbo Pascal TWSystem Unit                       ***}
{***                            1.2a Verzi�                               ***}
{***                                                                      ***}
{***               (C) TwinNet 1998  (P) Szab� Andr�s 1997/98             ***}
{***                                                                      ***}
{***                      1997.02.16.  - 200.01.07.                      ***}
{***                                                                      ***}
{*** - TG_16.ASM    1.8 verzi� (C) TwinNet (P) Szab� Andr�s 1996 Budapest ***}
{*** - TG_256.ASM   1.8 verzi� (C) TwinNet (P) Szab� Andr�s 1996 Budapest ***}
{*** - TPROC.ASM    1.7 verzi� (C) TwinNet (P) Szab� Andr�s 1996 Budapest ***}
{***                                                                      ***}
{****************************************************************************}

Interface

Type
    T_SVGAInfo = record
                 VESAFlag     : array [0..3] of byte;  { VESA azonos�t�   }
                 Version      : word;                  { VESA verzi� sz�m }
                 OEMName      : array [0..1] of word;  { OEM n�v pointer  }
                 Flag         : array [0..3] of byte;  { K�pess�gek       }
                 ModesPointer : array [0..1] of word;  { VESA es OEM modok list�j�nak mutat�ja }
                 VideoMem     : word;                  { Video mem�ria m�rete 64 Kbyte-ban     }
                 Reserved     : array [0..235] of byte;
                  end;

    T_VESAInfo = record
          { 00 } VESAMode       : word;  { M�d jellemz�k
                                           15..5: Nem haszn�lt 4:Grafikus m�d
                                           3:Szines m�d 2:Karakter kivitel be�p�tve
                                           1:Kieg�sz�t� inform�ci� van 0:a m�d be�ll�that�        }
          { 02 } Window_A       : byte;  { A ablak jellemz�i 2:�rhat� 1:olvashat� 0:megval�s�tott }
          { 03 } Window_B       : byte;  { B ablak jellemz�i 2:�rhat� 1:olvashat� 0:megval�s�tott }
          { 04 } Window_MoveMem : word;  { Legkisebb l�p�s az ablak mozgathat�s�g�ra Kbyte-ban    }
          { 06 } Window_Mem     : word;  { Ablak m�rete Kbyte-ban                                 }
          { 08 } Window_A_Seg   : word;  { A ablak szegmenscime                                   }
          { 0A } Window_B_Seg   : word;  { B ablak szegmenscime                                   }
          { 0C } WindowPointer  : array [0..1] of word; { Ablakkezel� f�ggv�ny mem�riac�me        }
          { 10 } LogicalSize    : word;  { Sorok m�rete byte-ban                                  }
          { 12 } Size_X         : word;  { Sz�less�g - V�zszintes felbont�s }
          { 14 } Size_Y         : word;  { Magass�g  - F�gg�leges felbontas }
          { 16 } CharSize_X     : byte;  { Karakterek sz�less�ge pixelben   }
          { 17 } CharSize_Y     : byte;  { Karakterek magass�ga  pixelben   }
          { 18 } BitPlane       : byte;  { Mem�ria lapok ( Bitsikok ) sz�ma }
          { 19 } PixelBit       : byte;  { Egy k�pponthoz tartoz� bitek sz�ma }
          { 1A } Page           : byte;  { Mem�rialapok sz�ma               }
          { 1B } MemModell      : byte;  { Mem�ria szervez�se
                                           0:Sz�veges 1:CGA 2:Herc
                                           3:4 bitsikos 4:Csomagolt pixeles
                                           5:Sequ 256(nem l�ncolt 4)
                                           6:HiColor (24bit) 08..0f VESA
                                           19-ff OEM                        }
          { 1C } PageMem         : byte; { A mem�rialap m�rete Kbyte-ban    }
          { 1D } PageNum         : byte; { A megjelen�t� lapok sz�ma        }
          { 1E } Reserved        : byte; { 0 }
          { 1F } Protected       : array [0..239] of byte;
                 end;

    T_VideoMode = record
                  ModeNum        : word; { Vide�m�d k�dja                    }
                  ModeType       : byte; { Vide�m�d t�pusa
                                           0:VGA 1:VESA 2:Nem szabv�ny VGA   }
                  MemType        : byte; { Mem�ria szervez�s
                                           0:Sz�veges    1:4 BitPlane
                                           2:Byte/pixel  3:32K
                                           4:64K         5:HiColor (24bit)   }
                  MaxX           : word; { Max X koordin�ta                  }
                  MaxY           : word; { Max Y koordin�ta                  }
                  MaxC           : longint; { Max szinek sz�ma               }
                  LSize          : word; { Logikai sz�less�g byte-ban        }
                  BitPixel       : word; { Egy pixelt le�r� bitek sz�ma      }
                  end;

    TGraph_CharsType    = record
                 CharY      : word; { Karakter magass�ga pixelben            }
                 CharX      : word; { Karakter sz�lesss�ge pixelben          }
                 CharXbyte  : word; { Karakter sz�less�ge byteban            }
                 CharByte   : word; { Karaktert le�r� byteok sz�ma           }
                 CharGenSeg : word; { Karakter gener�tor szegmensc�me        }
                 CharGenOfs : word; { Karakter gener�tor ofsetc�me           }
                 end;

     CommandType        = record
                 CommandType   : word; { Command t�pus
                                         0: Nincs
                                         1: Eg�r
                                         2: Billenty�
                                         3: Id�z�t�                         }
                 CommandCode   : word; { Command k�dja                      }
                 Mouse_X       : word; { Eg�r X koodrdin�ta                 }
                 Mouse_Y       : word; { Eg�r Y koodrdin�ta                 }
                 Mouse_B       : word; { Eg�r gomb                          }
                 Parameter1    : word; { Param�ter 1                        }
                 Parameter2    : word; { Param�ter 2                        }
                 KeyCode       : word; { Billenty� k�d                      }
                 KeyTable      : array[0..15] of byte;{Billenty�zet t�bl�zat}
                 end;


Const
   _320x200_16            = $0001;     { Videom�dok k�djai                   }
   _320x240_16            = $0002;
   _320x350_16            = $0003;
   _320x400_16            = $0004;
   _320x480_16            = $0005;
   _640x200_16            = $0006;
   _640x240_16            = $0007;
   _640x350_16            = $0008;
   _640x400_16            = $0009;
   _640x480_16            = $000A;
   _720x400_16            = $000B;
   _720x480_16            = $000C;
   _800x600_16            = $000D;
   _1024x768_16           = $000E;
   _1280x1024_16          = $000F;
   _320x200_256           = $0010;
   _640x400_256           = $0011;
   _640x480_256           = $0012;
   _800x600_256           = $0013;
   _1024x768_256          = $0014;
   _1280x1024_256         = $0015;

   _MouseType             = $0001;
   _KeyType               = $0002;
   _TimerType             = $0003;

   _Key_Push              = $0001;
   _Key_Pop               = $0002;

   _Mouse_Move            = 3;
   _MouseLeftButton_Push  = 8;
   _MouseLeftButton_Pop   = 16;
   _MouseMiddleButton_Push= 128;
   _MouseMiddleButton_Pop = 256;
   _MouseRightButton_Push = 32;
   _MouseRightButton_Pop  = 64;

   MouseDivX              : byte        = $0000; { Mouse X eltol�s (SHR)     }
   MouseDivY              : byte        = $0000; { Mouse Y eltol�s (SHR)     }
   OldMouseX              : word        = $0000;
   OldMouseY              : word        = $0000;
   NoMouse                : word        = $0001; { 0/1: Mouse l�tszik/nem    }

   TWSysCopyright                       = '(C) TwinNet Ltd. 1997,98';

Var
   V_SVGAInfo             : T_SVGAInfo;   { SVGA info                        }
   V_VESAInfo             : T_VESAInfo;   { VESA info                        }
   V_VESAGran             : word;         { VESA lapoz�s                     }
   V_VESAPresent          : boolean;      { VESA meghajt� jelenl�te          }
   V_ActMode              : T_VideoMode;  { Aktu�lis videom�d                }
   IOError                : word;         { File hibajelz�                   }

{****************************************************************************}
{***             Grafikus video m�d be�ll�t�sa/lek�rdez�se                ***}
{****************************************************************************}

Function  SetGraphMode(Mode:word):word;
Procedure SetVideoMem(XX,YY:word);
Procedure SetRelCord(XX,YY:word);
Function  GetRelX:word;
Function  GetRelY:word;
Procedure WaitPic;

Function  GetMode:word;
Function  GetMaxX:word;
Function  GetMaxY:word;
Function  GetMaxColor:longint;

{****************************************************************************}
{***                     Grafikus video m�d elj�r�sai                     ***}
{****************************************************************************}

Procedure ClearScreen(Color:byte);
Procedure PutPixel(X,Y:word;C:byte);
Function  GetPixel(X,Y:word):byte;
Procedure Line(X1,Y1,X2,Y2:word);
Procedure Rectangle(X1,Y1,X2,Y2:word);
Procedure Bar(X1,Y1,X2,Y2:word);
Procedure CopyBlock(X1,Y1,X2,Y2,DXx,DYy:word);
Procedure CopyFromMem(X1,Y1,DXx,DYy,MDx:word;var Dst);
Procedure CopyToMem(X1,Y1,DXx,DYy,MDx:word;var Src);
Function  GetActPage:byte;
Procedure SetActPage(PG:word);

{Procedure Circle(X,Y,Radius:word);      { V1.2a elj�r�s }
{Procedure Fill(X,Y:word;FillColor,Border:byte); { V1.2a elj�r�s }

{****************************************************************************}
{***                        Sz�nkezel� elj�r�sok                          ***}
{****************************************************************************}

Procedure SetColor(Color:byte);
Procedure SetTextBackColor(Color:byte);
Procedure SetTextOver(Over:byte);
Procedure SetBorder(C:byte);
Procedure SetRGBreg(RegNum,Red,Green,Blue:byte);
Procedure GetRGBreg(RegNum:byte; var RGB );
Procedure SetPalette(e,f:word;var t);
Procedure GetPalette(e,f:word;var t);

{****************************************************************************}
{***       Sz�veg ki�r� / Karakter be�ll�t�/lek�rdez�  elj�r�sokok        ***}
{****************************************************************************}

Procedure OutTextXY(X,Y:word;var S);
Procedure OutStringXY(X,Y:word;S:string);
Procedure ROM_8x8;
Procedure ROM_8x14;
Procedure ROM_8x16;
Function  GetCharX:word;
Function  GetCharY:word;
Procedure GetChars(var TGCh:TGraph_CharsType);
Procedure SetChars(var TGCh:TGraph_CharsType);

{****************************************************************************}
{***                   Speci�lis keretrajzol� elj�r�sok                   ***}
{****************************************************************************}

Procedure BorderDraw_1a(x1,y1,dx,dy:word;col,sot,vil:byte);
Procedure BorderDraw_1b(x1,y1,dx,dy:word;col,sot,vil:byte);
Procedure BorderDraw_2a(x1,y1,dx,dy:word;col,sot,vil:byte);
Procedure BorderDraw_2b(x1,y1,dx,dy:word;col,sot,vil:byte);
Procedure BorderDraw_3(x1,y1,dx,dy:word;col,sot,vil:byte);

{****************************************************************************}
{***                   K�perny� be/kikapcsol� elj�r�sok                   ***}
{****************************************************************************}

Procedure PictureOff;
Procedure PictureOn;

{****************************************************************************}
{***                           Eg�rkezel�s                                ***}
{****************************************************************************}

Function  MouseInit(Ma:boolean;PR:word;MDVX,MDVY:byte):word;
Procedure MouseShow;
Procedure MouseHide;
Function  GetMouseX:word;
Function  GetMouseY:word;
Function  GetMouseButton:byte;
Procedure SetMousePos(X,Y:word);
Procedure SetMouseArea(X1,Y1,X2,Y2:word);
Procedure SetMousePointer(Ddx,Ddy:integer; var Src);
Procedure SetNoMouseArea(X1,Y1,X2,Y2:word);
Procedure SetMouseResolution(Rx,Ry:word);
Procedure SetMouseFunction(Mask:word;Proc:pointer);
Procedure SetMouseShape(dDx,dDy:integer;var Src);
Function  GetMouseAct:boolean;


{****************************************************************************}
{***                     File kezel� elj�r�sok                            ***}
{****************************************************************************}

Function  OpenFile(FNev:string;OpenMode:byte):word;      { File megnyitas    }
Function  ReadFile(FHandle:word;var D;Size:word):word;   { File-bol olvasas  }
Function  WriteFile(FHandle:word;var D;Size:word):word;  { File-ba iras      }
Procedure SeekFile(FHandle:word;Pos:longint;From:byte);  { File pozicionalas }
Procedure CloseFile(FHandle:word);                       { File lezaras      }

{****************************************************************************}
{***                        XMS kezel� elj�r�sok                          ***}
{****************************************************************************}

Function  InitXMS:boolean;
Function  GetXMS(Meret:word;var Handle:word):byte;
Function  FreeXMS(Handle:word):byte;
Function  MoveXMS(Meret:longint;st,soff,sg,dt,doff,dg:word):byte;
Function  MaxXMSMem:word;
Function  MaxXMSMemBlock:word;
Function  LoadFileToXMS(Filenev:string;Handle,PufferMeret:word):word;

{****************************************************************************}
{***                        Egy�b ej�r�sok                                ***}
{****************************************************************************}

Procedure GetTime(var Ora,Perc,Mp,Szmp:word); { Rendszerindo lekerdezes     }
Procedure GetDate(var Ev,Ho,Nap,NapHet:word); { Rendszerdatun lekerdezes    }
Function  GetTimeStr(l:byte):string;          { Rendszerid� string          }
Function  GetDateStr(l:boolean):string;       { Rendszerd�tum string        }
Function  WindowsPresent:word;                { Windows ellen�r             }
Procedure Wait(WTime:word);                   { V�rakoz�s                   }
Function  GetTimeCounter:word;                { Id�sz�ml�l� null�z�sa       }
Procedure ResetTimeCounter;                   { Id�sz�ml�l� lek�rdez�se     }
Procedure SetTimerCount(cnt:word);            { Id�z�t� be�ll�t�s           }

{****************************************************************************}
{****************************************************************************}
{***                        TProc elj�r�sok                               ***}
{****************************************************************************}
{****************************************************************************}

Procedure TProcON;
Procedure TProcOff;
Function  GetCommand(var _C:CommandType):word;
Function  PutCommand(CommandType,CommandCode,Prior,P1,P2:word):word;
Procedure SetTimer(TimeNum,Time,Command,Prior,P1,P2:word);
Procedure ClearCommandPuffer;
Procedure TProcInfo;
Procedure SetTProcFlag(Flg:word);
Procedure SetTimerNum(cnt:word);
Procedure SetMouseEvent(SSeg,OOfs:word);

{****************************************************************************}
{****************************************************************************}
{***                     Speaker kezel� elj�r�sok                         ***}
{****************************************************************************}
{****************************************************************************}

Procedure SpeakerOn;
Procedure SpeakerOff;
Procedure SetSpeakerFreq(Hz:word);

{****************************************************************************}
{****************************************************************************}
{***                     CMOS kezel� elj�r�sok                            ***}
{****************************************************************************}
{****************************************************************************}

Function  CMOSread(Adr:byte):byte; { Egy CMOS b�jt olvas�sa }
Procedure CMOSwrite(Adr,Dat:byte); { Egy CMOS b�jt �r�sa    }

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}

Implementation

{$I TWFILE.INC  }
{$I TWMISC.INC  }
{$I TWPROC.INC  }
{$I TWVIDEO.INC }
{$I TWXMS.INC   }

{****************************************************************************}
{****************************************************************************}
{***                                                                      ***}
{***                            TWSys End                                 ***}
{***                                                                      ***}
{****************************************************************************}
{****************************************************************************}


BEGIN
If _GetSVGAInfo=$004F then V_VESAPresent:=true else V_VESAPresent:=false;
IOError:=0;
InitXMS;
END.