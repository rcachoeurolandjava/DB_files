CREATE OR REPLACE FUNCTION selenium_data.update_company_code_from_update()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF 
AS $BODY$
declare 
	company_code_value text;
	ext boolean;
begin
	ext := false;
	IF EXISTS (select euroland_code from selenium_data.company_match where source_name = NEW.source_name) THEN
		if exists (select euroland_code from selenium_data.company_match where crawled_isin = NEW.isin) AND ext = false then
			company_code_value := (select euroland_code from selenium_data.company_match where crawled_isin = NEW.isin);
			ext := true;
		end if;
		if exists (select crawled_name from selenium_data.company_match where crawled_symbol = NEW.symbol) AND ext = false then
			if exists (select euroland_code from selenium_data.company_match where crawled_name = NEW.company) then
				company_code_value := (select crawled_name from selenium_data.company_match where crawled_symbol = NEW.symbol);
				ext := true;
			end if;
		end if;
		if exists (select euroland_code from selenium_data.company_match where crawled_name = NEW.company) AND ext = false then
			company_code_value := (select euroland_code from selenium_data.company_match where crawled_name = NEW.company);
		end if;
	END IF;
	
	if company_code_value is not null then 
		 NEW.company_code := company_code_value;
	end if;
			   
    RETURN NEW;
END;
$BODY$;