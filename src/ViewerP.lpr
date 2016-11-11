program ViewerP;

uses
  fpg_main, MainWindowU, LogU, UtilU, sysutils;

var
  window: TMainWindow;

begin
  fpgApplication.Initialize;
  window := TMainWindow.Create(nil);
  window.Show;
  fpgApplication.OnException := @window.ReceiveException;
  fpgApplication.Run;
  window.Free;
end.

