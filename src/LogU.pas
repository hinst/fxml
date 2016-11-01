unit LogU;

interface

uses
  Classes, SysUtils;

procedure WriteLog(s: string);

implementation

procedure WriteLog(s: string);
begin
  WriteLN(s);
end;

end.

