trigger CaseTrigger on Case (before insert, Before Delete,after insert , after update) {
    
    if(Trigger.isAfter){
        Set<Id> accountIds = new Set<Id>();
        Map<id,integer> highPriorityCountMap = new Map<id,integer>();
        List<Account> accUpdateList = new List<Account>();
        if(Trigger.isInsert || Trigger.isUpdate){
            for(Case cs : Trigger.new){
                if(cs.Priority == 'High' && trigger.isinsert || (Trigger.isUpdate && Trigger.oldMap.get(cs.id).priority != cs.priority)){
                    accountIds.add(cs.AccountId);
                }                   
       		 }
            
            if(!accountIds.isEmpty()){
                for(AggregateResult agg : [Select accountId accid,Count(Id) cnt from Case where AccountId in : accountIds and Priority = 'High' Group by AccountId]){
                    highPriorityCountMap.put((id)agg.get('accid'),(integer)agg.get('cnt'));
                }
                for(Account acc : [select id,High_Priority_Cases_Count__c from Account where id in : highPriorityCountMap.keyset()]){
                    acc.High_Priority_Cases_Count__c = highPriorityCountMap.get(acc.id);
                    accUpdateList.add(acc);
                }
            } 
            if(!accUpdateList.isEmpty()){
                Update accUpdateList;
            }
        }
        
    }
    
    
    
                  
    
    
    
    
//When case is created, if case origin is Phone, set priority High, else set priority as Low.
    if(Trigger.isBefore && Trigger.isinsert){
        for(Case caseRec : trigger.New){
            if(caseRec.Origin == 'Phone'){
                caseRec.Priority = 'High';
            }else{
                caseRec.Priority = 'Low';
            }
        }
    }
    
    if(Trigger.isBefore && Trigger.isDelete){
        CaseTriggerHandler.caseTeriggerBeforeDelete(Trigger.Old);
    }
    
    if(Trigger.isinsert || Trigger.isUpdate){
        
    }
}