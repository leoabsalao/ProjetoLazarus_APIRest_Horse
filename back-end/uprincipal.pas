unit uPrincipal;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs;

type

  { TfPrincipal }

  TfPrincipal = class(TForm)
    procedure FormActivate(Sender: TObject);
  private

  public

  end;

var
  fPrincipal: TfPrincipal;

implementation

uses
    Horse,
    Horse.CORS,
    Horse.Jhonson,
    uControllers.Cardapio,
    uControllers.Pedidos,
    uControllers.Config;

{$R *.lfm}

{ TfPrincipal }

procedure TfPrincipal.FormActivate(Sender: TObject);
begin
   THorse.Use(Jhonson())
         .Use(CORS);

   uControllers.Cardapio.RegistrarRotas;
   uControllers.Pedidos.RegistrarRotas;
   uControllers.Config.RegistrarRotas;
   THorse.Listen(3000);
end;

end.

