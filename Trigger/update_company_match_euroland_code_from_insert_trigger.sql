CREATE TRIGGER update_company_match_euroland_code_from_insert_trigger
    AFTER INSERT
    ON selenium_data.company_match
    FOR EACH ROW
    EXECUTE PROCEDURE selenium_data.update_company_match_euroland_code_from_insert();