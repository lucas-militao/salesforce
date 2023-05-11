@RestResource(urlMapping='/project')
global class ProjectRESTService {
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status) {
        Savepoint sp = Database.setSavepoint();
        Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Id = :opportunityId];
        
        opportunity.DeliveryInstallationStatus__c = 'In progress';
        Project__c thisProject = new Project__c(
            ProjectRef__c = ProjectRef,
            Name = ProjectName,
            Opportunity__c = OpportunityId,
            Start_Date__c = StartDate,
            End_Date__c = EndDate,
            Billable_Amount__c = Amount,
            Status__c = Status
        );

        try {
            List<SObject> upsertObjects = new List<SObject>{thisProject, opportunity};
            upsert upsertObjects;
            return 'OK';         
        } catch (Exception e) {
            Database.Rollback(sp);
            return e.getMessage();
        }
    }
}