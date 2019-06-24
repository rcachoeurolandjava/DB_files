CREATE TRIGGER update_company_code_from_insert_trigger
  BEFORE INSERT
  ON selenium_data.detailed_crawled_data
  FOR EACH ROW
  EXECUTE PROCEDURE selenium_data.update_company_code_from_insert();