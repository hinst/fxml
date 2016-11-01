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
  OXmlPDOM,
  LogU;

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
    ListViewMainColumn: TfpgLVColumn;
    procedure AfterCreate; override;
    procedure ReceiveFileOpenCommand(aSender: TObject);
    procedure LoadFile(const aFilePath: string);
    procedure PrepareMenu;
    procedure DisplayElement(aNode: PXMLNode);
    procedure ShowSomething;
    procedure ActivateItem(aListView: TfpgListView; aItem: TfpgLVItem);
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
  ListView := TfpgListview.Create(self);
  ListView.Align := alClient;
  ListView.OnItemActivate := @ActivateItem;
  ListViewCountColumn := TfpgLVColumn.Create(ListView.Columns);
  ListViewCountColumn.ColumnIndex := 0;
  ListViewCountColumn.Caption := 'Count';
  ListViewCountColumn.Resizable := True;
  ListViewCountColumn.Width := 40;
  ListView.Columns.Add(ListViewCountColumn);
  ListViewMainColumn := TfpgLVColumn.Create(ListView.Columns);
  ListViewMainColumn.ColumnIndex := 1;
  ListViewMainColumn.AutoExpand := true;
  ListViewMainColumn.Caption := 'Node name';
  ListView.Columns.Add(ListViewMainColumn);
  ShowSomething;
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
var
  i: Integer;
  item: TfpgLVItem;
  subNode: PXMLNode;
begin
  ListView.Items.Clear;
  WriteLog('DisplayElement: ' + IntToStr(aNode^.ChildCount));
  for i := 0 to aNode^.ChildCount - 1 do
  begin
    subNode := aNode^.ChildNodes[i];
    item := ListView.AddItem;
    item.Caption := IntToStr(subNode^.ChildCount);
    item.SubItems.Add(subNode^.NodeName);
    item.UserData := subNode;
  end;
  ListViewCountColumn.AutoSize := True;
end;

procedure TMainWindow.ShowSomething;
var
  item: TfpgLVItem;
begin
  item := ListView.AddItem;
  item.SubItems.Add('XML viewer');
end;

procedure TMainWindow.ActivateItem(aListView: TfpgListView; aItem: TfpgLVItem);
begin
  WriteLog('?');
end;

destructor TMainWindow.Destroy;
begin
  Document := nil;
  inherited Destroy;
end;

end.

