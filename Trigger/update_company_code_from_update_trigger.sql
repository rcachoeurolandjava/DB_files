CREATE TRIGGER update_company_code_from_update_trigger
  AFTER UPDATE
  ON selenium_data.company_match
  FOR EACH ROW
  EXECUTE PROCEDURE selenium_data.update_company_code_from_update();