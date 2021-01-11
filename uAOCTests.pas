unit uAOCTests;

interface

uses
  System.SysUtils, Winapi.Windows,
  uAocUtils, AocSolutions, AOCBase;

type AOCTest = record
  AOCClass: TAdventOfCodeRef;
  ExpectedSolutionA, ExpectedSolutionB, OverRidenTestInput: String;
end;

type AOCTests = class
public
  Class procedure RunTests;
end;

Const AOCTestData: array[0..21] of AOCTest =
(  (AOCClass: TAdventOfCodeDay1; ExpectedSolutionA: '74'; ExpectedSolutionB: '1795'),
  (AOCClass: TAdventOfCodeDay2; ExpectedSolutionA: '1598415'; ExpectedSolutionB: '3812909'),
  (AOCClass: TAdventOfCodeDay3; ExpectedSolutionA: '2081'; ExpectedSolutionB: '2341'),
  (AOCClass: TAdventOfCodeDay4; ExpectedSolutionA: '282749'; ExpectedSolutionB: '9962624'),
  (AOCClass: TAdventOfCodeDay5; ExpectedSolutionA: '255'; ExpectedSolutionB: '55'),
  (AOCClass: TAdventOfCodeDay6; ExpectedSolutionA: '543903'; ExpectedSolutionB: '14687245'),
  (AOCClass: TAdventOfCodeDay7; ExpectedSolutionA: '956'; ExpectedSolutionB: '40149'),
  (AOCClass: TAdventOfCodeDay8; ExpectedSolutionA: '1371'; ExpectedSolutionB: '2117'),
  (AOCClass: TAdventOfCodeDay9; ExpectedSolutionA: '207'; ExpectedSolutionB: '804'),
  (AOCClass: TAdventOfCodeDay10; ExpectedSolutionA: '329356'; ExpectedSolutionB: '4666278'),
  (AOCClass: TAdventOfCodeDay11; ExpectedSolutionA: 'hepxxyzz'; ExpectedSolutionB: 'heqaabcc'),
  (AOCClass: TAdventOfCodeDay12; ExpectedSolutionA: '156366'; ExpectedSolutionB: '96852'),
  (AOCClass: TAdventOfCodeDay13; ExpectedSolutionA: '733'; ExpectedSolutionB: '725'),
  (AOCClass: TAdventOfCodeDay14; ExpectedSolutionA: '2696'; ExpectedSolutionB: '1084'),
  (AOCClass: TAdventOfCodeDay15; ExpectedSolutionA: '21367368'; ExpectedSolutionB: '1766400'),
  (AOCClass: TAdventOfCodeDay16; ExpectedSolutionA: '213'; ExpectedSolutionB: '323'),
  (AOCClass: TAdventOfCodeDay17; ExpectedSolutionA: '1638'; ExpectedSolutionB: '17'),
  (AOCClass: TAdventOfCodeDay18; ExpectedSolutionA: '768'; ExpectedSolutionB: '781'),
//  (AOCClass: TAdventOfCodeDay19; ExpectedSolutionA: '579'; ExpectedSolutionB: '')
  (AOCClass: TAdventOfCodeDay20; ExpectedSolutionA: '831600'; ExpectedSolutionB: '884520'),
  (AOCClass: TAdventOfCodeDay21; ExpectedSolutionA: '121'; ExpectedSolutionB: '201'),
  (AOCClass: TAdventOfCodeDay22; ExpectedSolutionA: '1824'; ExpectedSolutionB: '1937'),
  (AOCClass: TAdventOfCodeDay23; ExpectedSolutionA: '307'; ExpectedSolutionB: '160')
  );

implementation

class procedure AOCTests.RunTests;
Var Test: AOCTest;
    AdventOfCode: TAdventOfCode;
    SolutionA, SolutionB: string;
    StartTick: Int64;

  procedure _Check(const DisplayName, Expected, Actual: String);
  begin
    if Expected <> '' then
      if Expected <> Actual then
      begin
        WriteLn(Format('FAIL, %s Expected: %s, Actual: %s', [DisplayName, Expected, Actual]));
        Assert(False);
      end
      else
        WriteLn(Format('PASS, %s', [DisplayName]))
  end;

begin
  for Test in AOCTestData do
  begin
    Writeln(Format('Running tests for %s', [Test.AOCClass.ClassName]));

    StartTick := GetTickCount;
    AdventOfCode := Test.AOCClass.Create;
    AdventOfCode.Test(SolutionA, SolutionB, Test.OverRidenTestInput);
    AdventOfCode.Free;

    _Check('Part a', Test.ExpectedSolutionA, SolutionA);
    _Check('Part b', Test.ExpectedSolutionB, SolutionB);
    Writeln(FormAt('Total ticks %d', [GetTickCount - StartTick]));
    Writeln('');
  end
end;

end.
