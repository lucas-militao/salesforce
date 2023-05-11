@isTest
private class ProjectCalloutServiceTest {
  @TestSetup
  static void makeData(){
    Account acc = new Account(name = 'ACME Corp, Inc.');

    Opportunity opp = new Opportunity(
      name = 'Super-Duper Big Deal',
      accountId = acc.Id,
      closeDate = Date.today().addDays(3),
      amount = 150000,
      Type = 'New Project',
      StageName = 'Prospecting'
    );

    ServiceTokens__c settingToken = new ServiceTokens__c();
    settingToken.name = 'ProjectServiceToken';
    settingToken.Token__c = '527l8gazmabai3jq45ql';

    insert acc;
    insert opp;
    insert settingToken;
  }

  //Implement mock callout tests here
  @isTest
  static void testProjectCalloutPositiveTest() {
    Opportunity opp = [SELECT Id,Name,Account.Name,CloseDate,Amount FROM Opportunity LIMIT 1];

    Test.setMock(HTTPCalloutMock.class, new ProjectCalloutServiceMock());
    Test.startTest();
    opp.StageName = 'Closed Won';
    update opp;
    Test.stopTest();

    opp = [SELECT Id, StageName FROM Opportunity LIMIT 1];
    System.debug('OPPORTUNITY: ' + opp);
    System.assertEquals('Submitted Project', opp.StageName);
  }
  
  @isTest
  static void testProjectCalloutErrorTest() {
    Opportunity opp = [SELECT Id,Name,Account.Name,CloseDate,Amount FROM Opportunity LIMIT 1];

    Test.setMock(HTTPCalloutMock.class, new ProjectCalloutServiceMockFailure());
    Test.startTest();
    opp.StageName = 'Closed Won';
    update opp;
    
    Test.stopTest();

    opp = [SELECT Id, StageName FROM Opportunity LIMIT 1];
    System.debug('OPPORTUNITY: ' + opp);
    System.assertEquals('Resubmit Project', opp.StageName);
  }
}