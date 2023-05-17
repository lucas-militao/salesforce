//     BillingServiceProxy.project projectInst = new BillingServiceProxy.project();
        //     projectInst.username = srvcCrd.Username__c;
        //     projectInst.password = srvcCrd.Password__c;
        //     projectInst.billAmount = project.Billable_Amount__c;
        //     projectInst.projectId = project.ProjectRef__c;

global class BillingCalloutService {
    //Implement business and callout logic methods here
    @future(callout = true)
    webservice static void callBillingService(String projectRef, Decimal billingAmount) {
        ServiceCredentials__c srvcCrd = ServiceCredentials__c.getValues('BillingServiceCredential');

        BillingServiceProxy.project projectInst = new BillingServiceProxy.project();
        projectInst.username = srvcCrd.Username__c;
        projectInst.password = srvcCrd.Password__c;
        projectInst.billAmount = billingAmount;

        BillingServiceProxy.InvoicesPortSoap11 invPortSoapInst = new BillingServiceProxy.InvoicesPortSoap11();
        String response = invPortSoapInst.billProject(projectInst);

        if (response != null && response.equalsIgnoreCase('OK')) {
            List<Project__c> projectsToUpdate = [SELECT Id FROM Project__c WHERE ProjectRef__c = :projectRef];

            for (Project__c project : projectsToUpdate) {
                project.Status__c = 'Billed';
            }

            update projectsToUpdate;
        }
    }
}