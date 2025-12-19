public class AccountHandler2 {
//Total_New_Budjet__c
    public static void budjetCalulation(List<Account> newList,Map<Id,Account> accountMap){
        Map<Id,Account> accMap = new Map<Id,Account>();
        for(Account acc: newList){
            if(Trigger.isUpdate && !accountMap.isEmpty() && acc.Total_New_Budjet__c != null && accountMap.get(acc.id).Total_New_Budjet__c != acc.Total_New_Budjet__c){
                accMap.put(acc.id,acc);
            }
        }
        if(!accMap.isEmpty()){
            Map<Id,List<Opportunity>> accOppMap = new Map<Id,List<Opportunity>>();
            List<Opportunity> oppList = [select id,AccountId,Amount from Opportunity where AccountId in : accMap.keySet()];
            for(Opportunity opp : OppList){
                if(!accOppMap.containsKey(opp.Accountid)){
                    accOppMap.put(opp.AccountId,New List<Opportunity>());
                }
                accOppMap.get(opp.AccountId).add(opp);
            }
        
        Map<Id,decimal> budjetAccMap = new Map<Id,Decimal>();
        for(id accountId : accOppMap.keySet()){
            integer count = accOppMap.get(accountId).size();
            budjetAccMap.put(accountId,accMap.get(accountId).Total_New_Budjet__c/ count);
        }
        List<Opportunity> oppListUpdate = new List<Opportunity>();
        for(Opportunity opp: oppList){
           opp.Amount = budjetAccMap.get(opp.AccountId);
            oppListUpdate.add(opp);
        }
        if(!oppListUpdate.isEmpty()){
            Update oppListUpdate;
        }
            }
    }
}