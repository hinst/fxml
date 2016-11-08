unit MainWindowU;

interface

uses
  SysUtils,
  fpg_main,
  fpg_form,
  fpg_menu,
  fpg_base,
  fpg_dialogs,
  fpg_listview,
  fpg_panel,
  fpg_button,
  OXmlPDOM,
  OXmlUtils,
  LogU,
  UtilU;

type

  { TMainWindow }

  TMainWindow = class(TfpgForm)
  public
    MenuBar: TfpgMenuBar;
    FileMenu: TfpgPopupMenu;
    FilePath: string;
    Document: IXMLDocument;
    ListView: TfpgListView;
    ListViewCountColumn: TfpgLVColumn;
    ListViewInfoColumn: TfpgLVColumn;
    ListViewMainColumn: TfpgLVColumn;
    TopPanel: TfpgPanel;
    procedure AfterCreate; override;
    procedure PrepareListView;
    procedure ReceiveFileOpenCommand(aSender: TObject);
    procedure LoadFile(const aFilePath: string);
    procedure PrepareMenu;
    procedure DisplayElement(aNode: PXMLNode);
    procedure DisplaySubItems(aNode: PXMLNode);
    procedure UpdateHeader(aNode: PXMLNode);
    procedure ShowSomething;
    procedure ActivateItem(aListView: TfpgListView; aItem: TfpgLVItem);
    procedure ReceiveHeaderNodeClick(aSender: TObject);
    procedure PaintItem(aListView: TfpgListView; ACanvas: TfpgCanvas; Item: TfpgLVItem;
      ItemIndex: Integer; Area: TfpgRect; var PaintPart: TfpgLVItemPaintPart);
    destructor Destroy; override;
  end;

implementation

{ TMainWindow }

procedure TMainWindow.AfterCreate;
begin
  inherited AfterCreate;
  WindowTitle := 'Hinst.FXML';
  Width := 600;
  Height := 300;
  PrepareMenu;
  TopPanel := TfpgPanel.Create(self);
  TopPanel.Height := 20;
  TopPanel.Align := alTop;
  TopPanel.Style := bsFlat;
  TopPanel.Text := '';
  PrepareListView;
  ShowSomething;
end;

procedure TMainWindow.PrepareListView;
begin
  ListView := TfpgListview.Create(self);
  ListView.Align := alClient;
  ListView.OnItemActivate := @ActivateItem;
  ListView.OnPaintItem := @PaintItem;

  ListViewCountColumn := TfpgLVColumn.Create(ListView.Columns);
  ListViewCountColumn.ColumnIndex := 0;
  ListViewCountColumn.Caption := '#';
  ListViewCountColumn.Resizable := True;
  ListViewCountColumn.Width := 32;
  ListView.Columns.Add(ListViewCountColumn);

  ListViewInfoColumn := TfpgLVColumn.Create(ListView.Columns);
  ListViewInfoColumn.ColumnIndex := 1;
  ListViewInfoColumn.Caption := 'Info';
  ListViewInfoColumn.Resizable := True;
  ListViewInfoColumn.Width := 70;
  ListView.Columns.Add(ListViewInfoColumn);

  ListViewMainColumn := TfpgLVColumn.Create(ListView.Columns);
  ListViewMainColumn.ColumnIndex := 2;
  ListViewMainColumn.AutoExpand := true;
  ListViewMainColumn.Caption := 'Node name';
  ListView.Columns.Add(ListViewMainColumn);
end;

procedure TMainWindow.ReceiveFileOpenCommand(aSender: TObject);
var
  dialog: TfpgFileDialog;
begin
  dialog := TfpgFileDialog.Create(self);
  if dialog.RunOpenFile then
  begin
    LoadFile(dialog.FileName);
  end;
  dialog.Free;
end;

procedure TMainWindow.LoadFile(const aFilePath: string);
begin
  Document := nil;
  FilePath := aFilePath;
  Document := CreateXMLDoc;
  Document.LoadFromFile(aFilePath);
  DisplayElement(Document.Node);
end;

procedure TMainWindow.PrepareMenu;
begin
  MenuBar := TfpgMenuBar.Create(self);
  MenuBar.Align := alTop;
  FileMenu := TfpgPopupMenu.Create(self);
  FileMenu.AddMenuItem('&Open', 'Ctrl-O', @ReceiveFileOpenCommand);
  MenuBar.AddMenuItem('&File', nil).SubMenu := FileMenu;
end;

procedure TMainWindow.DisplayElement(aNode: PXMLNode);
begin
  DisplaySubItems(aNode);
  UpdateHeader(aNode);
end;

procedure TMainWindow.DisplaySubItems(aNode: PXMLNode);
var
  i: Integer;
  item: TfpgLVItem;
  subNode: PXMLNode;
  text: string;
  typeText: string;
begin
  ListView.BeginUpdate;
  ListView.Items.Clear;
  WriteLog('DisplayElement: ' + IntToStr(aNode^.ChildCount));
  for i := 0 to aNode^.ChildCount - 1 do
  begin
    subNode := aNode^.ChildNodes[i];
    item := ListView.AddItem;
    item.Caption := IntToStr(i);
    text := '''' + subNode^.NodeName + '''';
    if subNode^.NodeType = ntElement then
      typeText := 'elem [' + IntToStr(subNode^.ChildCount) + ']';
    item.SubItems.Add(typeText);
    item.SubItems.Add(text);
    item.UserData := subNode;
  end;
  ListViewCountColumn.AutoSize := True;
  ListView.EndUpdate;
end;

procedure TMainWindow.UpdateHeader(aNode: PXMLNode);
var
  i: Integer;
  button: TfpgButton;
  nodes: PXmlNodeDynArray;
begin
  for i := TopPanel.ComponentCount - 1 downto 0 do
    TopPanel.Components[i].Free;
  nodes := GetPathNodes(aNode);
  for i := 0 to Length(nodes) - 1 do
  begin
    button := TfpgButton.Create(TopPanel);
    button.Align := alLeft;
    button.Text := nodes[i]^.NodeName;
    if nodes[i]^.NodeName = '' then
      button.Text := '[root]';
    button.Flat := True;
    button.Left := 0;
    button.Hint := button.Text;
    button.TagPointer := nodes[i];
    button.OnClick := @ReceiveHeaderNodeClick;
  end;
end;

procedure TMainWindow.ShowSomething;
var
  item: TfpgLVItem;
begin
  item := ListView.AddItem;
  item.SubItems.Add('');
  item.SubItems.Add('XML viewer');
end;

procedure TMainWindow.ActivateItem(aListView: TfpgListView; aItem: TfpgLVItem);
begin
  if aItem.UserData <> nil then
    DisplayElement(PXMLNode(aItem.UserData));
end;

procedure TMainWindow.ReceiveHeaderNodeClick(aSender: TObject);
var
  node: PXMLNode;
begin
  node := TfpgButton(aSender).TagPointer;
  if node <> nil then
    DisplayElement(node);
end;

procedure TMainWindow.PaintItem(aListView: TfpgListView; ACanvas: TfpgCanvas;
  Item: TfpgLVItem; ItemIndex: Integer; Area: TfpgRect;
  var PaintPart: TfpgLVItemPaintPart);
begin
end;

destructor TMainWindow.Destroy;
begin
  Document := nil;
  inherited Destroy;
end;

end.

