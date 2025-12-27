trigger CreateNumberOfConsBasedOnAccFieldValue on Account (After insert) {

    if(Trigger.isAfter && Trigger.isInsert){
        List<Contact> conList = new List<Contact>();
        for(Account acc : Trigger.new){
                if(acc.Number_of_Contacts__c == null && acc.Number_of_Contacts__c <= 0){
                        continue;
                }
                Integer count = acc.Number_of_Contacts__c != null ? (Integer)acc.Number_of_Contacts__c : 0;
                for(integer i=0; i<count; i++){
                        Contact con = new Contact();
                        con.LastName = acc.Name + ' ' + i;
                        con.accountid = acc.id;
                        conList.add(con);
                }
        }
        if(!conList.isEmpty()){
            insert conList;
        }
    }
}

public class AccountLocationHandler {

    public static void createLocations(
        List<Account> newAccounts,
        Map<Id, Account> oldAccountMap
    ) {
        List<Location__c> locationsToInsert = new List<Location__c>();

        for (Account acc : newAccounts) {

            // Skip if field is null or zero
            if (acc.Number_of_Locations__c == null || acc.Number_of_Locations__c <= 0) {
                continue;
            }

            Integer newCount = acc.Number_of_Locations__c.intValue();
            Integer oldCount = 0;

            // Only create new records if value increased
            if (oldAccountMap != null && oldAccountMap.containsKey(acc.Id)) {
                Account oldAcc = oldAccountMap.get(acc.Id);
                if (oldAcc.Number_of_Locations__c != null) {
                    oldCount = oldAcc.Number_of_Locations__c.intValue();
                }
            }

            // Create only the difference
            for (Integer i = oldCount; i < newCount; i++) {
                Location__c loc = new Location__c();
                loc.Account__c = acc.Id;
                loc.Name = 'Location ' + (i + 1);
                locationsToInsert.add(loc);
            }
        }

        if (!locationsToInsert.isEmpty()) {
            insert locationsToInsert;
        }
    }
}
