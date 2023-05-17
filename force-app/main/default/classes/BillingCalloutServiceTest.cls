@isTest
private class BillingCalloutServiceTest {
  @TestSetup
  static void makeData(){
    Account accountTest = new Account(Name = 'Test Account');
    insert accountTest;

    Opportunity opportunityTest = new Opportunity(
      Name = 'Opportunity Test',
      AccountId = accountTest.Id,
      DeliveryInstallationStatus__c = 'In progress',
      StageName = 'Prospecting',
      CloseDate = Date.today().addDays(10)
    );
    insert opportunityTest;

    Project__c projectTest = new Project__c(
      Billable_Amount__c = 200,
      Name = 'Test Project',
      Opportunity__c = opportunityTest.Id,
      ProjectRef__c = '112233'
    );
    insert projectTest;

    ServiceCredentials__c credentials = new ServiceCredentials__c();
    credentials.Name = 'BillingServiceCredential';
    credentials.Username__c = 'pmsUser1';
    credentials.Password__c = 'pmsUser1';
    insert credentials;
  }

  @isTest
  public static void testBillingCalloutSuccess() {
    Project__c project = [SELECT Id, Billable_Amount__c, ProjectRef__c FROM Project__c LIMIT 1];
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
    
    Test.startTest();
    project.Status__c = 'Billable';
    update project;
    Test.stopTest();
  
  }
  @isTest
  public static void testBillingCalloutFailure() {
    Project__c project = [SELECT Id, Billable_Amount__c, ProjectRef__c FROM Project__c LIMIT 1];
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
    
    Test.startTest();
    project.Status__c = 'Billable';
    update project;
    Test.stopTest();
  }
}