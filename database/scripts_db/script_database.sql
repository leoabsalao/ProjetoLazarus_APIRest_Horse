create table tb_produto_categoria (
  id integer not null primary key autoincrement,
  categoria varchar(100)
);

create table tb_produto (
  id integer not null primary key autoincrement,
  nome varchar(100),
  descricao varchar(200),
  preco decimal(9,2),
  foto varchar(1000)
);

create table tb_cliente(
  id integer not null primary key autoincrement,
  fone varchar(20),
  endereco varchar(200)
);

create table tb_config(
   vl_entrega decimal(9,2)
);

create table tb_pedido(  
   id integer not null primary key autoincrement,
   id_cliente integer,
   endereco varchar(200),
   fone varchar(20),
   vl_subtotal decimal(9,2),
   vl_entrega decimal(9,2),
   vl_total decimal(9,2),
   dt_pedido datetime,
   status char(1) -- A (Aberto)  C (Cancelado)  E (saiu Entrega) F (Finalizado) 
);

create table tb_pedido_item(
   id integer not null primary key autoincrement,
   id_pedido integer,
   id_produto integer,
   qtd decimal(9,3),
   vl_unitario decimal(9,2),
   vl_total decimal(9,2)
);








