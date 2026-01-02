//Update Parent Case Description details on Account description field on insert or uodate
trigger updateParentFromChild on Case (after insert,after Update) {
 
    if(Trigger.isAfter){
            if(Trigger.isInsert || Trigger.isUpdate){
                Map<Id,Case> caseIdMap = new Map<Id,Case>();
                List<Account> accUpdateList = new List<Account>();
                for(Case cs : Trigger.new){
                    if(cs.Description != null && (Trigger.isInsert || 
                    (Trigger.isUpdate && Trigger.oldMap.get(cs.id).Description != cs.Description) )){
                        caseIdMap.put(cs.AccountId, cs);
                    }
                }
                if(!caseIdMap.isEmpty()){
                    List<Account>  accList = [select id,Description1__c from Account where Id in : caseIdMap.keySet()];

                    if(!accList.isEmpty()){
                        for(Account acc : accList){
                            acc.Description1__c = caseIdMap.get(acc.id).Description;
                            accUpdateList.add(acc);
                        }
                    }
                    if(!accUpdateList.isEmpty()){
                        Update accUpdateList;
                    }
                }
            }
    }

}