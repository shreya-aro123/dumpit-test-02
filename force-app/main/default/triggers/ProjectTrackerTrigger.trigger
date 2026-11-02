trigger ProjectTrackerTrigger on Project_Tracker__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            ProjectTrackerHandler.beforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            ProjectTrackerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}