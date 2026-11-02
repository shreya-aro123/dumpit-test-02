public with sharing class ProjectAuditQueueable implements Queueable {
    private List<Id> projectIds;

    public ProjectAuditQueueable(List<Id> pIds) {
        this.projectIds = pIds;
    }

    public void execute(QueueableContext context) {
        List<Project_Tracker__c> projectsToUpdate = [
            SELECT Id, High_Priority__c FROM Project_Tracker__c WHERE Id IN :projectIds
        ];
        for (Project_Tracker__c p : projectsToUpdate) {
            p.High_Priority__c = true;
        }
        if (!projectsToUpdate.isEmpty()) {
            update projectsToUpdate;
        }
    }
}