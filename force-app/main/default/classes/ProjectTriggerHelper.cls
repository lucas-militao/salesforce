public with sharing class ProjectTriggerHelper {
    
    public static void billingCalloutServiceCall(Map<Id, Project__c> projects) {
        Map<String, Project__c> projectsWithRef = new Map<String, Project__c>();
        for (Id projectId : projects.keyset()) {
            Project__c project = projects.get(projectId);

            BillingCalloutService.callBillingService(project.ProjectRef__c, project.Billable_Amount__c);
        }
    }
}