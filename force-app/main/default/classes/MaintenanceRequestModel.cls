public without sharing class MaintenanceRequestModel {
    public class MaintenanceRequestInfo {
        public Id id {get;set;}
        public String Status {get;set;}
        public Id vehicle {get;set;}
        public String subject {get;set;}
        public String type {get;set;}
        public Map<Id, Equipment> equipments {get;set;} 
    }

    public class Equipment {
        public Id id {get;set;}
        public Double maintenanceCycle {get;set;} 
    }
}