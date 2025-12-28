public class OpportunityTriggerHandler {
//When Opportunity is updated to closed won, created a task to split revenue;
//When Opportunity is updated to Closed Lost, remove the opportunity team members from the opportunity.
    public static void opportunityTriggerAfterUpdate(List<Opportunity> newOppList, Map<Id,Opportunity> oldOppMap){
        List<Task> newTaskList = new List<Task>();
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
        for(Opportunity opp: newOppList){
            if(opp.StageName == 'Closed Won' && opp.stageName != oldOppMap.get(opp.id).stageName ){
                Task taskRec = new task();
                taskRec.OwnerId = opp.OwnerId;
                taskRec.WhatId   = opp.Id;
                taskRec.Description = 'Split revenue';
                taskRec.Priority = 'High';
				taskRec.Subject = 'Split revenue';
                newTaskList.add(taskRec);
            }else if(opp.StageName == 'Closed Lost'){
                oppMap.put(opp.id,opp);
            }
        }
        
       
        if(!OppMap.isEmpty() && oppMap.keySet().size()>0){
            
            List<OpportunityTeamMember> oppMember = [select id,OpportunityId from OpportunityTeamMember where OpportunityId in : OppMap.keySet()];
            if(oppMember.size()>0){
                Delete oppMember;
            }
            
        }
        if(!newTaskList.isEmpty() && newTaskList.size() >0){
            
            insert newTaskList;
        }
    }
    
    //When opportunity stage Name is modified, updated amout with probability * expectedRevenue
    public static void opportunityTriggerBeforeUpdate(List<Opportunity> oppNewList, Map<Id,Opportunity> oldMapRec){
        for(Opportunity opp : oppNewList){
            if(opp.StageName != oldMapRec.get(opp.id).StageName){
                opp.Amount = opp.Probability * opp.ExpectedRevenue;
            }
        }
    }
    
    //When Opportunity is deleted, create a task for the opportunity account owner for investigation why opportunity is deleted.
    Public static void opportunityTriggerAfterDelete(List<Opportunity> OldOppsList){
            Set<Id> accountIds = new Set<Id>();
            for(Opportunity opp: OldOppsList){
                accountIds.add(opp.AccountId);
            }
        if(!accountIds.isEmpty()){
            Map<Id,Account> accMap = new Map<Id,Account>([Select id,Ownerid from Account where id in : accountIds]);
            List<Task> newTaskList = new List<Task>();
            for(Opportunity Opp : OldOppsList){
                    Task taskRec = new task();
                    taskRec.OwnerId = accMap.get(opp.AccountId).OwnerId;
                    taskRec.WhatId   = opp.AccountId;
                    taskRec.Description = 'Opp Deleteion investigation';
                    taskRec.Priority = 'High';
                    taskRec.Subject = 'Opp Deleteion - investigation';
                    newTaskList.add(taskRec);
            }
            if(!newTaskList.isEmpty()){
                insert newTaskList;
            }
        }
 	}
    
   // As soon as Opportunity Stage reaches Needs Analysis, add all users of role Opportunists to the Team
    Public Static void addTeamMemberToOpportunityFromRole(List<Opportunity> oppRecList, Map<Id,Opportunity> mapOppRec){
        Map<id,Opportunity> oppMap = New Map<Id,Opportunity>();
        List<User> otmUserList = [Select id,userRole.Name from user where userRole.Name = 'Opportunists'];
        for(Opportunity opp : oppRecList){
            if(opp.StageName == 'Needs Analysis' && opp.StageName != mapOppRec.get(opp.id).StageName){
               oppMap.put(opp.id,Opp);
            }
        }
        List<OpportunityTeamMember> otmList = new List<OpportunityTeamMember>();
        for(Opportunity opp: oppMap.values()){
            for(User u : otmUserList){
                OpportunityTeamMember otm = new OpportunityTeamMember();
                otm.OpportunityId = opp.id;
                otm.OpportunityAccessLevel = 'Edit';
                otm.UserId = u.id;
                otmList.add(otm);
            }
        }
        
        if(!otmList.isEmpty()){
            insert otmList;
        }

    }


    //Whenever an opportunity is created or its amount is updated the related accounts total revenue should be recalculted.
    public static void recalculateAccountRevenue(List<Opportunity> oppNewList,Map<Id, Opportunity> oldMap) {
    Set<Id> accountIds = new Set<Id>();
    // Step 1: Collect affected Account Ids
        for (Opportunity opp : oppNewList) {
            if (opp.AccountId == null) continue;

            if (Trigger.isInsert ||(Trigger.isUpdate && opp.Amount != oldMap.get(opp.Id).Amount)) {
                accountIds.add(opp.AccountId);
            }
        }

        if (accountIds.isEmpty()) return;

        // Step 2: Aggregate total opportunity amount per Account
        Map<Id, Decimal> accountRevenueMap = new Map<Id, Decimal>();

        for (AggregateResult ar : [
            SELECT AccountId accId, SUM(Amount) totalAmount
            FROM Opportunity
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ]) {
            accountRevenueMap.put((Id) ar.get('accId'),(Decimal) ar.get('totalAmount'));
        }

        // Step 3: Update Accounts
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