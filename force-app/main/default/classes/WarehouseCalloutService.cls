public with sharing class WarehouseCalloutService implements Queueable {
    public void execute(QueueableContext context) {
        
    }

    public static Map<String, EquipmentCalloutResponse> getEquipmentHttpCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        Map<String, EquipmentCalloutResponse> equipmentsResponse = new Map<String, EquipmentCalloutResponse>();
        if(response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            List<EquipmentCalloutResponse> equipments = (List<EquipmentCalloutResponse>) JSON.deserialize(response.getBody(), List<EquipmentCalloutResponse>.class);

            for (EquipmentCalloutResponse equipment : equipments) {
                equipmentsResponse.put(equipment.sku, equipment);
            }
        }

        return equipmentsResponse;
    }

    public class EquipmentCalloutResponse {
        public Boolean replacement {get;set;}
        public Integer quantity {get;set;}
        public String name {get;set;}
        public Integer maintenanceperiod {get;set;}
        public Integer lifespan {get;set;}
        public Integer cost {get;set;}
        public String sku {get;set;}
    }
}