program ViewerP;

uses
  fpg_main, MainWindowU, LogU;

var
  window: TMainWindow;

begin
  fpgApplication.Initialize;
  window := TMainWindow.Create(nil);
  window.Show;
  fpgApplication.Run;
  window.Free;
end.

