unit uControllers.Config;

{$mode delphi}{$H+}


interface

uses
  Classes, SysUtils, Horse, Horse.Jhonson, fpjson;

procedure ListarConfig(Req: THorseRequest; Res: THorseResponse);
procedure RegistrarRotas;

implementation

uses DMConex;

procedure ListarConfig(Req: THorseRequest; Res: THorseResponse);
var
  dm : TDM;
begin
   try
     dm := TDM.Create(nil);
     Res.Send<TJSONObject>(dm.ListarConfig);
   finally
     FreeAndNil(dm);
   end;
end;

procedure RegistrarRotas;
begin
   THorse.Get('/configs',ListarConfig);
end;

end.

