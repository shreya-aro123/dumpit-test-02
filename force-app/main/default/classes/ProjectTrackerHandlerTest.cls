@isTest
private class ProjectTrackerHandlerTest {
    @TestSetup
    static void setupData() {
        Project_Tracker__c proj = new Project_Tracker__c(
            Name = 'Enterprise Deployment',
            Status__c = 'In Progress',
            Budget__c = 100000
        );
        insert proj;

        Contact con = new Contact(FirstName = 'Alex', LastName = 'Salesforce');
        insert con;

        Project_Member__c pm = new Project_Member__c(
            Project_Tracker__c = proj.Id,
            Contact__c = con.Id,
            Allocated_Hours__c = 40
        );
        insert pm;
    }

    @isTest
    static void testPositiveBudget() {
        Project_Tracker__c proj = [SELECT Id, Status__c, Budget__c FROM Project_Tracker__c LIMIT 1];
        proj.Budget__c = 250000;
        Test.startTest();
        update proj;
        Test.stopTest();
        
        Project_Tracker__c updatedProj = [SELECT Budget__c FROM Project_Tracker__c WHERE Id = :proj.Id];
        System.assertEquals(250000, updatedProj.Budget__c, 'Budget should be updated');
    }

    @isTest
    static void testNegativeBudgetValidation() {
        Project_Tracker__c proj = new Project_Tracker__c(
            Name = 'Invalid Project',
            Status__c = 'New',
            Budget__c = -100
        );

        Test.startTest();
        try {
            insert proj;
            System.assert(false, 'Expected validation error for negative budget');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Budget cannot be a negative value'), 'Correct error message expected');
        }
        Test.stopTest();
    }

    @isTest
    static void testHighPriorityAutoFlag() {
        Project_Tracker__c proj = [SELECT Id, High_Priority__c, Budget__c FROM Project_Tracker__c LIMIT 1];
        proj.Budget__c = 750000;
        
        Test.startTest();
        update proj;
        Test.stopTest();

        Project_Tracker__c updated = [SELECT High_Priority__c FROM Project_Tracker__c WHERE Id = :proj.Id];
        System.assertEquals(true, updated.High_Priority__c, 'High Priority flag should be automatically checked for large budgets');
    }
}