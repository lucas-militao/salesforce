trigger ProjectTrigger on Project__c (after update) {
    //Call the Billing Service callout logic here
    // new ProjectTriggerHandler().run(); //Traildhead requires to call callBillingService from trigger itself to complete the challenge
    for(Project__c prjt : Trigger.new){
        if(prjt.Status__c != null && prjt.Status__c.equals('Billable')){
            BillingCalloutService.callBillingService(prjt.ProjectRef__c, prjt.Billable_Amount__c);
        }
    }
}