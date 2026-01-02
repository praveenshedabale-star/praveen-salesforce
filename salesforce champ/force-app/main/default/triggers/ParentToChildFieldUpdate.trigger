//When Parent field Description1 is updated update all the child description field  on contacts.
trigger ParentToChildFieldUpdate on Account (After insert,After update) {
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            Map<Id,Account> accIdMap = new Map<Id,Account>();
            List<Contact> conListUpdate = new List<Contact>();
                for(Account acc : Trigger.new){
                    if(acc.Description1__c != null && (Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(acc.id).Description1__c != acc.Description1__c))){
                        accIdMap.put(acc.id,acc);
                    }
                }
        
            if(!accIdMap.isEmpty()){
                List<Contact> conList = [select id,Description,AccountId from Contact where accountId in : accIdMap.keySet()];
                
                if(!conList.isEmpty()){
                    for(Contact con : conList){
                        con.Description = accIdMap.get(con.AccountId).Description1__c;
                        conListUpdate.add(con);
                    }
                }
                if(!conListUpdate.isEmpty()){
                    update conListUpdate;
                }
            }
        }
    }
}