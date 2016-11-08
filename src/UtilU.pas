unit UtilU;

interface

uses
  Classes, OXmlPDOM;

type
  PXmlNodeDynArray = array of PXMLNode;

function GetPathNodes(a: PXMLNode): PXmlNodeDynArray;

implementation

function GetPathNodes(a: PXMLNode): PXmlNodeDynArray;
var
  list: TfpList;
  i: Integer;
begin
  list := TfpList.Create;
  while a <> nil do
  begin
    list.Insert(0, a);
    a := a^.ParentNode;
  end;
  SetLength(result, list.Count);
  for i := 0 to list.Count - 1 do
  begin
    result[i] := PXMLNode(list[i]);
  end;
  list.Free;
end;

end.

