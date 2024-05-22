select p.id, pc.categoria, p.descricao, p.nome, p.preco, p.foto 
from tb_produto p, tb_produto_categoria pc
where p.id_categoria = pc.id
order by p.nome