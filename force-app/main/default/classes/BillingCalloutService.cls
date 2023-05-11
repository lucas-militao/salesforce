global class BillingCalloutService {
    //Implement business and callout logic methods here
    @future(callout = true)
    webservice static void callBillingService(String projectRef, Double billingAmount, String username, String password) {
        ServiceCredentials__c srvcCrd = ServiceCredentials__c.getValues('BillingServiceCredential');

        BillingServiceProxy.project projectInst = new BillingServiceProxy.project();
        projectInst.username = srvcCrd.Username__c;
        projectInst.password = srvcCrd.Password__c;
        projectInst.billAmount = billingAmount;
        projectInst.projectId = projectRef;

        BillingServiceProxy.InvoicesPortSoap11 invPortSoapInst = new BillingServiceProxy.InvoicesPortSoap11();
        String response = invPortSoapInst.billProject(projectInst);
    }
}