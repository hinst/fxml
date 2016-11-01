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
    procedure AfterCreate; override;
    procedure ReceiveFileOpenCommand(aSender: TObject);
    procedure LoadFile(const aFilePath: string);
    procedure PrepareMenu;
    procedure DisplayElement(aNode: PXMLNode);
    destructor Destroy; override;
  end;

implementation

{ TMainWindow }

procedure TMainWindow.AfterCreate;
begin
  inherited AfterCreate;
  WindowTitle := 'Hinst.FXML';
  Width := 300;
  Height := 300;
  PrepareMenu;
  ListView := TfpgListview.Create(self);
  ListView.Align := alClient;
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
begin
  ListView.Items.Clear;
  WriteLog('DisplayElement: ' + IntToStr(aNode^.ChildCount));
  for i := 0 to aNode^.ChildCount - 1 do
  begin
    item := TfpgLVItem.Create(ListView.Items);
    item.Caption := aNode^.ChildNodes[i]^.Text;
    ListView.Items.Add(item);
  end;
end;

destructor TMainWindow.Destroy;
begin
  Document := nil;
  inherited Destroy;
end;

end.

