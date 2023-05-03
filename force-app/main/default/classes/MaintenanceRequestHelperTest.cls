@isTest
public with sharing class MaintenanceRequestHelperTest {
    @TestSetup
    public static void makeData(){
        Vehicle__c vehicle = new Vehicle__c(name = 'Test Vehicle');
        insert vehicle;

        List<Product2> equipments = new List<Product2>();
        for(Integer i = 0; i < 4; i++) {
            equipments.add(new Product2(Name = 'Test Equipment', 
            Maintenance_Cycle__c = i + 1,
            Cost__c = i * 10,
            Current_Inventory__c = i + 1,
            Lifespan_Months__c = i + 1,
            Replacement_Part__c = true,
            Warehouse_SKU__c = 'abc'));
        }
        insert equipments;

        List<Case> requests = new List<Case>();
        requests.add(new Case(Type = 'Routine Maintenance',Status = 'New', Origin = 'Phone', Vehicle__c = vehicle.id));
        requests.add(new Case(Type = 'Repair',Status = 'New', Origin = 'Phone', Vehicle__c = vehicle.id));
        insert requests;

        List<Equipment_Maintenance_Item__c> requestItems = new List<Equipment_Maintenance_Item__c>();
        requestItems.add(new Equipment_Maintenance_Item__c(Equipment__c = equipments[0].id, Maintenance_Request__c = requests[0].id));
        requestItems.add(new Equipment_Maintenance_Item__c(Equipment__c = equipments[1].id, Maintenance_Request__c = requests[0].id));
        requestItems.add(new Equipment_Maintenance_Item__c(Equipment__c = equipments[2].id, Maintenance_Request__c = requests[1].id));
        requestItems.add(new Equipment_Maintenance_Item__c(Equipment__c = equipments[3].id, Maintenance_Request__c = requests[1].id));
        insert requestItems;
    }

    @isTest
    public static void testRequestCreation() {
        List<Case> requestsToClose = [SELECT Id FROM Case];
        for(Case request: requestsToClose) {
            request.Status = 'Closed';
        }
        update requestsToClose;

        List<Case> openRequests = [SELECT Id FROM Case WHERE Status = 'New'];

        System.assertEquals(2, openRequests.size());
    }
}