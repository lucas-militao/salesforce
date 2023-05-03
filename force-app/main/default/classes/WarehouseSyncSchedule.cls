public without sharing class WarehouseSyncSchedule implements ScheduledDispatcher.IScheduleDispatched {
    public void execute(SchedulableContext sc) {
        WarehouseCalloutService.getEquipmentHttpCallout();
	}

    public static void abortJob() {
        CronTrigger job = [SELECT id FROM CronTrigger WHERE NextFireTime != null AND CronJobDetail.name = 'WarehouseSyncSchedule' limit 1];

        System.abortJob(job.id); 
    }

    public static void run() {
        ScheduledHelper.cronExpression = '0 0 1 ? * * *';
		ScheduledHelper.scheduledBootstrap(WarehouseSyncSchedule.class);
    }
}