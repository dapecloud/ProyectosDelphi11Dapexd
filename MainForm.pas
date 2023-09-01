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
  try
  //showmessage para depurar
    ShowMessage('Antes de cargar el archivo JSON');
    CargarProductosDesdeJSON('/sdcard/DCIM/SharedFolder/ejemplo3.json');
      //showmessage para depurar
    ShowMessage('Después de cargar el archivo JSON');
    MostrarProductosEnTreeView;
  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
end;

procedure TForm2.CargarProductosDesdeJSON(const FileName: string);
var
  JSONString: string;
  JSONValue: TJSONValue;
  ResultsArray, SubChapterList, CategoryList: TJSONArray;
  ProductoObj: TProducto;
  i, j, k: Integer;
  chapterName, subChapterName, categoryName: string;
begin
  ShowMessage('Entrando a CargarProductosDesdeJSON');

  JSONString := TFile.ReadAllText(FileName);
  JSONValue := TJSONObject.ParseJSONValue(JSONString);
  ShowMessage(JSONValue.ToJSON);

  if JSONValue is TJSONObject then
  begin
    ShowMessage('Dentro del if JSONValue is TJSONObject');

    ProductosList.Clear;
    ResultsArray := JSONValue.GetValue<TJSONArray>('results');

    for i := 0 to ResultsArray.Count - 1 do
    begin
      ShowMessage('Dentro del primer loop, i=' + IntToStr(i));

      chapterName := ResultsArray.Items[i].GetValue<string>('chapterName');
      subChapterList := ResultsArray.Items[i].GetValue<TJSONArray>('subChapterList');
      categoryList := ResultsArray.Items[i].GetValue<TJSONArray>('categories');

      if Assigned(subChapterList) and (subChapterList.Count > 0) then
      begin
        // Handle Chapters with SubChapters
        for j := 0 to subChapterList.Count - 1 do
        begin
          subChapterName := subChapterList.Items[j].GetValue<string>('subChapterName');
          ShowMessage('Dentro del segundo loop, subChapterName=' + subChapterName);

          categoryList := subChapterList.Items[j].GetValue<TJSONArray>('categories');

          if Assigned(categoryList) and (categoryList.Count > 0) then
          begin
            // Handle SubChapters with Categories
            for k := 0 to categoryList.Count - 1 do
            begin
              categoryName := categoryList.Items[k].GetValue<string>('categoryName');
              ShowMessage('Dentro del tercer loop, categoryName=' + categoryName);

              if categoryName <> '' then
              begin
                ProductoObj := TProducto.Create;
                ProductoObj.chapterName := chapterName;
                ProductoObj.subChapterName := subChapterName;
                ProductoObj.categories := categoryName;
                ProductosList.Add(ProductoObj);
              end;
            end;
          end;
        end;
      end
      else if Assigned(categoryList) and (categoryList.Count > 0) then
      begin
        // Handle Chapters with Categories
        for k := 0 to categoryList.Count - 1 do
        begin
          categoryName := categoryList.Items[k].GetValue<string>('categoryName');
          ShowMessage('Dentro del tercer loop, categoryName=' + categoryName);

          if categoryName <> '' then
          begin
            ProductoObj := TProducto.Create;
            ProductoObj.chapterName := chapterName;
            ProductoObj.categories := categoryName;
            ProductosList.Add(ProductoObj);
          end;
        end;
      end
      else
      begin
        // Handle Chapters without SubChapters or Categories
        ProductoObj := TProducto.Create;
        ProductoObj.chapterName := chapterName;
        ProductosList.Add(ProductoObj);
      end;
    end;
  end;
end;

procedure TForm2.MostrarProductosEnTreeView;
var
  Producto: TProducto;
  Item: TTreeViewItem;
begin
  TreeView1.Clear;

  for Producto in ProductosList do
  begin
    Item := TTreeViewItem.Create(nil);
    Item.Text := 'Capítulo: ' + Producto.chapterName;
    TreeView1.AddObject(Item);

    Item := TTreeViewItem.Create(nil);
    Item.Text := 'Subcapítulo: ' + Producto.subChapterName;
    TreeView1.AddObject(Item);

    Item := TTreeViewItem.Create(nil);
    Item.Text := 'Categorías: ' + Producto.categories;
    TreeView1.AddObject(Item);
  end;
end;

procedure TForm2.Edit1Change(Sender: TObject);
var
  Filtro: string;
  Producto: TProducto;
  Item, SubChapterNode, CategoriesNode: TTreeViewItem;
  NoResultsNode: TTreeViewItem;
begin
  Filtro := Edit1.Text.ToLower;
  TreeView1.Clear;

  NoResultsNode := TTreeViewItem.Create(nil);
  NoResultsNode.Text := 'Descripción no encontrada';
  TreeView1.AddObject(NoResultsNode);

  for Producto in ProductosList do
  begin
    if Filtro.IsEmpty or
       (Pos(Filtro, Producto.chapterName.ToLower) > 0) or
       (Pos(Filtro, Producto.subChapterName.ToLower) > 0) or
       (Pos(Filtro, Producto.categories.ToLower) > 0) then
    begin
      TreeView1.RemoveObject(NoResultsNode);

      Item := TTreeViewItem.Create(nil);
      Item.Text := 'Capítulo: ' + Producto.chapterName;
      TreeView1.AddObject(Item);

      SubChapterNode := TTreeViewItem.Create(Item);
      SubChapterNode.Text := 'Subcapítulo: ' + Producto.subChapterName;
      Item.AddObject(SubChapterNode);

      CategoriesNode := TTreeViewItem.Create(Item);
      CategoriesNode.Text := 'Categorías: ' + Producto.categories;
      Item.AddObject(CategoriesNode);
    end;
  end;
end;

end.

