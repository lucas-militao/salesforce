/*
    reference: https://gist.github.com/gbutt/11151983
*/
public with sharing class ScheduledHelper {
	
	public static String cronExpression = '0 0 0 1 * ?'; 
	
	/*
	The bootstrap can be called by anonymous apex to schedule jobs.
	*/
	public static void scheduledBootstrap(Type targetType) {
		scheduleJob(targetType, cronExpression);
	}
	
	public static void scheduleJob(Type targetType, String cronExpression) {
		String jobName = targetType.getName();
		scheduleJob(targetType, jobName, cronExpression);
	}
	
	public static void scheduleJob(Type targetType, String jobName, String cronExpression) {
		abortJob(jobName);
		ScheduledDispatcher scheduledDispatcher = new ScheduledDispatcher(targetType);
		System.schedule(jobName, cronExpression, scheduledDispatcher);
	}

	public static void abortJob(String jobName) {
		Set<String> stateList = new Set<String>{'COMPLETED', 'ERROR', 'DELETED'};
		List<CronTrigger> jobs = [
			SELECT Id, CronJobDetail.Name, State, NextFireTime 
			FROM CronTrigger 
			WHERE CronJobDetail.Name = :jobName
			AND State NOT IN :stateList
		];
		
		if (jobs.size()>0) {
			System.abortJob(jobs[0].Id);
		}
	}
	
	public static String createCronExpressionFromDateTime(DateTime fireTime) {
		List<String> timeParts = new List<String>();
		timeParts.add(String.valueof(fireTime.second()));
		timeParts.add(String.valueof(fireTime.minute()));
		timeParts.add(String.valueof(fireTime.hour()));
		timeParts.add(String.valueof(fireTime.day()));
		timeParts.add(String.valueof(fireTime.month()));
		timeParts.add('?');
		timeParts.add(String.valueof(fireTime.year()));
		
		return String.join(timeParts, ' ');
	}
}