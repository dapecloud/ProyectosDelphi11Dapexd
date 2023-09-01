unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.TreeView, System.JSON, System.IOUtils, MyJsonClasses,
  FMX.Controls.Presentation, FMX.Edit;

type
  TForm1 = class(TForm)
    Button1: TButton;
    TreeView1: TTreeView;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1ChangeTracking(Sender: TObject);
     procedure TreeView1Click(Sender: TObject);
  private
    procedure ShowChapterInTreeView(Chapter: TChapter; ParentNode: TTreeViewItem; const SearchText: string);
    procedure FilterTreeView(const SearchText: string);
    procedure ShowObjectInfo(const ObjName: string; ObjId: Integer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Edit1ChangeTracking(Sender: TObject);
begin
  // Apply the search filter when the Edit text changes
  FilterTreeView(Edit1.Text);
end;

procedure TForm1.FormCreate(Sender: TObject);

begin
  // Load the initial data when the form is created
  FilterTreeView('');
end;

procedure TForm1.FilterTreeView(const SearchText: string);
var
  JSONString: string;
  JSONValue: TJsonRoot;
begin
  // Clear the TreeView
  TreeView1.Clear;

  // Load JSON data
  JSONString := TFile.ReadAllText('/sdcard/DCIM/SharedFolder/ejemplo6.json');
  JSONValue := TJsonRoot.FromJsonString(JSONString);

  if Assigned(JSONValue) then
  begin
    try
      for var Chapter in JSONValue.Results do
        ShowChapterInTreeView(Chapter, nil, SearchText);
    finally
      JSONValue.Free;
    end;
  end;
end;

procedure TForm1.ShowChapterInTreeView(Chapter: TChapter; ParentNode: TTreeViewItem; const SearchText: string);
var
  ChapterNode, SubChapterNode, CategoryNode: TTreeViewItem;
  chapterId : Integer;
begin
  if (SearchText = '') or (Pos(UpperCase(SearchText), UpperCase(Chapter.ChapterName)) > 0) then
  begin
    ChapterNode := TTreeViewItem.Create(TreeView1);
    ChapterNode.Text := Chapter.ChapterName;
    chapterId := Chapter.ChapterId;
    ChapterNode.TagObject := Chapter;
   //aqui vamos
    //ShowObjectInfo(chapterId,1);

    //ChapterNode.Tag :=Chapter.ChapterId;

    {ChapterNode.TagObject := Chapter;
    ShowMessage(Chapter.ChapterId.ToString);
      //modificacon atual}


    if ParentNode = nil then
      TreeView1.AddObject(ChapterNode)
    else
      ParentNode.AddObject(ChapterNode);
      //ShowMessage('Id' + chapterId);



    for var SubChapter in Chapter.SubChapterList do
    begin
      if (SearchText = '') or (Pos(UpperCase(SearchText), UpperCase(SubChapter.SubChapterName)) > 0) then
      begin
        SubChapterNode := TTreeViewItem.Create(TreeView1);
        SubChapterNode.Text := SubChapter.SubChapterName;
        SubChapterNode.TagObject := SubChapter;
        ChapterNode.AddObject(SubChapterNode);



        for var Category in SubChapter.Categories do
        begin
          if (SearchText = '') or (Pos(UpperCase(SearchText), UpperCase(Category.CategoryName)) > 0) then
          begin
            CategoryNode := TTreeViewItem.Create(TreeView1);
            CategoryNode.Text := Category.CategoryName;
            CategoryNode.TagObject := Category;
            SubChapterNode.AddObject(CategoryNode);
          end;
        end;
      end
      else
      begin
        for var Category in SubChapter.Categories do
        begin
          if (SearchText = '') or (Pos(UpperCase(SearchText), UpperCase(Category.CategoryName)) > 0) then
          begin
            SubChapterNode := TTreeViewItem.Create(TreeView1);
            SubChapterNode.Text := SubChapter.SubChapterName;
            SubChapterNode.TagObject:= SubChapter;
            TreeView1.AddObject(SubChapterNode);

            CategoryNode := TTreeViewItem.Create(TreeView1);
            CategoryNode.Text := Category.CategoryName;
            CategoryNode.TagObject:= Category;
            SubChapterNode.AddObject(CategoryNode);
          end;
        end;
      end;
    end;

    for var Category in Chapter.Categories do
    begin
      if (SearchText = '') or (Pos(UpperCase(SearchText), UpperCase(Category.CategoryName)) > 0) then
      begin
        CategoryNode := TTreeViewItem.Create(TreeView1);
        CategoryNode.Text := Category.CategoryName;
        CategoryNode.TagObject:= Category;
        ChapterNode.AddObject(CategoryNode);
      end;
    end;
  end
  else
  begin
    for var SubChapter in Chapter.SubChapterList do
    begin
      if (SearchText = '') or (Pos(UpperCase(SearchText), UpperCase(SubChapter.SubChapterName)) > 0) then
      begin
        SubChapterNode := TTreeViewItem.Create(TreeView1);
        SubChapterNode.Text := SubChapter.SubChapterName;
        SubChapterNode.TagObject:= SubChapter;
        TreeView1.AddObject(SubChapterNode);


        for var Category in SubChapter.Categories do
        begin
          if (SearchText = '') or (Pos(UpperCase(SearchText), UpperCase(Category.CategoryName)) > 0) then
          begin
            CategoryNode := TTreeViewItem.Create(TreeView1);
            CategoryNode.Text := Category.CategoryName;
            CategoryNode.TagObject := Category;
            SubChapterNode.AddObject(CategoryNode);
          end;
        end;
      end
      else
      begin
        for var Category in SubChapter.Categories do
        begin
          if (SearchText = '') or (Pos(UpperCase(SearchText), UpperCase(Category.CategoryName)) > 0) then
          begin
            SubChapterNode := TTreeViewItem.Create(TreeView1);
            SubChapterNode.Text := SubChapter.SubChapterName;
            SubChapterNode.TagObject:= SubChapter;
            TreeView1.AddObject(SubChapterNode);

            CategoryNode := TTreeViewItem.Create(TreeView1);
            CategoryNode.Text := Category.CategoryName;
            CategoryNode.TagObject := Category;
            SubChapterNode.AddObject(CategoryNode);
          end;
        end;
      end;
    end;
  end;
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
  // Reload the full data when the button is clicked
  FilterTreeView('');
end;

procedure TForm1.TreeView1Click(Sender: TObject);
var
  SelectedNode: TTreeViewItem;
  ObjectName: string;
  ObjectId: Integer;
  Chapter: TChapter;
begin
  // Obtener el nodo seleccionado
  SelectedNode := TreeView1.Selected;

  // Verificar si se seleccionó un nodo válido
  if Assigned(SelectedNode) then
  begin
    // Obtener el nombre del nodo
    ObjectName := SelectedNode.Text;
    //ObjectId:= SelectedNode.TagObject;

    // Determinar el tipo de objeto (Chapter, SubChapter o Category) y obtener su ID
    if SelectedNode.Parent = nil then // Chapter
      ObjectId := TChapter(SelectedNode.TagObject).ChapterId
      //ObjectId:= SelectedNode.Tag
    else if SelectedNode.Parent.Parent = nil then // SubChapter
      ObjectId := TSubChapter(SelectedNode.TagObject).SubChapterId
    else // Category
      ObjectId := TCategory(SelectedNode.TagObject).CategoryId;

    // Mostrar el mensaje con la información del objeto
    ShowObjectInfo(ObjectName, ObjectId);
  end;
end;

procedure TForm1.ShowObjectInfo(const ObjName: string; ObjId: Integer);
begin
  ShowMessage('Nombre: ' + ObjName + ', ID: ' + IntToStr(ObjId));
end;

end.

