unit AOCSolutions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Generics.Defaults, System.Generics.Collections,
  system.Diagnostics, AOCBase, RegularExpressions, System.DateUtils, system.StrUtils,
  system.Math, uAOCUtils, system.Types, IdHashMessageDigest, System.Character;

type
  TAdventOfCodeDay1 = class(TAdventOfCode)
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TCalculation = function(Const x,y,z: integer):integer of object;
  TAdventOfCodeDay2 = class(TAdventOfCode)
  private
    function CalculateWrappingPaper(Const x,y,z: integer):integer;
    function Calculateribbon(Const x,y,z: integer):integer;
    function Calculate(aCalculation: TCalculation): Integer;
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

type
  TAdventOfCodeDay3 = class(TAdventOfCode)
  private
    function DeliverPresents(Const UseRoboSanta: Boolean): integer;
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAdventOfCodeDay4 = class(TAdventOfCode)
    function CalculateHashes(Const aExpetedStart: String): integer;
  protecteD
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TIsNiceString = function(Const aString: String): Boolean of object;
  TAdventOfCodeDay5 = class(TAdventOfCode)
  private
    function CheckStrings(aCheck: TIsNiceString): integer;
    function IsNaughtyA(Const aString: String): Boolean;
    function IsNaughtyB(Const aString: String): Boolean;
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TLightEvent = procedure(Lights: TDictionary<TPoint,Integer>; Const aPoint: TPoint; Const SwitchOn: boolean) of object;
  TAdventOfCodeDay6 = class(TAdventOfCode)
  private
    function SwitchLights(Const OnToggle, OnSwitch: TLightEvent): TDictionary<TPoint, Integer>;
    procedure ToggleA(Lights: TDictionary<TPoint,Integer>; Const aPoint: TPoint; Const SwitchOn: boolean);
    procedure SwitchA(Lights: TDictionary<TPoint,Integer>; Const aPoint: TPoint; Const SwitchOn: boolean);
    procedure ToggleB(Lights: TDictionary<TPoint,Integer>; Const aPoint: TPoint; Const SwitchOn: boolean);
    procedure SwitchB(Lights: TDictionary<TPoint,Integer>; Const aPoint: TPoint; Const SwitchOn: boolean);
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAdventOfCodeDay7 = class(TAdventOfCode)
  private
    function RunProgram(Const OverrideB: Word): Integer;
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAdventOfCodeDay8 = class(TAdventOfCode)
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAdventOfCodeDay9 = class(TAdventOfCode)
  private
    Distances: TDictionary<string, Integer>;
    Places: TList<String>;
    function FindeBestRoute(Const MaxDistance: Boolean): Integer;
  protected
    procedure BeforeSolve; override;
    procedure AfterSolve; override;
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAdventOfCodeDay10 = class(TAdventOfCode)
  private
    SentanceA: string;
    function Talk(Const StartSentacne: String; Const Repeats: Integer): string;
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;
(*
  TAdventOfCodeDay = class(TAdventOfCode)
  protected
    procedure BeforeSolve; override;
    procedure AfterSolve; override;
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;
*)

implementation

{$Region 'TAdventOfCodeDay1'}
function TAdventOfCodeDay1.SolveA: Variant;
begin
  Result := OccurrencesOfChar(FInput[0], '(') - OccurrencesOfChar(FInput[0], ')') //74
end;

function TAdventOfCodeDay1.SolveB: Variant;
var Floor: Integer;
begin
  Floor := 0;
  Result := 0;
  while Floor >= 0 do
  begin
    Floor := Floor + IfThen(FInput[0][integer(Result+1)] = '(', 1, -1);
    Inc(Result); //1795
  end;
end;
{$ENDREGION}
{$Region 'TAdventOfCodeDay2'}
function TAdventOfCodeDay2.SolveA: Variant;
begin
  Result := Calculate(CalculateWrappingPaper); //1598415
end;

function TAdventOfCodeDay2.SolveB: Variant;
begin
  Result := Calculate(Calculateribbon); //3812909
end;

function TAdventOfCodeDay2.Calculate(aCalculation: TCalculation): Integer;
var s: string;
    Split: TStringDynArray;
begin
  Result := 0;
  for s in FInput do
  begin
    Split := SplitString(s, 'x');
    Result := Result + aCalculation(StrToInt(Split[0]),StrToInt(Split[1]),StrToInt(Split[2]));
  end;
end;

function TAdventOfCodeDay2.CalculateWrappingPaper(Const x,y,z: integer):integer;
begin
  Result := 2*x*y + 2*x*z + 2*y*z + Min(Min(x*y,x*z),y*z);
end;

function TAdventOfCodeDay2.Calculateribbon(Const x,y,z: integer):integer;
begin
  Result := 2*(x+y+z-Max(Max(x,y),z)) + x*y*z;
end;
{$ENDREGION}
{$Region 'TAdventOfCodeDay3'}
function TAdventOfCodeDay3.SolveA: Variant;
begin
  Result := DeliverPresents(False); //2081
end;

function TAdventOfCodeDay3.SolveB: Variant;
begin
  Result := DeliverPresents(True); //2341
end;

function TAdventOfCodeDay3.DeliverPresents(Const UseRoboSanta: Boolean): integer;
var PositionSanta, PositionRobo, Temp: TPosition;
    Seen: TDictionary<TPosition,integer>;
    c: char;
    IsSanta: Boolean;
begin
  PositionSanta := PositionSanta.SetIt(0,0);
  PositionRobo := PositionRobo.SetIt(0,0);

  IsSanta := True;
  Seen := TDictionary<TPosition,integer>.Create;
  try
  for c in FInput[0] do
    begin
      if IsSanta then
        Temp := PositionSanta
      else
        Temp := PositionRobo;

      Seen.AddOrSetValue(Temp, 1);

      Case AnsiIndexStr(c,[ '^','>','v','<']) of
        0: Temp := Temp.ApplyDirection(Up);
        1: Temp := Temp.ApplyDirection(Right);
        2: Temp := Temp.ApplyDirection(Down);
        3: Temp := Temp.ApplyDirection(Left)
      End;

      if IsSanta then
        PositionSanta := Temp
      else
        PositionRobo := Temp;

      IsSanta := (not IsSanta) or (not UseRoboSanta);
    end;
    Result := Seen.Count;
  finally
    Seen.Free;
  end;
end;
{$ENDREGION}
{$Region 'TAdventOfCodeDay4'}
function TAdventOfCodeDay4.SolveA: Variant;
begin
  Result := CalculateHashes('00000'); //282749
end;

function TAdventOfCodeDay4.SolveB: Variant;
begin
  Result := CalculateHashes('000000'); //9962624
end;

function TAdventOfCodeDay4.CalculateHashes(Const aExpetedStart: String): integer;
var
  pMD5: TIdHashMessageDigest5;
begin
  Result := 1;
  pMD5 := TIdHashMessageDigest5.Create;
  try
    while true do
    begin
      if pMD5.HashStringAsHex(FInput[0]+IntToStr(Result)).StartsWith(aExpetedStart) then
        Exit;
      inc(result);
    end;
  finally
    pMD5.Free;
  end;
end;
{$ENDREGION}
{$Region 'TAdventOfCodeDay5'}
function TAdventOfCodeDay5.SolveA: Variant;
begin
  Result := CheckStrings(IsNaughtyA); //255
end;

function TAdventOfCodeDay5.SolveB: Variant;
begin
  Result := CheckStrings(IsNaughtyB); //55
end;

function TAdventOfCodeDay5.CheckStrings(aCheck: TIsNiceString): integer;
var s: string;
begin
  Result := 0;
  for s in FInput do
    if aCheck(s) then
      Inc(Result);
end;

function TAdventOfCodeDay5.IsNaughtyA(Const aString: String): Boolean;
var i: integer;
begin
  Result := False;

  i := OccurrencesOfChar(aString, 'a') + OccurrencesOfChar(aString, 'i') + OccurrencesOfChar(aString, 'o')
     + OccurrencesOfChar(aString, 'u') + OccurrencesOfChar(aString, 'e');

  if i >= 3 then
    if (Pos('ab', aString) + Pos('cd', aString) + Pos('pq', aString) + Pos('xy', aString)) = 0  then
      for i := ord('a') to ord('z') do
      if pos(chr(i)+ chr(i), aString)> 0 then
        Exit(True);
end;

function TAdventOfCodeDay5.IsNaughtyB(Const aString: String): Boolean;
var i, j, k: integer;
    Valid: boolean;
begin
  Result := False;

  Valid := false;
  for i := 0 to Length(aString)-2 do
    if aString[i] = aString[i+2] then
    begin
      Valid := true;
      break;
    end;

  if Valid then
    for i := ord('a') to ord('z') do
    begin
      for j := ord('a') to ord('z') do
      begin
        k := Pos(chr(i)+chr(j), aString);
        if Pos(chr(i)+chr(j), aString, k+2) > 0 then
          Exit(true)
      end;
   end;
end;
{$ENDREGION}
{$Region 'TAdventOfCodeDay6'}
function TAdventOfCodeDay6.SolveA: Variant;
Var Lights: TDictionary<TPoint, integer>;
begin
  Lights := SwitchLights(ToggleA, SwitchA);
  Result := Lights.Count; //543903
  Lights.Free;
end;

function TAdventOfCodeDay6.SolveB: Variant;
Var Lights: TDictionary<TPoint, integer>;
    i: integer;
begin
  Lights := SwitchLights(ToggleB, SwitchB);
  Result := 0;
  for i in Lights.Values do
    Inc(Result, i); //14687245
  Lights.Free;

end;

function TAdventOfCodeDay6.SwitchLights(Const OnToggle, OnSwitch: TLightEvent): TDictionary<TPoint, Integer>;

  procedure _InternalSwitchLights(aEvent: TLightEvent; aStart, aStop: string; aSwitchOn: Boolean);
  var split: TStringDynArray;
      x, x1, x2, y, y1, y2: integer;
      Point: TPoint;
  begin
    split := SplitString(aStart, ',');
    x1 := StrToInt(Split[0]);
    y1 := StrToInt(Split[1]);
    split := SplitString(aStop, ',');
    x2 := StrToInt(Split[0]);
    y2 := StrToInt(Split[1]);

    for x := x1 to x2 do
      for y := y1 to y2 do
      begin
        Point := TPoint.Create(x,y);
        aEvent(Result, Point, aSwitchOn);
      end;
  end;

var s: String;
    Split: TStringDynArray;
begin
  Result := TDictionary<TPoint, Integer>.Create;
  for s in FInput do
  begin
    Split := SplitString(s, ' ');
    if SameText(Split[0], 'toggle' ) then
      _InternalSwitchLights(OnToggle, split[1], split[3], False{Not used})
    else if SameText(Split[0], 'turn') then
      _InternalSwitchLights(OnSwitch, split[2], split[4], Split[1] = 'on')
    else
      WriteLn('Unknown command: ', Split[0]);
  end;
end;

procedure TAdventOfCodeDay6.ToggleA(Lights: TDictionary<TPoint,Integer>; Const aPoint: TPoint; Const SwitchOn: boolean);
begin
  if Lights.ContainsKey(aPoint) then
    Lights.Remove(aPoint)
  else
    Lights.Add(aPoint, 1);
end;

procedure TAdventOfCodeDay6.SwitchA(Lights: TDictionary<TPoint,Integer>; Const aPoint: TPoint; Const SwitchOn: boolean);
begin
  if SwitchOn then
    Lights.AddOrSetValue(aPoint, 1)
  else
    Lights.Remove(aPoint);
end;

procedure TAdventOfCodeDay6.ToggleB(Lights: TDictionary<TPoint,Integer>; Const aPoint: TPoint; Const SwitchOn: boolean);
var i: integer;
begin
  Lights.TryGetValue(aPoint, i);
  Lights.AddOrSetValue(aPoint, i+2);
end;

procedure TAdventOfCodeDay6.SwitchB(Lights: TDictionary<TPoint,Integer>; Const aPoint: TPoint; Const SwitchOn: boolean);
var i: Integer;
begin
  Lights.TryGetValue(aPoint, i);
  if SwitchOn then
    Inc(i)
  else
    i := Max(0, i-1);

  Lights.AddOrSetValue(aPoint, i);
end;

{$ENDREGION}
{$Region 'TAdventOfCodeDay7'}
function TAdventOfCodeDay7.SolveA: Variant;
begin
  Result := RunProgram(0); //956
end;

function TAdventOfCodeDay7.SolveB: Variant;
begin
  Result := RunProgram(RunProgram(0)); //40149
end;

function TAdventOfCodeDay7.RunProgram(Const OverrideB: Word): Integer;
var Wires: TDictionary<String,Word>;

  function TryGetWireValue(Const aInput: string; out Value: Word): Boolean;
  var i: integer;
  begin
    Result := (TryStrToInt(aInput, i) or Wires.TryGetValue(aInput, Value));
    if Result and not Wires.ContainsKey(aInput) then
      Value := i;
  end;

Var Input: TList<String>;
    s: string;
    Split: TStringDynArray;
    wrd1, wrd2: Word;
begin
  Input := TList<string>.Create;
  Wires := TDictionary<String,Word>.Create;

  try
    for s in FInput do
      Input.Add(s);

    while Input.Count > 0 do
    begin
      for s in Input do
      begin
        Split := SplitString(s, ' ');
        if SameText(Split[1], 'AND') and TryGetWireValue(Split[0], wrd1) and TryGetWireValue(Split[2], wrd2) then
          Wires.Add(Split[4], wrd1 and wrd2)
        else if SameText(Split[1], 'OR') and TryGetWireValue(Split[0], wrd1) and TryGetWireValue(Split[2], wrd2) then
          Wires.Add(Split[4], wrd1 or wrd2)
        else if SameText(Split[1], 'LSHIFT') and TryGetWireValue(Split[0], wrd1) and TryGetWireValue(Split[2], wrd2) then
          Wires.Add(Split[4], wrd1 shl wrd2)
        else if SameText(Split[1], 'RSHIFT') and TryGetWireValue(Split[0], wrd1) and TryGetWireValue(Split[2], wrd2) then
          Wires.Add(Split[4], wrd1 shr wrd2)
        else if SameText(Split[0], 'NOT') and Wires.TryGetValue(Split[1], wrd1) then
          Wires.Add(Split[3], Not wrd1)
        else if SameText(Split[1], '->') and TryGetWireValue(Split[0], wrd1) then
        begin
          if (Split[2] = 'b') and (OverrideB > 0) then
            wrd1 := OverrideB;

          Wires.Add(Split[2], wrd1);
        end
        else
          Continue;

        Input.Remove(s);
      end;
    end;


  finally
    Result := Wires['a'];
    Input.Free;
    Wires.Free;
  end;
end;
{$ENDREGION}
{$Region 'TAdventOfCodeDay8'}
function TAdventOfCodeDay8.SolveA: Variant;
var s, temps: string;
begin
  Result := 0;
  for s in FInput do
  begin
    temps := s;
    temps := StringReplace(temps, '\\', 'X', [rfReplaceAll]);
    temps := StringReplace(temps, '\"', 'X', [rfReplaceAll]);
    temps := StringReplace(temps, '"', '', [rfReplaceAll]);
    Result := Result + Length(s) - Length(Temps) + OccurrencesOfChar(temps, '\x')*3 //1371
  end;
end;

function TAdventOfCodeDay8.SolveB: Variant;
var s: string;
    Added: integer;
begin
  Result := 0;
  for s in FInput do
  begin
    Added := Length(StringReplace(s, '\', '\\', [rfReplaceAll])) - Length(s);
    Added := Added + Length(StringReplace(s, '"', '\\', [rfReplaceAll])) - Length(s);
    Result := Result + Added + 2;
  end;

end;
{$ENDREGION}
{$Region 'TAdventOfCodeDay9'}
procedure TAdventOfCodeDay9.BeforeSolve;
Var s: string;
    Split: TStringDynArray;
begin
  Places := TList<String>.Create;
  Distances := TDictionary<string, Integer>.Create;

  for s in FInput do
  begin
    Split := SplitString(s, ' ');
    if not Places.Contains(Split[0]) then
      Places.Add(Split[0]);
    if not Places.Contains(Split[2]) then
      Places.Add(Split[2]);

    Distances.Add(Split[0] + Split[2], Split[4].ToInteger);
    Distances.Add(Split[2] + Split[0], Split[4].ToInteger);
  end;

end;

procedure TAdventOfCodeDay9.AfterSolve;
begin
  Distances.Free;
  Places.Free;
end;

function TAdventOfCodeDay9.FindeBestRoute(Const MaxDistance: Boolean): Integer;

    procedure CheckPlaces(Const DistanceTraveld: Integer; Const CurrentPlace: String; aSeen: TList<string>);
    var Place: string;
        Distance: Integer;
    begin
      if aSeen.Count = Places.Count then
      begin
        if MaxDistance then
          Result := Max(Result, DistanceTraveld)
        else
          Result := Min(Result, DistanceTraveld);
        Exit;
      end;

      for Place in Places do
        if not aSeen.Contains(Place) then
        begin
          aSeen.Add(Place);
          Distances.TryGetValue(CurrentPlace+Place, Distance);
          CheckPlaces(DistanceTraveld + Distance, Place, aSeen);
          aSeen.Remove(Place);
        end;
    end;

var Seen: TList<String>;
begin
  Seen := TList<String>.Create;

  if MaxDistance then
    Result := 0
  else
    Result := MaxInt;

  CheckPlaces(0, '', Seen);

  Seen.Free;
end;

function TAdventOfCodeDay9.SolveA: Variant;
begin
  Result := FindeBestRoute(False);
end;

function TAdventOfCodeDay9.SolveB: Variant;
begin
  Result := FindeBestRoute(True);
end;
{$ENDREGION}
{$Region 'TAdventOfCodeDay10'}
function TAdventOfCodeDay10.SolveA: Variant;
var NewSaid, Said, PrevChar: string;
  i, j, count: integer;
begin
  SentanceA := Talk(FInput[0], 40);
  Result := Length(SentanceA);
end;

function TAdventOfCodeDay10.SolveB: Variant;
begin
  Result := Length(Talk(SentanceA, 10));
end;

function TAdventOfCodeDay10.Talk(Const StartSentacne: String; Const Repeats: Integer): string;
var NewSaid, Said, PrevChar: string;
  i, j, count: integer;
begin
  Said := StartSentacne;

  for i := 1 to Repeats do
  begin
    NewSaid := '';
    PrevChar := Said[1];
    Count := 0;
    for j := 1 to Length(Said) do
    begin
      if Said[j] = PrevChar then
        Inc(Count)
      else
      begin
        NewSaid := NewSaid + Count.ToString + PrevChar;
        PrevChar := Said[j];
        count := 1;
      end
    end;
    NewSaid := NewSaid + Count.ToString + PrevChar;
    Said := NewSaid;
  end;

  Result := Said;
end;

{$ENDREGION}


   (*
{$Region 'TAdventOfCodeDay'}
procedure TAdventOfCodeDay.BeforeSolve;
begin

end;

procedure TAdventOfCodeDay.AfterSolve;
begin

end;

function TAdventOfCodeDay.SolveA: Variant;
begin

end;

function TAdventOfCodeDay.SolveB: Variant;
begin

end;
{$ENDREGION}
   *)
initialization
  RegisterClasses([
    TAdventOfCodeDay1, TAdventOfCodeDay2, TAdventOfCodeDay3, TAdventOfCodeDay4, TAdventOfCodeDay5,
    TAdventOfCodeDay6, TAdventOfCodeDay7,TAdventOfCodeDay8, TAdventOfCodeDay9,TAdventOfCodeDay10]);

end.

