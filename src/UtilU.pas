unit UtilU;

interface

uses
  Classes, OXmlPDOM, OXmlUtils;

type
  PXmlNodeDynArray = array of PXMLNode;

function GetPathNodes(a: PXMLNode): PXmlNodeDynArray;
function GetCountOfChildElements(a: PXMLNode): Integer;
function GetCountOfAttributes(a: PXMLNode): Integer;
function GetCompactText(a: string): string;

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

function GetCountOfChildElements(a: PXMLNode): Integer;
var
  i: Integer;
begin
  result := 0;
  for i := 0 to a^.ChildCount - 1 do
  begin
    if a^.ChildNodes[i]^.NodeType = ntElement then
      Inc(result);
  end;
end;

function GetCountOfAttributes(a: PXMLNode): Integer;
var
  i: Integer;
begin
  result := 0;
  for i := 0 to a^.ChildCount - 1 do
  begin
    if a^.ChildNodes[i]^.NodeType = ntAttribute then
      Inc(result);
  end;
end;

function GetCompactText(a: string): string;
begin
  result := a;
  if Length(result) > 100 then
    result := Copy(result, 1, 100) + '...';
end;

end.

