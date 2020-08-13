select ev.contract_id, 
	ci.deleted, cb.deleted, 
	ci.total_amount, ev.v_total_amount, (ev.v_total_amount+ci.total_amount) as diff,
	frt.document_amount, frt.title_amount, frt.issue_date, frt.title 
from contract_eventual_values ev 
	join contract_items ci on ci.id = ev.contract_item_id 
	join contracts c on c.id = ev.contract_id and c.deleted = 0 and c.status not in (4,9) and invoice_type != 5
	join financial_receivable_titles frt on frt.contract_id = ev.contract_id and frt.competence = ev.month_year and frt.deleted = 0 and frt.bill_title_id is null 
	left join contract_configuration_billings cb on cb.id = ev.contract_configuration_billing_id 
where ev.deleted  = 0
	and ev.invoiced = 0 -- nao faturado
	and ev.month_year = '2020-05-01'
	and exists (select * from financial_receivable_titles frt2 where frt.id = frt2.bill_title_id and frt2.origin in (4,44))
order by ev.contract_id;