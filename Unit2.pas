unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ListBox,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Layouts, FMX.TreeView,
  System.JSON, System.IOUtils, FMX.Platform, Androidapi.Helpers, Androidapi.JNI.Net,
  Androidapi.JNI.JavaTypes, FMX.Helpers.Android, Androidapi.JNI.GraphicsContentViewText;

type
  TForm2 = class(TForm)
    TreeView1: TTreeView;
    Label1: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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

procedure TForm2.Button1Click(Sender: TObject);
begin
    LeerJSONArchivo(TPath.Combine('/sdcard/DCIM/SharedFolder', 'ejemplo2.json'));
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  // Establecer la ruta predeterminada en Label1
  Label1.Text := TPath.Combine('/sdcard/DCIM/SharedFolder', 'ejemplo2.json');
  ShowMessage ('Recuerda Entrar a Ajustes>Aplicaciones>LeerJSON2 y Dar el permiso de acceder a multimedia');
end;


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
  I, J: Integer;
  NuevoNodo: TTreeViewItem;
  JSONPair: TJSONPair;
  JSONValue, SubJsonValue: TJSONValue;
begin
  if NodoJSON is TJSONObject then
  begin
    for I := 0 to TJSONObject(NodoJSON).Count - 1 do
    begin
      JSONPair := TJSONObject(NodoJSON).Pairs[I];
      JSONValue := JSONPair.JsonValue;

      if JSONValue is TJSONObject then
      begin
        NuevoNodo := TTreeViewItem.Create(TreeView1);
        NuevoNodo.Text := (JSONValue as TJSONObject).GetValue<string>('chapterName');
        if Assigned(NodoTreeView) then
          NodoTreeView.AddObject(NuevoNodo)
        else
          TreeView1.AddObject(NuevoNodo);

        AgregarNodosTreeView(JSONValue, NuevoNodo);
      end
      else if JSONValue is TJSONArray then
      begin
        for J := 0 to TJSONArray(JSONValue).Count - 1 do
        begin
          SubJsonValue := TJSONArray(JSONValue).Items[J];

          if SubJsonValue is TJSONObject then
          begin
            if (SubJsonValue as TJSONObject).GetValue('subChapterName') <> nil then
            begin
              NuevoNodo := TTreeViewItem.Create(TreeView1);
              NuevoNodo.Text := (SubJsonValue as TJSONObject).GetValue<string>('subChapterName');
              if Assigned(NodoTreeView) then
                NodoTreeView.AddObject(NuevoNodo)
              else
                TreeView1.AddObject(NuevoNodo);

              AgregarNodosTreeView(SubJsonValue, NuevoNodo);
            end
            else if (SubJsonValue as TJSONObject).GetValue('categoryName') <> nil then
            begin
              NuevoNodo := TTreeViewItem.Create(TreeView1);
              NuevoNodo.Text := (SubJsonValue as TJSONObject).GetValue<string>('categoryName');
              if Assigned(NodoTreeView) then
                NodoTreeView.AddObject(NuevoNodo)
              else
                TreeView1.AddObject(NuevoNodo);
            end;
          end;
        end;
      end;
    end;
  end;
end;
end.

