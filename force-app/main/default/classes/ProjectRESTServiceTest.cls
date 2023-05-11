@isTest
private class ProjectRESTServiceTest {
  //Implement Apex REST service tests here
  @isTest
  public static void testPostRestService() {
    Account acc = new Account(name = 'ACME Corp, Inc.');
    Opportunity opp = new Opportunity(name = 'Super-Duper Big Deal',
      accountId = acc.Id,
      closeDate = Date.today().addDays(3),
      amount = 150000,
      Type = 'New Project',
      StageName = 'Prospecting');
    insert acc;
    insert opp;

    SingleRequestMock fakeResponse = new SingleRequestMock(
        'Referência Teste',
        'Projeto Teste',
        opp.Id,
        Date.today(),
        Date.today().addDays(10),
        200,
        'Running'
    );

    String JsonMsg = JSON.serialize(fakeResponse);

    System.debug(JsonMsg);

    RestRequest request = new RestRequest();
    RestResponse response = new RestResponse();

    request.requestUri = 'https://mindful-shark-wrggf0-dev-ed.trailblaze.my.salesforce.com/services/apexrest/project';
    request.httpMethod = 'POST';
    request.addHeader('Content-Type', 'application/json');
    request.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = request;
    RestContext.response = response;

    Test.startTest();
    String responseRequest = ProjectRESTService.postProjectData(
      fakeResponse.ProjectRef,
      fakeResponse.ProjectName,
      fakeResponse.OpportunityId,
      fakeResponse.StartDate,
      fakeResponse.EndDate,
      fakeResponse.Amount,
      fakeResponse.Status
    );
    Test.stopTest();

    Project__c projectCreated = [SELECT Id FROM Project__c LIMIT 1]; 

    System.assertEquals('OK', responseRequest);
    System.assertNotEquals(null, projectCreated);
  }

  public class SingleRequestMock {       
    public String ProjectRef;
    public String ProjectName;
    public String OpportunityId;
    public Date StartDate;
    public Date EndDate;
    public Double Amount;
    public String Status;
      public SingleRequestMock(String ProjectRef,  String ProjectName,  String OpportunityId,
                                      Date StartDate, Date EndDate, Double Amount, String Status) {
          this.ProjectRef = ProjectRef;
          this.ProjectName = ProjectName;
          this.OpportunityId = OpportunityId;
          this.StartDate = StartDate;
          this.EndDate = EndDate;
          this.Amount = Amount;
          this.Status = Status;
      }
  } 
}