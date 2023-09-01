program MostradorDeserealizacion;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  MyJsonClasses in 'MyJsonClasses.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
