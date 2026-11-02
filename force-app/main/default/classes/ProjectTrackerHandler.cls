public with sharing class ProjectTrackerHandler implements ITriggerHandler {
    
    public void beforeInsert(List<SObject> newItems) {
        validateProjects((List<Project_Tracker__c>) newItems);
    }

    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        validateProjects((List<Project_Tracker__c>) newItems.values());
        evaluateHighPriorityThreshold((List<Project_Tracker__c>) newItems.values(), (Map<Id, Project_Tracker__c>) oldItems);
    }

    public void afterInsert(Map<Id, SObject> newItems) {}

    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        List<Id> asyncAuditIds = new List<Id>();
        for (Project_Tracker__c p : (List<Project_Tracker__c>) newItems.values()) {
            Project_Tracker__c oldP = (Project_Tracker__c) oldItems.get(p.Id);
            if (p.Budget__c != null && p.Budget__c > 1000000 && !p.High_Priority__c) {
                asyncAuditIds.add(p.Id);
            }
        }
        if (!asyncAuditIds.isEmpty() && !System.isQueueable()) {
            System.enqueueJob(new ProjectAuditQueueable(asyncAuditIds));
        }
    }

    private static void validateProjects(List<Project_Tracker__c> projects) {
        Project_Setting__mdt settings = Project_Setting__mdt.getInstance('Global_Defaults');
        Decimal maxLimit = settings != null && settings.Max_Budget__c != null ? settings.Max_Budget__c : 10000000.0;

        for (Project_Tracker__c p : projects) {
            if (p.Budget__c != null && p.Budget__c < 0) {
                p.Budget__c.addError('Budget cannot be a negative value.');
            }
            if (p.Budget__c != null && p.Budget__c > maxLimit) {
                p.Budget__c.addError(System.Label.Budget_Cap_Exceeded_Error);
            }
        }
    }

    private static void evaluateHighPriorityThreshold(List<Project_Tracker__c> projects, Map<Id, Project_Tracker__c> oldMap) {
        for (Project_Tracker__c p : projects) {
            Project_Tracker__c oldP = oldMap.get(p.Id);
            if (p.Budget__c != null && p.Budget__c >= 500000 && !oldP.High_Priority__c) {
                p.High_Priority__c = true;
            }
        }
    }
}