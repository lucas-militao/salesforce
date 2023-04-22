public with sharing class Accounts extends fflib_SObjectDomain {
    public Accounts(List<Account> sObjectList) {
       super(sObjectList);
   }
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<sObject> sObjectList) {
            return new Accounts(sObjectList);
        }
    }

    public override void handleBeforeInsert()
    {
        onApplyDefaults();
    }

    public override void onBeforeUpdate(Map<Id,sObject> existingRecords) {
        String description = 'Domain classes rock!';
        List<Account> updatedAccounts = new List<Account>();
        for (Account account : (List<Account>) records) {
            account.AnnualRevenue = description.getLevenshteinDistance(account.Description);
            updatedAccounts.add(account);
        }

        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { Account.SObjectType });
        uow.registerDirty(updatedAccounts);
    }

    public override void onApplyDefaults() {
        // Apply defaults to Accounts
        for(Account account : (List<Account>) Records) {
            if(account.description == null) {
                account.Description = 'Domain classes rock!';
            }               
        }
    }

    public void updateOpportunityActivity(fflib_SObjectUnitOfWork uow) {
        for(Account account : (List<Account>) Records) {
            account.Description = 'Domain classes rock!';
            uow.registerDirty(account);
        }
    }
}