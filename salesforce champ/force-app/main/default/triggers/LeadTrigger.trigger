trigger LeadTrigger on Lead (before Update,After insert,Before Delete,before insert) {
    //Prevent duplicate lead creation.
    if(Trigger.isBefore && Trigger.isInsert){
        Set<String> Emails = new Set<String>();
        for(Lead ld : Trigger.New){
            if(ld.Email != null){
                Emails.add(ld.Email?.tolowercase());
            }
        }
        system.debug('@@Emails'+Emails);
        if(!Emails.isEmpty()){
            Map<String,Lead> existingLeadMap = new Map<String,Lead>();
            //List<Lead> leadList = [Select id, Email from Lead where Email in : Emails];
           // if(!leadList.isEmpty()){
                for(Lead l : [Select id, Email from Lead where Email in : Emails]){
                  existingLeadMap.put(l.Email,l);
				}
            //}
            
        	system.debug('@@existingLeadMap'+existingLeadMap);
            for(Lead ld : Trigger.new){
                system.debug('@@Emails Entered');
                if(!existingLeadMap.isEmpty() && existingLeadMap.containsKey(ld.Email?.tolowercase())){
                    system.debug('2233@@Emails Entered');
                    ld.addError('Lead already exists,Please Don\'t Create duplicate Lead');
                }
            }
        }
    }
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