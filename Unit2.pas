unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Layouts, FMX.Colors, FMX.Objects;

type
  TForm2 = class(TForm)
    Circle1: TCircle;
    Ellipse1: TEllipse;
    Rectangle1: TRectangle;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ColorPicker1: TColorPicker;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ColorPicker1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure MostrarFigura(Figura: TControl);
    procedure OcultarFigura(Figura: TControl);
    procedure ActualizarEtiquetaSeleccionada;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.FormCreate(Sender: TObject);
begin
  ColorPicker1.Visible := False;
end;

procedure TForm2.MostrarFigura(Figura: TControl);
begin
  Figura.Visible := True;
  ColorPicker1.Visible := True;
  ActualizarEtiquetaSeleccionada;
end;

procedure TForm2.OcultarFigura(Figura: TControl);
begin
  Figura.Visible := False;
  if not (Circle1.Visible or Ellipse1.Visible or Rectangle1.Visible) then
    ColorPicker1.Visible := False;
  ActualizarEtiquetaSeleccionada;
end;

procedure TForm2.ActualizarEtiquetaSeleccionada;
begin
  if Circle1.Visible then
    Label1.Text := 'Figura seleccionada: Círculo'
  else if Ellipse1.Visible then
    Label1.Text := 'Figura seleccionada: Elipse'
  else if Rectangle1.Visible then
    Label1.Text := 'Figura seleccionada: Cuadrado'
  else if not (Circle1.Visible or Ellipse1.Visible or Rectangle1.Visible) then
    Label1.Text := 'Selecciona una figura para cambiar el color'
  else
    Label1.Text := 'Presiona algún botón para mostrar una figura';
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  if Circle1.Visible then
    OcultarFigura(Circle1)
  else
    MostrarFigura(Circle1);
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  if Ellipse1.Visible then
    OcultarFigura(Ellipse1)
  else
    MostrarFigura(Ellipse1);
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  if Rectangle1.Visible then
    OcultarFigura(Rectangle1)
  else
    MostrarFigura(Rectangle1);
end;

procedure TForm2.ColorPicker1Change(Sender: TObject);
var
  NuevoColor: TAlphaColor;
begin
  NuevoColor := ColorPicker1.Color;
  if Circle1.Visible then
    Circle1.Fill.Color := NuevoColor
  else if Ellipse1.Visible then
    Ellipse1.Fill.Color := NuevoColor
  else if Rectangle1.Visible then
    Rectangle1.Fill.Color := NuevoColor;
end;

end.

