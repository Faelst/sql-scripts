select c.id, c.description, c.collection_day as dia_vencimento, 
	ci.total_amount, 
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
		when c.expiration_docket = 0 then 'Mês Atual'
		when c.expiration_docket = 1 then 'Mês Seguinte'
		else c.expiration_docket			
	end as Venc_boleto,
	case
		when c.invoice_type = 1 then 'Mensal (Simples)'
		when c.invoice_type = 2 then 'Múltiplas Operações'
		when c.invoice_type = 3 then 'Comunicação SCM/SVA'
		when c.invoice_type = 4 then 'Antecipado'
		when c.invoice_type = 5 then 'Não prevê faturamento'
		else c.invoice_type
	end as tipo_faturamento,
	cev.total_amount as eventual,
	case
		when cev.type = 1 then 'Acréscimo'
		when cev.type = 2 then 'Desconto'
		else cev.type
	end as tipo_eventual
from contracts c 
	join contract_items ci on ci.contract_id = c.id and ci.deleted = 0
	left join contract_eventual_values cev on c.id = cev.contract_id and year(cev.month_year) = 2020 and month(cev.month_year) = 8 and cev.deleted = 0
	left join people_addresses pa on pa.id = c.people_address_id 
    join people p on p.id = c.client_id
where c.status not in (4,9,3,5,6,7)
	and c.deleted = 0
	and c.stage = 3
	and c.final_date >= '2020-05-27' -- data do faturamento
	and not exists (
		select *
		from financial_receivable_titles ft 
		where ft.contract_id = c.id 
			and ft.deleted = 0 -- desconsidera os titulos excluídos
			and ft.`type` != 0 -- desconsidera títulos que estejam aguardando autorização da nota fiscal
			and year(ft.competence) = 2020
			and month(ft.competence) = 8
	  		and ft.sale_request_id is null -- exclui os pedidos de venda
	)
	and ci.total_amount > 0
    and c.operation_id between 26 and 32
    and p.type_tx_id = 2
group by c.id;