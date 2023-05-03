public with sharing class MaintenanceRequestTriggerHandler extends TriggerHandler {
    public static MaintenanceRequestHelper helper = new MaintenanceRequestHelper();
    public static MaintenanceRequestSelector selector = new MaintenanceRequestSelector();
    public static Map<Id, MaintenanceRequestModel.MaintenanceRequestInfo> requests = new Map<Id, MaintenanceRequestModel.MaintenanceRequestInfo>();
    
    public override void afterUpdate() {
        Map<Id, Case> newMap = (Map<Id,Case>) Trigger.newMap;
        Map<Id, Case> oldMap = (Map<Id,Case>) Trigger.oldMap;

        System.debug('REQUEST TRIGGER >>>>> ');
        System.debug(newMap);

        requests = selector.getMaintenanceRequestsInfoById(newMap.keyset());

        map<Id,MaintenanceRequestModel.MaintenanceRequestInfo> newRequestsToCreate = new Map<Id,MaintenanceRequestModel.MaintenanceRequestInfo>();
        for (Id requestId : requests.keyset()) {
            MaintenanceRequestModel.MaintenanceRequestInfo newRequest = requests.get(requestId);

            if ((newRequest.type == 'Repair' || newRequest.type == 'Routine Maintenance') && newRequest.status == 'Closed') {
                newRequestsToCreate.put(requestId, newRequest);
            }
        }

        if (newRequestsToCreate.size() > 0) {
            helper.updateWorkOrders(newRequestsToCreate);
        }
    }
}