Unit HEAP;

{****************************************************************************}
{***                                                                      ***}
{***                        Halomszerkezet Unit                           ***}
{***                            1.0a Verzi¢                               ***}
{***               (C) TwinNet 2000  (P) Szab¢ Andr s 2000                ***}
{***                      2000.01.18.  - 2000.01.18.                      ***}
{***                                                                      ***}
{****************************************************************************}

Interface

{****************************************************************************}
{***              Halomszerkezet t¡pusok,konstansok,v ltoz¢k              ***}
{****************************************************************************}

Type
 HeapItemType   = word;                            { Halom csom¢pont t¡pusa  }
 LinHeapType    = array [1..1000] of HeapItemType; { Line ris halomszerkezet }

{****************************************************************************}
{***              Halomszerkezet objektumos megval¢s¡t sa                 ***}
{****************************************************************************}

Type
 HeapObjectType = object
  TREE            : LinHeapType;
  N               : word;
  Constructor Init;
  Destructor  Done;
  Procedure   DemoShow(PTR,PAR:word);virtual;
  Function    DemoInsert(ITEM:HeapItemType):word; virtual;
 end;

{****************************************************************************}
{***              Halomszerkezet algorimusok interf‚sze                   ***}
{****************************************************************************}

Procedure InsertHeap(var TREE:LinHeapType;var N:word;ITEM:HeapItemType);

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}

Implementation

{****************************************************************************}
{***                   Halomszerkezet algoritmusok                        ***}
{****************************************************************************}

Procedure InsertHeap(var TREE:LinHeapType;var N:word;ITEM:HeapItemType);
var PTR,PAR:word;
Begin
 N:=N+1;PTR:=N;PAR:=N div 2;
 While (PAR>0) and (TREE[PAR]<ITEM) do
  begin
   TREE[PTR]:=TREE[PAR];
   PTR:=PAR;PAR:=PTR div 2;
  end;
 TREE[PTR]:=ITEM;
End;

{****************************************************************************}
{***               Halomszerkezet objektumos megval¢s¡t sa                ***}
{****************************************************************************}

Constructor HeapObjectType.Init;
Begin
N:=0;
End;

Destructor HeapObjectType.Done;
Begin
N:=0;
End;

Procedure HeapObjectType.DemoShow(PTR,PAR:word);
Begin
End;

Function HeapObjectType.DemoInsert(ITEM:HeapItemType):word;
var PTR,PAR:word;TMP:HeapItemType;
Begin
 N:=N+1;TREE[N]:=ITEM;DemoShow(N,0);
 PTR:=N;PAR:=N div 2;DemoShow(PTR,PAR);
 While (PAR>0) and (TREE[PAR]<TREE[PTR]) do
  begin
   TMP:=TREE[PTR];TREE[PTR]:=TREE[PAR];TREE[PAR]:=TMP;DemoShow(PAR,PTR);
   PTR:=PAR;PAR:=PTR div 2;DemoShow(PTR,PAR);
  end;
End;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}

BEGIN
END.