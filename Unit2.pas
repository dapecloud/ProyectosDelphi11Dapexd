unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ListBox,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Layouts, FMX.TreeView,
  System.JSON, System.IOUtils, FMX.Platform;

type
  TForm2 = class(TForm)
    TreeView1: TTreeView;
    Label1: TLabel;
    Buscar: TButton;
    Submit: TButton;
    Label2: TLabel;
    procedure BuscarClick(Sender: TObject);
    procedure SubmitClick(Sender: TObject);
  private
    { Private declarations }
    procedure LeerJSONArchivo(const RutaArchivo: string);
    procedure AgregarNodosTreeView(NodoJSON: TJSONValue; NodoTreeView: TTreeViewItem);
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.LeerJSONArchivo(const RutaArchivo: string);
var
  JSONArchivo: TStringStream;
  NodoJSON: TJSONValue;
begin
  JSONArchivo := TStringStream.Create;
  try
    JSONArchivo.LoadFromFile(RutaArchivo);
    NodoJSON := TJSONObject.ParseJSONValue(JSONArchivo.DataString);
    if Assigned(NodoJSON) then
    begin
      TreeView1.Clear;
      AgregarNodosTreeView(NodoJSON, nil);
    end
    else
      ShowMessage('Error al leer el archivo JSON');
  finally
    JSONArchivo.Free;
  end;
end;

procedure TForm2.AgregarNodosTreeView(NodoJSON: TJSONValue; NodoTreeView: TTreeViewItem);
var
  I: Integer;
  NuevoNodo: TTreeViewItem;
begin
  if NodoJSON is TJSONObject then
  begin
    for I := 0 to TJSONObject(NodoJSON).Count - 1 do
    begin
      NuevoNodo := TTreeViewItem.Create(TreeView1);
      NuevoNodo.Text := TJSONObject(NodoJSON).Pairs[I].JsonString.Value;
      if Assigned(NodoTreeView) then
        NodoTreeView.AddObject(NuevoNodo)
      else
        TreeView1.AddObject(NuevoNodo);

      AgregarNodosTreeView(TJSONObject(NodoJSON).Pairs[I].JsonValue, NuevoNodo);
    end;
  end
  else if NodoJSON is TJSONArray then
  begin
    for I := 0 to TJSONArray(NodoJSON).Count - 1 do
    begin
      NuevoNodo := TTreeViewItem.Create(TreeView1);
      NuevoNodo.Text := TJSONArray(NodoJSON).Items[I].Value;
      if Assigned(NodoTreeView) then
        NodoTreeView.AddObject(NuevoNodo)
      else
        TreeView1.AddObject(NuevoNodo);

      AgregarNodosTreeView(TJSONArray(NodoJSON).Items[I], NuevoNodo);
    end;
  end
  else if Assigned(NodoTreeView) then
    NodoTreeView.Text := NodoJSON.Value;
end;

procedure TForm2.BuscarClick(Sender: TObject);
var
  RutaArchivo: string;
begin
  RutaArchivo := TPath.GetDocumentsPath;
  RutaArchivo := TPath.Combine(RutaArchivo, 'archivo.json');

  Label1.Text := RutaArchivo;
end;

procedure TForm2.SubmitClick(Sender: TObject);
begin
  if not Label1.Text.IsEmpty then
    LeerJSONArchivo(Label1.Text);
end;

end.

