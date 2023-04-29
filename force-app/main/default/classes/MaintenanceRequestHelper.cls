public with sharing class MaintenanceRequestHelper {
    
    public void createNewRoutineMaintenance(Map<Id, MaintenanceRequestModel.MaintenanceRequestInfo> requests) {
        Map<Id, Case> newRequestsToCreate = new Map<Id, Case>(); //Key -> Closed Request's Id

        for(Id requestId : requests.keyset()) {
            MaintenanceRequestModel.MaintenanceRequestInfo request = requests.get(requestId);
            
            Case newRequest = new Case(
                Type = 'Routine Maintenance',
                Subject = String.isEmpty(request.subject) ? 'Routine Maintenance' : request.subject,
                Vehicle__c = request.vehicle,
                Date_Due__c = this.getDueDate(request.equipments)
            );

            newRequestsToCreate.put(requestId, newRequest);
        }

        insert newRequestsToCreate.values();

        List<Equipment_Maintenance_Item__c> newRequestsItems = new List<Equipment_Maintenance_Item__c>();
        for(Id requestId : requests.keyset()) {
            MaintenanceRequestModel.MaintenanceRequestInfo request = requests.get(requestId);
            Case newRequest = newRequestsToCreate.get(requestId);

            for(Id equipmentId : request.equipments.keyset()) {
                MaintenanceRequestModel.Equipment equipment = request.equipments.get(equipmentId);

                newRequestsItems.add(new Equipment_Maintenance_Item__c(
                    Maintenance_Request__c = newRequest.id,
                    Equipment__c = equipmentId
                ));
            }
        }

        insert newRequestsItems;
    }

    public Date getDueDate(Map<Id, MaintenanceRequestModel.Equipment> equipments) {
        DateTime dueDate = System.now();
        Double days = 0;

        for(MaintenanceRequestModel.Equipment equipment : equipments.values()) {
            if (days > equipment.maintenanceCycle || days == 0) {
                days = equipment.maintenanceCycle;
            }
        }

        return dueDate.addDays(days.IntValue()).Date();
    }
}