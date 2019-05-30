CREATE TRIGGER update_detailed_crawled_data_company_code_trigger
  AFTER UPDATE
  ON selenium_data.company_match
  FOR EACH ROW
  EXECUTE PROCEDURE selenium_data.update_detailed_crawled_data_company_code();