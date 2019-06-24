CREATE OR REPLACE FUNCTION selenium_data.update_company_code_from_update()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF 
AS $BODY$
begin
	if(NEW.euroland_code <> OLD.euroland_code) then
		UPDATE selenium_data.detailed_crawled_data
		SET company_code = NEW.euroland_code
		WHERE source_name = NEW.source_name
		AND company = NEW.crawled_name;
	 END IF;
    RETURN NEW;
END;
$BODY$;