trigger LeadTrigger on Lead (before Update,After insert,Before Delete,before insert) {
    //Prevent duplicate lead creation.
    
//Whenever Lead is updated, Update Lead Status to Working-Contacted.
// Whenever Lead is Updated and Industry is health care, set
// lead source as purchased list,
// sisc code - 1100
// primary as yes
    if(Trigger.isBefore && Trigger.IsUpdate){
        for(Lead leadRecord : Trigger.New){
             leadRecord.Status = 'Working - Contacted'; 
            if(leadRecord.Industry == 'Healthcare'){
                leadRecord.LeadSource = 'Purchased List';
                leadRecord.SICCode__c  = '1100';
                leadRecord.Primary__c = 'Yes';
            }
        }
    }
    
        if(Trigger.isAfter && Trigger.isInsert){
            LeadTriggerHandler.leadTriggerAfterInsert(Trigger.New);
    }
    if(Trigger.isBefore && Trigger.isDelete){
        LeadTriggerHandler.leadDeletionNotAllowed(Trigger.old);
    }
}