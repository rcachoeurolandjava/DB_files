CREATE TRIGGER new_data_trigger
  AFTER INSERT
  ON selenium_data.crawl_data
  FOR EACH ROW
  EXECUTE PROCEDURE selenium_data.newdata_added();