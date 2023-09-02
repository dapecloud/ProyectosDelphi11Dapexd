unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ListBox,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Layouts, FMX.TreeView;

type
  TForm2 = class(TForm)
    ListBox1: TListBox;
    Calcular: TButton;
    Edit1: TEdit;
    TreeView1: TTreeView;
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure CalcularClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ConjeturaCollatz(n: Integer);
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

  procedure LimpiarTreeView(TreeView: TTreeView);
begin
  TreeView.Clear;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  LimpiarTreeView(TreeView1);
  ListBox1.Items.Clear;
end;

procedure TForm2.CalcularClick(Sender: TObject);
var
  numero: Integer;
begin
  ListBox1.Items.Clear;

  if TryStrToInt(Edit1.Text, numero) then
    ConjeturaCollatz(numero)
  else
    ShowMessage('Ingrese un n�mero v�lido.');
end;

procedure TForm2.ConjeturaCollatz(n: Integer);
var
  RootNode, Node, SubNode: TTreeViewItem;
begin
  ListBox1.Items.Add('N�mero Inicial: ' + IntToStr(n));

  RootNode := TTreeViewItem.Create(nil); // Creamos un nuevo nodo ra�z
  RootNode.Text := 'Evento ' + IntToStr(n); // Establecemos el texto del nodo ra�z como el n�mero inicial
  TreeView1.AddObject(RootNode); // Agregamos el nodo ra�z al �rbol

  while n > 1 do
  begin
    if n mod 2 = 0 then
      n := n div 2
    else
      n := 3 * n + 1;

    ListBox1.Items.Add('Siguiente n�mero: ' + IntToStr(n));

    Node := TTreeViewItem.Create(RootNode); // Creamos un nuevo nodo hijo
    Node.Text := IntToStr(n); // Establecemos el texto del nodo hijo como el siguiente n�mero
    RootNode.AddObject(Node); // Agregar el nodo hijo al nodo ra�z
    RootNode := Node; // Establecer el nodo hijo como el nuevo nodo ra�z para el siguiente n�mero
  end;
end;

end.

