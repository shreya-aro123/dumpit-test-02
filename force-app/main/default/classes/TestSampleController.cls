public with sharing class TestSampleController {

    public String welcomeMessage { get; set; }
    public String featureStatus { get; set; }
    public String maxRetryCount { get; set; }

    public TestSampleController() {
        // Set safe defaults first
        welcomeMessage = 'Test data access for Visualforce & Apex class deployment.';
        featureStatus = 'false';
        maxRetryCount = '0';

        // Query Custom Metadata Type records safely
        List<Test_Config__mdt> configs = [
            SELECT Config_Key__c, Config_Value__c
            FROM Test_Config__mdt
            WHERE Config_Key__c IN ('ENABLE_FEATURE_X', 'MAX_RETRY_COUNT')
        ];

        for (Test_Config__mdt config : configs) {
            if (config.Config_Key__c == 'ENABLE_FEATURE_X') {
                featureStatus = config.Config_Value__c;
            } else if (config.Config_Key__c == 'MAX_RETRY_COUNT') {
                maxRetryCount = config.Config_Value__c;
            }
        }
    }
}