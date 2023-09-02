unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, REST.Types,
  REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  FMX.TreeView, System.JSON;

type
  TForm2 = class(TForm)
    TreeView1: TTreeView;
    btnLoadJSON: TButton;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    procedure btnLoadJSONClick(Sender: TObject);
    procedure AddJSONNodeToTreeView1(ParentNode: TTreeViewItem; JSONNode: TJSONValue);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.AddJSONNodeToTreeView1(ParentNode: TTreeViewItem; JSONNode: TJSONValue);
var
  node: TTreeViewItem;
  json: TJSONObject;
  field: TJSONPair;
begin
  if JSONNode is TJSONObject then
  begin
    json := JSONNode as TJSONObject;

    node := TTreeViewItem.Create(Self);

    // Obtener el valor del campo "title" del JSON
    field := json.Get('title');
    if Assigned(field) and (field.JsonValue is TJSONString) then
      node.Text := TJSONString(field.JsonValue).Value;

    if Assigned(ParentNode) then
      ParentNode.AddObject(node)
    else
      TreeView1.AddObject(node);
  end;
end;


procedure TForm2.btnLoadJSONClick(Sender: TObject);
var
  json: TJSONObject;
begin
  RESTRequest1.Execute;

  json := TJSONObject.ParseJSONValue(RESTResponse1.Content) as TJSONObject;
  if Assigned(json) then
  begin
    try
      TreeView1.Clear;

      // Agregar un único nodo con el título del JSON
      AddJSONNodeToTreeView1(nil, json);

    finally
      json.Free;
    end;
  end;
end;

end.
