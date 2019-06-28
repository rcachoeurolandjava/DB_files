CREATE FUNCTION selenium_data.update_company_code_from_insert()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF 
AS $BODY$
declare 
	company_code_value text;
	cnt integer;
begin
	company_code_value := null;
	SELECT count(*) INTO cnt FROM selenium_data.detailed_crawled_data WHERE id = NEW.id;
	
	if cnt = 1 then
		company_code_value := (select euroland_code from selenium_data.company_match where
			source_name = NEW.source_name AND is_confirmed = true AND				   
			(NEW.isin is null OR NEW.isin = '' OR crawled_isin = NEW.isin) AND
		    (NEW.company is null OR NEW.company = '' OR crawled_name = NEW.company) AND
			(NEW.symbol is null OR NEW.symbol = '' OR crawled_symbol = NEW.symbol)
							  );

		if company_code_value is not null AND company_code_value != '' then
			update selenium_data.detailed_crawled_data set company_code = company_code_value where id = NEW.id;
		end if;
	end if;
			   
    RETURN NEW;
END;
$BODY$;