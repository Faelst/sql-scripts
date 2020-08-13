select
	c.*
from contract_configuration_billings ccb
	join people p on p.id = ccb.client_id
	join contracts c on c.id = ccb.contract_id and c.deleted = 0 and c.stage = 3 and c.status in (1,6,7)
	join contract_items ci on ci.contract_configuration_billing_id = ccb.id and ci.deleted = 0 and ci.demonstration = 0 and ci.total_amount > 0
where ccb.deleted = 0
	and ccb.company_place_id = 2
    and p.type_tx_id = 2