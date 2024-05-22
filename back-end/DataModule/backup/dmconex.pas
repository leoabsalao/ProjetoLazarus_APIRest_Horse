unit DMConex;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset, SQLDB, DataSet.Serialize.Config,
  DataSet.Serialize, Horse.Jhonson, fpjson, jsonparser;

type

  { TDM }

  TDM = class(TDataModule)
    zConex: TZConnection;
    procedure DataModuleCreate(Sender: TObject);
  private

  public
    function ListarConfig: TJSONObject;
    function ListarCardapios: TJSONArray;
    function ListarPedidos: TJSONArray;
    function InserirPedido(id_cliente: integer;
                           endereco, fone: string;
                           vl_subtotal, vl_entrega, vl_total: double; itens: TJSONArray): string;
  end;

var
  DM: TDM;

implementation

{$R *.lfm}

var
   qry : TZQuery;

{ TDM }

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
end;

function TDM.ListarConfig: TJSONObject;
begin
  try
    qry := TZQuery.Create(nil);
    qry.Connection := zConex;

    qry.SQL.Add('select * from tb_config');
    qry.Active := true;

    Result := qry.ToJSONObject;
  finally
    FreeAndNil(qry);
  end;
end;

function TDM.ListarCardapios: TJSONArray;
begin
  try
    qry := TZQuery.Create(nil);
    qry.Connection := zConex;

    qry.SQL.Add(' select p.id, pc.categoria, p.descricao, p.nome, p.preco, p.foto  ');
    qry.SQL.Add(' from tb_produto p, tb_produto_categoria pc                       ');
    qry.SQL.Add(' where p.id_categoria = pc.id                                     ');
    qry.SQL.Add(' order by pc.ordem, p.ordem                                       ');
    qry.Active := true;

    Result := qry.ToJSONArray;
  finally
    FreeAndNil(qry);
  end;
end;

function TDM.ListarPedidos: TJSONArray;
var
   i: integer;
   ped: TJSONObject;
begin
   try
    qry := TZQuery.Create(nil);
    qry.Connection := zConex;

    qry.SQL.Add(' select p.id, strftime(''%d/%m/%Y %H:%M'',p.dt_pedido) as dt_pedido, p.id_cliente, p.fone, p.vl_entrega, ');
    qry.SQL.Add(' p.vl_subtotal, p.vl_total, p.endereco, p.status from tb_pedido p                                        ');
    qry.Active := true;

    Result := qry.ToJSONArray;

    // Fazendo um loop nos pedidos...
    for i := 0 to Result.Count -1 do
    begin
      ped := TJSONObject(Result[i]);
      // consulta dos itens.
      qry.Active := false;
      qry.SQL.Clear;
      qry.SQL.Add(' select pi.id_produto, pi.qtd, pi.vl_unitario, pi.vl_total ');
      qry.SQL.Add(' from tb_pedido_item pi where pi.id_pedido =:id_pedido     ');
      qry.SQL.Add(' order by pi.id                                            ');
      qry.ParamByName('id_pedido').Value := ped.Get('id');
      qry.Active := true;
      ped.Add('itens', qry.ToJSONArray);
    end;

   finally
    FreeAndNil(qry);
   end;
end;

function TDM.InserirPedido(id_cliente: integer; endereco, fone: string;
  vl_subtotal, vl_entrega, vl_total: double; itens: TJSONArray): string;
var
  i, id_pedido: integer;
  item: TJSONObject;
begin
  try
    qry := TZQuery.Create(nil);
    qry.Connection := zConex;

    qry.SQL.Add(' insert into tb_pedido (id_cliente,endereco,fone,vl_subtotal,vl_entrega,vl_total,dt_pedido,status) values ');
    qry.SQL.Add(' (:id_cliente,:endereco,:fone,:vl_subtotal,:vl_entrega,:vl_total,:dt_pedido,:status);                     ');
    // Parâmetros de inserção
    qry.ParamByName('id_cliente').Value := id_cliente;
    qry.ParamByName('endereco').Value := endereco;
    qry.ParamByName('fone').Value := fone;
    qry.ParamByName('vl_subtotal').Value := vl_subtotal;
    qry.ParamByName('vl_entrega').Value := vl_entrega;
    qry.ParamByName('vl_total').Value := vl_total;
    qry.ParamByName('dt_pedido').Value := FormatDateTime('yyyy-mm-dd HH:nn:ss',Now);
    qry.ParamByName('status').Value := 'A';
    // -----------------------
    qry.ExecSQL;

    // consultando o último registro da tabela de pedidos...
    qry.active := false;
    qry.SQL.Clear;
    qry.SQL.Add(' select max(id) as id_pedido from tb_pedido ');
    qry.Active := True;

    // Tratamento dos itens...
    id_pedido := qry.FieldByName('id_pedido').AsInteger;

    for i := 0 to itens.Count - 1 do
    begin
       item := TJSONObject(itens[i]);
       qry.active := false;
       qry.SQL.Clear;
       qry.SQL.Add(' insert into tb_pedido_item (id_pedido, id_produto, qtd, vl_unitario, vl_total) values ');
       qry.SQL.Add(' (:id_pedido, :id_produto, :qtd, :vl_unitario, :vl_total)                              ');
       // Parâmetros de inserção dos itens...
       qry.ParamByName('id_pedido').Value := id_pedido;
       qry.ParamByName('id_produto').Value := item.Get('id_produto');
       qry.ParamByName('qtd').Value := item.Get('qtd');
       qry.ParamByName('vl_unitario').Value := item.Get('vl_unitario');
       qry.ParamByName('vl_total').Value := item.Get('vl_total');
       qry.ExecSQL;
    end;

    Result := 'Pedido inserido com sucesso.';
  finally
    FreeAndNil(qry);
    FreeAndNil(itens);
  end;
end;

end.

