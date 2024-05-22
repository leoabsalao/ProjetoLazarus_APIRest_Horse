unit Controllers.Cardapio;

interface

uses Horse,
     System.JSON,
     System.SysUtils,
     DataModule.Global;

procedure RegistrarRotas;
procedure ListarCardapios(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RegistrarRotas;
begin
    THorse.Get('/cardapios', ListarCardapios);
end;

procedure ListarCardapios(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    dm: TDm;
begin
    try
        dm := TDm.Create(nil);

        Res.Send(dm.ListarCardapios).Status(200);

    finally
        FreeAndNil(dm);
    end;
end;



end.
