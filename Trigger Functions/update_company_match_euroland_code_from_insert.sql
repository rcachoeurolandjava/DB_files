CREATE FUNCTION selenium_data.update_company_match_euroland_code_from_insert()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF 
AS $BODY$
begin
	IF NEW.is_confirmed = true AND NEW.euroland_code is not null THEN
	update selenium_data.detailed_crawled_data 
	set company_code = NEW.euroland_code
	where source_name = NEW.source_name AND
		  (isin is null OR isin = '' OR isin = NEW.crawled_isin) AND
		  (symbol is null OR symbol = '' OR symbol = NEW.crawled_symbol) AND
		  (company is null OR symbol = '' OR company = NEW.crawled_name);
	END IF;
    RETURN NEW;
END;
$BODY$;
