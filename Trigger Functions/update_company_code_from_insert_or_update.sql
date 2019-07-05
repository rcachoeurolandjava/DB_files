CREATE FUNCTION selenium_data.update_company_code_from_insert_or_update()
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
		  (NEW.crawled_isin is null OR NEW.crawled_isin = '' OR isin = NEW.crawled_isin) AND
		  (NEW.crawled_symbol is null OR NEW.crawled_symbol = '' OR symbol = NEW.crawled_symbol) AND
		  (NEW.crawled_name is null OR NEW.crawled_name = '' OR company = NEW.crawled_name);
	END IF;
    RETURN NEW;
END;
$BODY$;