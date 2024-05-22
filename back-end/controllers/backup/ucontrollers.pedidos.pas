unit uControllers.Pedidos;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Horse, Horse.Jhonson, fpjson, jsonparser;

procedure ListarPedidos(Req: THorseRequest; Res: THorseResponse);
procedure InserirPedidos(Req: THorseRequest; Res: THorseResponse);
procedure RegistrarRotas;

implementation

uses DMConex;

procedure ListarPedidos(Req: THorseRequest; Res: THorseResponse);
var
  dm : TDM;
begin
   try
     dm := TDM.Create(nil);
     Res.Send<TJSONArray>(dm.ListarPedidos);
   finally
     FreeAndNil(dm);
   end;
end;

procedure InserirPedidos(Req: THorseRequest; Res: THorseResponse);
var
  dm: TDM;
  body: TJSONObject;
  id_cliente: integer;
  endereco, fone: string;
  vl_subtotal, vl_entrega, vl_total: double;
  itens: TJSONArray;
begin
   try
     try
       dm := TDM.Create(nil);
       body := Req.Body<TJSONObject>;

       id_cliente  := body.Get('id_cliente');
       endereco    := body.Get('endereco');
       fone        := body.Get('fone');
       vl_subtotal := body.Get('vl_subtotal');
       vl_entrega  := body.Get('vl_entrega');
       vl_total    := body.Get('vl_total');
       itens       := body.Get('itens',itens);


       Res.Send(dm.InserirPedido(id_cliente,endereco,fone,vl_subtotal,vl_entrega,vl_total, itens));
     except on ex:exception do
       Res.Send('Ocorreu um erro: '+ex.Message);
     end;
   finally
     FreeAndNil(dm);
   end;
end;

procedure RegistrarRotas;
begin
   THorse.Get('/pedidos', ListarPedidos);
   THorse.Post('/pedidos', InserirPedidos);
end;

end.

