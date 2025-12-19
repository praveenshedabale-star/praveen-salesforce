Trigger OpportunityTrigger On Opportunity(After Update,before Update,after Delete){
    
    if(Trigger.isAfter && Trigger.isUpdate){
        OpportunityTriggerHandler.opportunityTriggerAfterUpdate(Trigger.New,Trigger.OldMap);
        //As soon as Opportunity Stage reaches Needs Analysis, add all users of role Opportunists to the Team
        OpportunityTriggerHandler.addTeamMemberToOpportunityFromRole(Trigger.New,Trigger.OldMap);

    }
    if(Trigger.isBefore && Trigger.isUpdate){
        OpportunityTriggerHandler.opportunityTriggerBeforeUpdate(Trigger.New,Trigger.OldMap);
    }
    if(Trigger.isAfter && Trigger.isDelete){
        OpportunityTriggerHandler.opportunityTriggerAfterDelete(Trigger.old);
	}
}