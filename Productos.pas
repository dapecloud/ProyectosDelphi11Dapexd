unit Productos;

interface

uses
  System.SysUtils, System.Classes;

type
  TProducto = class
  public
    Nombre: string;
    Precio: Double;
    Categoria: string;
    function ToString: string; override;
  end;

implementation

{ TProducto }

function TProducto.ToString: string;
begin
  Result := Format('%s - %.2f %s', [Nombre, Precio, Categoria]);
end;

end.
