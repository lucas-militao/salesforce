trigger MaintenanceRequestTrigger on Case (after update) {
    new MaintenanceRequestTriggerHandler().run();
}