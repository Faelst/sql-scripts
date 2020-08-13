select 
	ci.service_product_id,
    sp.title,
	count(ci.id)
from contract_items ci
inner join service_products sp on sp.id = ci.service_product_id and sp.service_code_provided = 105 
	where ci.deleted = 0 and ci.demonstration = 0
group by ci.service_product_id