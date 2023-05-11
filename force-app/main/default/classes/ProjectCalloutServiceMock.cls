@isTest
global class ProjectCalloutServiceMock implements HttpCalloutMock {
   global static HttpResponse respond(HttpRequest request) {
      HttpResponse response = new HttpResponse();
      response.setEndPoint('callout:ProjectService');
      response.setHeader('Content-Type', 'application/json');
      response.setBody('OK');
      response.setStatusCode(201);
      return response;
  }
}