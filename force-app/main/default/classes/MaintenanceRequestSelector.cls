public with sharing class MaintenanceRequestSelector {

    public Map<Id, MaintenanceRequestModel.MaintenanceRequestInfo> getMaintenanceRequestsInfoById(Set<Id> requestsIds) {
        Map<Id, MaintenanceRequestModel.MaintenanceRequestInfo> mapOfMaintenanceRequestsInfo = new Map<Id, MaintenanceRequestModel.MaintenanceRequestInfo>();

        Map<Id, Case> requests = new Map<Id, Case>([SELECT Id, Status, Subject, Type, Vehicle__c FROM Case WHERE Id IN :requestsIds]);
        Map<Id, Equipment_Maintenance_Item__c> requestsItems = new Map<Id, Equipment_Maintenance_Item__c>([SELECT Id, Maintenance_Request__c, Equipment__c, Equipment__r.Maintenance_Cycle__c FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN :requestsIds]);

        for (Id requestId : requests.keyset()) {
            Case request = requests.get(requestId);
            MaintenanceRequestModel.MaintenanceRequestInfo requestModel = new MaintenanceRequestModel.MaintenanceRequestInfo();
            requestModel.id = request.id;
            requestModel.status = request.Status;
            requestModel.vehicle = request.Vehicle__c;
            requestModel.subject = request.Subject;
            requestModel.type = request.Type;
            requestModel.equipments = new Map<Id, MaintenanceRequestModel.Equipment>();
            mapOfMaintenanceRequestsInfo.put(requestModel.id, requestModel);
        }

        Map<Id, MaintenanceRequestModel.Equipment> equipments = new Map<Id, MaintenanceRequestModel.Equipment>();    
        for(Id requestItemId : requestsItems.keyset()) {
            Equipment_Maintenance_Item__c requestItem = requestsItems.get(requestItemId);
            MaintenanceRequestModel.Equipment equipment = new MaintenanceRequestModel.Equipment();
            equipment.Id = requestItem.Equipment__c;
            equipment.maintenanceCycle = requestItem.Equipment__r.Maintenance_Cycle__c;
            mapOfMaintenanceRequestsInfo.get(requestItem.Maintenance_Request__c).equipments.put(equipment.id, equipment);
        }
        
        System.debug('REQUESTS >>>>>');
        System.debug(mapOfMaintenanceRequestsInfo);
        return mapOfMaintenanceRequestsInfo;
    }
}