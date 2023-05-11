@isTest
global class ProjectCalloutServiceMockFailure implements HttpCalloutMock  {
   global static HttpResponse respond(HttpRequest request) {
      HttpResponse response = new HttpResponse();
      response.setHeader('Content-Type', 'application/json');
      response.setBody('Error');
      response.setStatusCode(500);
      return response;
   }
}