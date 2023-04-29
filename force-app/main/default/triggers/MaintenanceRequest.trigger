trigger MaintenanceRequest on Case (after update) {
    new MaintenanceRequestTriggerHandler().run();
}