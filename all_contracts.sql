select
	c.id,
    cp.description as local,
    tt.name,
    c.description, 
    case
		when c.status = 1 then 'Normal'
		when c.status = 3 then 'Cortesia'
		when c.status = 4 then 'Cancelado'
		when c.status = 5 then 'Suspenso'
		when c.status = 6 then 'Bloqueio Financeiro'
		when c.status = 7 then 'Bloqueio Administrativo'
		when c.status = 9 then 'Encerrado'
		else c.status			
	end as status,
    case
		when c.invoice_type = 1 then 'Mensal (Simples)'
		when c.invoice_type = 2 then 'Múltiplas Operações'
		when c.invoice_type = 3 then 'Comunicação SCM/SVA'
		when c.invoice_type = 4 then 'Antecipado'
		when c.invoice_type = 5 then 'Não prevê faturamento'
		else c.invoice_type
        end as Tipo_de_faturamento,
        c.amount as valor_montante_contrato,
        c.approval_date as data_aprovacao
from contracts c 
	join people p on p.id = c.client_id
    join tx_types tt on tt.id = p.type_tx_id
    join companies_places cp on cp.id = c.company_place_id
where c.deleted = 0 
	and c.status in (1,3,6,7)
    and c.stage in (3)
    