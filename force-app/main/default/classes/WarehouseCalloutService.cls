public with sharing class WarehouseCalloutService implements Queueable {
    public void execute(QueueableContext context) {
        getEquipmentHttpCallout();
    }

    public static void run() {
        ID jobID = System.enqueueJob(new WarehouseCalloutService());
        System.debug('JOB ID >>>>> ' + jobID);
    }

    @future(callout=true)
    public static void getEquipmentHttpCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        List<Product2> equipmentsToUpdate = new List<Product2>();
        if(response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            List<Object> externalProducts = (List<Object>) JSON.deserializeUntyped(response.getBody()); //desrialize the json response

            equipmentsToUpdate = getEquipmentList(externalProducts);
        }

        System.debug('LIST OF EQUIPMENTS TO UPDATE >>>>>');
        System.debug(equipmentsToUpdate);
        upsert equipmentsToUpdate Warehouse_SKU__c;
    }

    public static List<Product2> getEquipmentList(List<Object> externalProducts) {
        List<Product2> newProducts = new List<Product2>();
        for(Object p : externalProducts)
            {
                Map<String, Object> productMap = (Map<String, Object>) p;
                Product2 pr = new Product2();
                //Map the fields in the response to the appropriate fields in the Equipment object
                pr.Replacement_Part__c = (Boolean)productMap.get('replacement');
                pr.Cost__c = (Integer)productMap.get('cost');
                pr.Current_Inventory__c = (Integer)productMap.get('quantity');
                pr.Lifespan_Months__c = (Integer)productMap.get('lifespan') ;
                pr.Maintenance_Cycle__c = (Integer)productMap.get('maintenanceperiod');
                pr.Warehouse_SKU__c = (String)productMap.get('sku');
                pr.ProductCode = (String)productMap.get('_id');
                pr.Name = (String)productMap.get('name');
                
            
                newProducts.add(pr);
            }

        return newProducts;
    }
}