/* 
   REFERENCE LINK SOAP Callout Test: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_callouts_wsdl2apex_testing.htm
 */
@isTest
global class BillingCalloutServiceMock implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {

      BillingServiceProxy.billProjectResponse_element response_x = new BillingServiceProxy.billProjectResponse_element();

      response_x.status = 'OK';
      response.put('response_x', response_x);
   }
}