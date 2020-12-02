unit AOCSolutions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Generics.Defaults, System.Generics.Collections,
  system.Diagnostics, AOCBase, RegularExpressions, System.DateUtils, system.StrUtils,
  system.Math, uAOCUtils, system.Types;

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
(*
  TAdventOfCodeDay? = class(TAdventOfCode)
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
var Count: Integer;
    PositionSanta, PositionRobo, Temp: TPosition;
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


   (*
{$Region 'TAdventOfCodeDay?'}
procedure TAdventOfCodeDay?.BeforeSolve;
begin

end;

procedure TAdventOfCodeDay?.AfterSolve;
begin

end;

function TAdventOfCodeDay?.SolveA: Variant;
begin

end;

function TAdventOfCodeDay?.SolveB: Variant;
begin

end;
{$ENDREGION}
   *)
initialization
  RegisterClasses([TAdventOfCodeDay1, TAdventOfCodeDay2, TAdventOfCodeDay3]);

end.

