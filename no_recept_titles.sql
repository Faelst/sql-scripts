select 
	frt.company_place_id as local,
	frt.id as id_fat,
    frt.client_id as id_cliente,
    frt.title as title,
    frt.document_amount as valor_fat,
	frt.issue_date as data_emissao,
    frt.competence as Competencia,
    frt.expiration_date as Data_Venc
from financial_receivable_titles frt 
where frt.deleted = 0
  and frt.bill_title_id is null /* exclui os títulos da faturas */
  and exists (
    select * 
    from financial_receivable_titles frt2 
    where frt2.bill_title_id = frt.id
      and frt2.origin != 11 /* origem de renegociação */
  )
  and not exists ( select
				*
                from financial_receipt_titles frt3 
					where frt3.financial_receivable_title_id = frt.id 
                    and frt3.deleted = 0)
                    