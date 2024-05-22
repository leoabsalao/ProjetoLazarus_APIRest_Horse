unit Controllers.Pedido;

interface

uses Horse,
     System.JSON,
     System.SysUtils,
     DataModule.Global;

procedure RegistrarRotas;
procedure ListarPedidos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure InserirPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RegistrarRotas;
begin
    THorse.Get('/pedidos', ListarPedidos);
    THorse.Post('/pedidos', InserirPedido);
end;

procedure ListarPedidos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    dm: TDm;
begin
    try
        dm := TDm.Create(nil);

        Res.Send(dm.ListarPedidos).Status(200);

    finally
        FreeAndNil(dm);
    end;
end;

procedure InserirPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    dm: TDm;
    body: TJSONObject;
    id_usuario: integer;
    endereco, fone: string;
    vl_subtotal, vl_entrega, vl_total: double;
    itens: TJSONArray;
begin
    try
        try
            dm := TDm.Create(nil);

            body := Req.Body<TJSONObject>;
            id_usuario := body.GetValue<integer>('id_usuario', 0);
            endereco := body.GetValue<string>('endereco', '');
            fone := body.GetValue<string>('fone', '');
            vl_subtotal := body.GetValue<double>('vl_subtotal', 0);
            vl_entrega := body.GetValue<double>('vl_entrega', 0);
            vl_total := body.GetValue<double>('vl_total', 0);
            itens := body.GetValue<TJSONArray>('itens');

            Res.Send(dm.InserirPedido(id_usuario, endereco, fone, vl_subtotal,
                                    vl_entrega, vl_total, itens)).Status(201);

        except on ex:exception do
            Res.Send('Ocorreu um erro: ' + ex.Message).Status(500);
        end;

    finally
        FreeAndNil(dm);
    end;
end;



end.

