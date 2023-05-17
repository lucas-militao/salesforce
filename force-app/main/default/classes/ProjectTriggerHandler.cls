public with sharing class ProjectTriggerHandler extends TriggerHandler {
    
    public override void afterUpdate() {
        Map<Id, Project__c> newMap = (Map<Id, Project__c>) Trigger.newMap;
        Map<Id, Project__c> oldMap = (Map<Id, Project__c>) Trigger.oldMap;

        Map<Id, Project__c> mapOfProjectsToUpdate = new Map<Id, Project__c>();
        for (Id projectId : newMap.keyset()) {
            Project__c newProject = newMap.get(projectId);
            Project__c oldProject = oldMap.get(projectId);

            if (newProject.Status__c == 'Billable' && newProject.Status__c != null) {
                mapOfProjectsToUpdate.put(projectId, newProject);
            }
        }

        if (mapOfProjectsToUpdate.size() > 0) {
            ProjectTriggerHelper.billingCalloutServiceCall(mapOfProjectsToUpdate);
        }
    }   
}