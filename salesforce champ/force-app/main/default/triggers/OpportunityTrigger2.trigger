trigger OpportunityTrigger2 on Opportunity (After Insert,After Update,after Delete) {

    //Whenever an opportunity is created or its amount is updated or Opportunity is Deleted the related accounts total revenue should be recalculted.
        if(Trigger.isAfter){

            Set<Id> accountIds = new Set<Id>();
            if(Trigger.isInsert || Trigger.isUpdate){
                for (Opportunity opp : Trigger.new) {
                    if (opp.AccountId == null) continue;
        
                    if (opp.Amount != null && (Trigger.isInsert || (Trigger.isUpdate && opp.Amount != Trigger.oldMap.get(opp.Id).Amount) || Trigger.isDelete)) {
                        accountIds.add(opp.AccountId);
                    }
                }
            }
            if(Trigger.isDelete){
                for(Opportunity opp : Trigger.old){
                    accountIds.add(opp.AccountId);
                }
            }
            
            if (!accountIds.isEmpty()){
                Map<Id, Decimal> accountRevenueMap = new Map<Id, Decimal>();
        
                for (AggregateResult ar : [
                    SELECT AccountId accId, SUM(Amount) totalAmount
                    FROM Opportunity
                    WHERE AccountId IN :accountIds
                    GROUP BY AccountId
                ]) {
                    accountRevenueMap.put((Id) ar.get('accId'),(Decimal) ar.get('totalAmount'));
                }
        
                List<Account> accountsToUpdate = new List<Account>();
        
                for (Id accId : accountIds) {
                    Decimal revenue = accountRevenueMap.containsKey(accId)? accountRevenueMap.get(accId): 0;
        
                    accountsToUpdate.add(new Account(Id = accId,AnnualRevenue = revenue));
                }
    
                if (!accountsToUpdate.isEmpty()) {
                    update accountsToUpdate;
                }
            }
    }
}