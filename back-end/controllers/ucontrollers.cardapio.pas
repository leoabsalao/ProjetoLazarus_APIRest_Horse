unit uControllers.Cardapio;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Horse, Horse.Jhonson, fpjson;

procedure ListarCardapios(Req: THorseRequest; Res: THorseResponse);
procedure RegistrarRotas;

implementation

uses DMConex;

procedure ListarCardapios(Req: THorseRequest; Res: THorseResponse);
var
  dm : TDM;
begin
   try
     dm := TDM.Create(nil);
     Res.Send<TJSONArray>(dm.ListarCardapios);
   finally
     FreeAndNil(dm);
   end;
end;

procedure RegistrarRotas;
begin
   THorse.Get('/cardapios', ListarCardapios);
end;

end.

