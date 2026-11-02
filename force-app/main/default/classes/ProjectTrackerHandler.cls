public with sharing class ProjectTrackerHandler {
    public static void beforeInsert(List<Project_Tracker__c> newProjects) {
        validateProjects(newProjects);
    }

    public static void beforeUpdate(List<Project_Tracker__c> newProjects, Map<Id, Project_Tracker__c> oldMap) {
        validateProjects(newProjects);
        processHighPriorityProjects(newProjects, oldMap);
    }

    private static void validateProjects(List<Project_Tracker__c> projects) {
        for (Project_Tracker__c p : projects) {
            if (p.Budget__c != null && p.Budget__c < 0) {
                p.Budget__c.addError('Budget cannot be a negative value.');
            }
        }
    }

    private static void processHighPriorityProjects(List<Project_Tracker__c> projects, Map<Id, Project_Tracker__c> oldMap) {
        for (Project_Tracker__c p : projects) {
            Project_Tracker__c oldP = oldMap.get(p.Id);
            if (p.Budget__c != null && p.Budget__c > 500000 && !oldP.High_Priority__c) {
                p.High_Priority__c = true;
            }
        }
    }
}