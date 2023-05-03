@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    @IsTest
    static void testWareHouseCallout(){
        Test.startTest();
        Test.setMock(HTTPCalloutMock.class, new WarehouseCalloutServiceMock());
        WarehouseCalloutService.getEquipmentHttpCallout();
        Test.stopTest();
        System.assertEquals(4, [SELECT count() FROM Product2]);
    }
}