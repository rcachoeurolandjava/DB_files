update selenium_data.detailed_crawled_data dd set company_code = cm.euroland_code
FROM selenium_data.company_match cm  
where dd.source_name = cm.source_name AND cm.is_confirmed = true AND				   
			(dd.isin is null OR dd.isin = '' OR cm.crawled_isin = dd.isin) AND
		    (dd.company is null OR dd.company = '' OR cm.crawled_name = dd.company) AND
			(dd.symbol is null OR dd.symbol = '' OR cm.crawled_symbol = dd.symbol)