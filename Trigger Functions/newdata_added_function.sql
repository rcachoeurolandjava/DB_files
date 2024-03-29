CREATE OR REPLACE FUNCTION selenium_data.newdata_added()
  RETURNS trigger AS
$$
begin
	
	with a1 as (
	SELECT id, source_id, json_data,
	jsonb_array_elements(json_data)::jsonb ddd
	FROM selenium_data.crawl_data
	where id not in (select crawl_data_id from selenium_data.detailed_crawled_data)
	), a2 as(
	select id, source_id,
  	(SELECT website_name FROM selenium_data.crawl_source WHERE  id = source_id) AS source_name
 	,to_timestamp((SELECT string_agg(p->>'value', ',') FROM jsonb_array_elements(ddd) p WHERE p->>'header' = 'Date')::text, 'MM-dd-yyyy') AS standard_date
 	,(SELECT string_agg(p->>'value', ',') FROM jsonb_array_elements(ddd) p WHERE p->>'header' = 'Original Date') AS original_date
 	,(SELECT string_agg(p->>'value', ',') FROM jsonb_array_elements(ddd) p WHERE p->>'header' = 'Date Description') AS date_description
 	,(SELECT string_agg(p->>'value', ',') FROM jsonb_array_elements(ddd) p WHERE p->>'header' = 'Company Name') AS company
 	,(SELECT string_agg(p->>'value', ',') FROM jsonb_array_elements(ddd) p WHERE p->>'header' = 'Country') AS country
 	,(SELECT string_agg(p->>'value', ',') FROM jsonb_array_elements(ddd) p WHERE p->>'header' = 'Event') AS standard_event
 	,(SELECT string_agg(p->>'value', ',') FROM jsonb_array_elements(ddd) p WHERE p->>'header' = 'Original Event') AS original_event
 	,(SELECT string_agg(p->>'value', ',') FROM jsonb_array_elements(ddd) p WHERE p->>'header' = 'Event Description') AS event_description
 	,(SELECT string_agg(p->>'value', ',') FROM jsonb_array_elements(ddd) p WHERE p->>'header' = 'Period End') AS period_end
 	,(SELECT string_agg(p->>'value', ',') FROM jsonb_array_elements(ddd) p WHERE p->>'header' = 'Symbol') AS symbol
 	,(SELECT string_agg(p->>'value', ',') FROM jsonb_array_elements(ddd) p WHERE p->>'header' = 'ISIN') AS isin
 	,(SELECT string_agg(p->>'value', ',') FROM jsonb_array_elements(ddd) p WHERE p->>'header' = 'Url') AS url
 	,(SELECT string_agg(p->>'value', ',') FROM jsonb_array_elements(ddd) p WHERE p->>'header' = 'Time') AS _time
 	,(SELECT string_agg(p->>'value', ',') FROM jsonb_array_elements(ddd) p WHERE p->>'header' = 'Time Description') AS time_description
 	,(SELECT string_agg(p->>'value', ',') FROM jsonb_array_elements(ddd) p WHERE p->>'header' = 'Time Zone') AS time_zone
	FROM a1 )
	insert into selenium_data.detailed_crawled_data(crawl_data_id, source_id, source_name,
	standard_date, 
	original_date,  date_description, company, country,
	standard_event, original_event, event_description, period_end,
	symbol, isin, url, _time, time_description, time_zone)
	select id, source_id, source_name,
	standard_date, 
	original_date,  date_description, company, country,
	standard_event, original_event, event_description, period_end,
	symbol, isin, url, _time, time_description, time_zone
	from a2
	where id not in (select crawl_data_id from selenium_data.detailed_crawled_data)
;
 
    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';