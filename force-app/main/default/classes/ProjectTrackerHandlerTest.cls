@isTest
private class ProjectTrackerHandlerTest {
    @TestSetup
    static void setupData() {
        Account acc = new Account(Name = 'Enterprise Org Test');
        insert acc;

        Project_Tracker__c proj = new Project_Tracker__c(
            Name = 'Core System Refactor',
            Status__c = 'In Progress',
            Budget__c = 250000,
            Account__c = acc.Id
        );
        insert proj;

        Contact con = new Contact(FirstName = 'Dev', LastName = 'Lead', AccountId = acc.Id);
        insert con;

        Project_Member__c pm = new Project_Member__c(
            Project_Tracker__c = proj.Id,
            Contact__c = con.Id,
            Allocated_Hours__c = 160,
            Role__c = 'Architect'
        );
        insert pm;
    }

    @isTest
    static void testValidationAndRollup() {
        Project_Tracker__c proj = [SELECT Id, Total_Allocated_Hours__c, Budget__c FROM Project_Tracker__c LIMIT 1];
        System.assertEquals(160, proj.Total_Allocated_Hours__c, 'Rollup summary should calculate hours');

        proj.Budget__c = -500;
        Test.startTest();
        try {
            update proj;
            System.assert(false, 'Expected negative budget exception');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Budget cannot be a negative value'));
        }
        Test.stopTest();
    }

    @isTest
    static void testQueueableExecution() {
        Project_Tracker__c proj = [SELECT Id, High_Priority__c, Budget__c FROM Project_Tracker__c LIMIT 1];
        proj.Budget__c = 1500000;

        Test.startTest();
        update proj;
        Test.stopTest();

        Project_Tracker__c updatedProj = [SELECT High_Priority__c FROM Project_Tracker__c WHERE Id = :proj.Id];
        System.assertEquals(true, updatedProj.High_Priority__c, 'Async job should set high priority flag');
    }
}