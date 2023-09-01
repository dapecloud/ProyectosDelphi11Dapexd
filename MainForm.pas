unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Layouts, FMX.TreeView, FMX.Controls.Presentation, FMX.StdCtrls, System.Generics.Collections,
  Productos, System.JSON, System.IOUtils;

type
  TForm2 = class(TForm)
    Button1: TButton;
    TreeView1: TTreeView;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
    ProductosList: TList<TProducto>;
    procedure CargarProductosDesdeJSON(const FileName: string);
    procedure MostrarProductosEnTreeView;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.FormCreate(Sender: TObject);
begin
  ProductosList := TList<TProducto>.Create;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  CargarProductosDesdeJSON('/sdcard/DCIM/SharedFolder/ejemplo4.json');
  MostrarProductosEnTreeView;
end;

procedure TForm2.CargarProductosDesdeJSON(const FileName: string);
var
  JSONString: string;
  JSONValue: TJSONValue;
  Producto: TJSONObject;
  ProductoObj: TProducto;
  ProductosArray: TJSONArray;
  i: Integer;
begin
  JSONString := TFile.ReadAllText(FileName);
  JSONValue := TJSONObject.ParseJSONValue(JSONString);

  if JSONValue is TJSONArray then
  begin
    ProductosList.Clear;
    ProductosArray := TJSONArray(JSONValue);

    for i := 0 to ProductosArray.Count - 1 do
    begin
      Producto := TJSONObject(ProductosArray.Items[I]);
      ProductoObj := TProducto.Create;
      ProductoObj.Nombre := Producto.GetValue('Nombre').Value;
      ProductoObj.Precio := StrToFloatDef(Producto.GetValue('Precio').Value, 0);
      ProductoObj.Categoria := Producto.GetValue('Categoria').Value;
      ProductosList.Add(ProductoObj);
    end;
  end;
end;

procedure TForm2.MostrarProductosEnTreeView;
var
  Producto: TProducto;
  Item: TTreeViewItem;
  PrecioNode, CategoriaNode: TTreeViewItem;
begin
  TreeView1.Clear;

  for Producto in ProductosList do
  begin
    Item := TTreeViewItem.Create(nil);
    Item.Text := Producto.Nombre;
    TreeView1.AddObject(Item);

    PrecioNode := TTreeViewItem.Create(Item);
    PrecioNode.Text := 'Precio: ' + FloatToStr(Producto.Precio);
    Item.AddObject(PrecioNode);

    CategoriaNode := TTreeViewItem.Create(Item);
    CategoriaNode.Text := 'Categoría: ' + Producto.Categoria;
    Item.AddObject(CategoriaNode);
  end;
end;
procedure TForm2.Edit1Change(Sender: TObject);
var
  Filtro: string;
  Producto: TProducto;
  Item, PrecioNode, CategoriaNode: TTreeViewItem;
  NoResultsNode: TTreeViewItem;
begin
  Filtro := Edit1.Text.ToLower;
  TreeView1.Clear;

  NoResultsNode := TTreeViewItem.Create(nil);
  NoResultsNode.Text := 'Descripción no encontrada, si buscas precio usa , en lugar de .';
  TreeView1.AddObject(NoResultsNode);

  for Producto in ProductosList do
  begin
    if Filtro.IsEmpty or
       (Pos(Filtro, Producto.Nombre.ToLower) > 0) or
       (Pos(Filtro, FloatToStr(Producto.Precio)) > 0) or
       (Pos(Filtro, Producto.Categoria.ToLower) > 0) then
    begin
      TreeView1.RemoveObject(NoResultsNode);

      Item := TTreeViewItem.Create(nil);
      Item.Text := Producto.Nombre;
      TreeView1.AddObject(Item);

      PrecioNode := TTreeViewItem.Create(Item);
      PrecioNode.Text := 'Precio: ' + FloatToStr(Producto.Precio);
      Item.AddObject(PrecioNode);

      CategoriaNode := TTreeViewItem.Create(Item);
      CategoriaNode.Text := 'Categoría: ' + Producto.Categoria;
      Item.AddObject(CategoriaNode);
    end;
  end;
end;


end.

