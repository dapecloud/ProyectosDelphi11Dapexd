program organizador;

uses
  System.StartUpCopy,
  FMX.Forms,
  TForm2 in 'TForm2.pas' {HeaderFooterwithNavigation},
  Productos in 'Productos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(THeaderFooterwithNavigation, HeaderFooterwithNavigation);
  Application.Run;
end.
