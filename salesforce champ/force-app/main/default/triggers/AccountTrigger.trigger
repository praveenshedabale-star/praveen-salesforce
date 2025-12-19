trigger AccountTrigger on Account (before update, after update,after insert,before insert) {
   
    if(Trigger.isInsert && Trigger.isBefore){
         AccountHandler.populateShippingAddress(Trigger.new);
        AccountHandler.throwError(Trigger.new);
    }
    if(Trigger.isBefore  && Trigger.isUpdate){
        AccountTriggerHandler.accountTriggerHandlerBeforeUpdate(Trigger.new,Trigger.OldMap);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        AccountTriggerHandler.accountTriggerHandlerAfterUpdate(Trigger.new,Trigger.oldMap);
        //AccountnewTrigger.accountBudgetDistribution(Trigger.new,Trigger.oldMap);
        AccountHandler2.budjetCalulation(Trigger.new,Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isInsert){
       AccountTriggerHandler.createContacts(Trigger.New);
        AccountHandler.createContact(Trigger.New);
    }
    
    //Boolean checkProfile = AccountTriggerHandler.profileCheck('Account');    
    if(profileCheck('Account')){
        System.debug('##Succsess');
    }else{
        System.debug('@@Fail');
    }
    
    Public Boolean profileCheck(String ObjectName){
     
        List<Object_Details__mdt>  objDetailsMetada = [Select Id,is_Active__c,Object__c,profiles__c from Object_Details__mdt Where 
                                                      is_Active__c = : True and Object__c = : ObjectName];
        List<String> mdtProfileNames = objDetailsMetada[0].profiles__c.split(',');
        String ProfileName = [Select Name from Profile where id = : userInfo.getProfileId()].Name;
        
        if(mdtProfileNames.contains(ProfileName)){
            return true;
        }
        else{
            return false;
        }
    }
   
}

/*
Scernario 1---
trigger TaskTrigger on Task (before insert) {
//Whenever Task is created, set priority to high.
    if(Trigger.isBefore && Trigger.isInsert){
        for(Task ts : Trigger.new){
            ts.Priority = 'High';
          }
    }
}
-----------------------------------------------
scenario 2
-------------------------
trigger LeadTrigger on Lead (before Update) {
//Whenever Lead is updated, Update Lead Status to Working-Contacted.
    if(Trigger.isBefore && Trigger.IsUpdate){
        for(Lead leadRecord : Trigger.New){
             leadRecord.Status = 'Working - Contacted';
        }
    }
}

-----------------------------------------
Scanario 3
-----------------------------------------------------------
trigger CaseTrigger on Case (before insert) {
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
}
-----------------------------------------------------------------------------------------
Scaenario 4
-------------------------------------------------------------------------------

trigger LeadTrigger on Lead (before Update) {
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
}

------------------------------------------------------------------
Scenario 5
---------------------------------------------------

WhatId is releated non-person (etc: account opportunity)
WhoId is releated to person.(ownerid) leads contacts

Trigger OpportunityTrigger On Opportunity(After Update){
    
    if(Trigger.isAfter && Trigger.isUpdate){
        OpportunityTriggerHandler.opportunityTriggerAfterUpdate(Trigger.New,Trigger.OldMap);
    }
}

public class OpportunityTriggerHandler {
//When Opportunity is updated to closed won, created a task to split revenue;
    public static void opportunityTriggerAfterUpdate(List<Opportunity> newOppList, Map<Id,Opportunity> oldOppMap){
        List<Task> newTaskList = new List<Task>();
        for(Opportunity opp: newOppList){
            if(opp.StageName == 'Closed Won' && opp.stageName != oldOppMap.get(opp.id).stageName ){
                Task taskRec = new task();
                taskRec.OwnerId = opp.OwnerId;
                taskRec.WhatId   = opp.Id;
                taskRec.Description = 'Split revenue';
                taskRec.Priority = 'High';
                taskRec.Subject = 'Split revenue';
                newTaskList.add(taskRec);
            }
        }
        if(!newTaskList.isEmpty() && newTaskList.size() >0){
            
            insert newTaskList;
        }
    }
}
---------------------------------------------------------------
Scaenario 6
-------------------------------------------------------

trigger LeadTrigger on Lead (before Update,After insert) {
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
}

public class LeadTriggerHandler {
  //when Lead is created, create a follow - up task
    Public Static Void leadTriggerAfterInsert(List<Lead> newLeadList){
        List<Task> newTaskList = new List<Task>();
        for(Lead leadRec : newLeadList){
                Task taskRec = new task();
                taskRec.OwnerId = leadRec.OwnerId;
                taskRec.WhoId   = leadRec.Id;
                taskRec.Description = 'Follow - Up';
                taskRec.Priority = 'High';
                taskRec.Subject = 'Follow - Up';
                newTaskList.add(taskRec);
        }
        if(!newTaskList.isEmpty() && newTaskList.size()>0){
            insert newTaskList;
        }
    }
}

--------------------------------------------------------------------------------------
Scenario 7
--------------------------------------------------------------------------------

Trigger OpportunityTrigger On Opportunity(After Update,before Update){
    
    if(Trigger.isAfter && Trigger.isUpdate){
        OpportunityTriggerHandler.opportunityTriggerAfterUpdate(Trigger.New,Trigger.OldMap);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        OpportunityTriggerHandler.opportunityTriggerBeforeUpdate(Trigger.New,Trigger.OldMap);
    }
}


public class OpportunityTriggerHandler {
//When Opportunity is updated to closed won, created a task to split revenue;
    public static void opportunityTriggerAfterUpdate(List<Opportunity> newOppList, Map<Id,Opportunity> oldOppMap){
        List<Task> newTaskList = new List<Task>();
        for(Opportunity opp: newOppList){
            if(opp.StageName == 'Closed Won' && opp.stageName != oldOppMap.get(opp.id).stageName ){
                Task taskRec = new task();
                taskRec.OwnerId = opp.OwnerId;
                taskRec.WhatId   = opp.Id;
                taskRec.Description = 'Split revenue';
                taskRec.Priority = 'High';
                taskRec.Subject = 'Split revenue';
                newTaskList.add(taskRec);
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
                //opp.Amount = opp.Probability * opp.ExpectedRevenue;
            }
        }
    }
}


----------------------------------------------------------------------------------------------------
Scenario 8

-------------------------------------------------------------------------------------------------------------


trigger ContactTrigger on Contact (before insert) {

    if(Trigger.isBefore && Trigger.isInsert){
        ContactTriggerHandler.contactTriggerBeforeInsert(Trigger.New);
        }
}


public class ContactTriggerHandler {

    Public static void contactTriggerBeforeInsert(List<Contact> newConList){
    //if contact is created without parent account, do not allow user to create contact record.
        for(Contact con : newConList){
            if(con.AccountId == null){
                con.AccountId.addError('Account is required field');
            }
        }
    }
}


------------------------------------------------------------------------------------------------------------------
Scenario 9
------------------------------------------------------------------------------------------------------------
trigger AccountTrigger on Account (before update) {
   
    if(Trigger.isBefore  && Trigger.isUpdate){
        AccountTriggerHandler.accountTriggerHandlerBeforeUpdate(Trigger.new,Trigger.OldMap);
    }
}


public class AccountTriggerHandler {

    public static void accountTriggerHandlerBeforeUpdate(List<Account> accNewList,Map<Id,Account> accOldMap){
        //if Account industry is Agriculture and Type is Prospect. if onership is updated and ownership is private then throw an error.
        for(Account acc : accNewList){
            if(acc.Industry == 'Agriculture' && acc.Type == 'Prospect' 
               && acc.Ownership != accOldMap.get(acc.id).Ownership && acc.Ownership == 'Private'){
                
                   acc.addError('Account cannot be updated.');
            }
        }
    }
}

------------------------------------------------------------------------------------------------------------------
Scenario 10
Consider this for parent to child records update.
------------------------------------------------------------------------------------------------------------
trigger AccountTrigger on Account (before update, after update) {
   
    if(Trigger.isBefore  && Trigger.isUpdate){
        AccountTriggerHandler.accountTriggerHandlerBeforeUpdate(Trigger.new,Trigger.OldMap);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        AccountTriggerHandler.accountTriggerHandlerAfterUpdate(Trigger.new,Trigger.oldMap);
    }
}


public class AccountTriggerHandler {

    public static void accountTriggerHandlerBeforeUpdate(List<Account> accNewList,Map<Id,Account> accOldMap){
        //if Account industry is Agriculture and Type is Prospect. if onership is updated and ownership is private then throw an error.
        for(Account acc : accNewList){
            if(acc.Industry == 'Agriculture' && acc.Type == 'Prospect' 
               && acc.Ownership != accOldMap.get(acc.id).Ownership && acc.Ownership == 'Private'){
                
                   acc.addError('Account cannot be updated.');
            }
        }
    }
    
    public static void accountTriggerHandlerAfterUpdate(List<Account> newAccList,Map<Id,Account> oldAccMap){
        //Every time an account website is updated,Update the website field on all child contacts for the account
            Map<Id,Account> accIdToStringMap = new Map<Id,Account>();
            for(Account acc : newAccList){
                if(acc.Website != oldAccMap.get(acc.Id).Website){
                    accIdToStringMap.put(acc.id,acc);
                }
           }
        
            if(!accIdToStringMap.isEmpty() && accIdToStringMap.keySet().size() > 0){
                
                List<Contact> conList = [select id,AccountId,Website__c from Contact where AccountId in :accIdToStringMap.keySet()];
                List<contact> conListUpDate = New List<Contact>();
                for(Contact con : conList){
                    if(accIdToStringMap.containsKey(con.AccountId)){
                        con.Website__c = accIdToStringMap.get(con.AccountId).Website;
                        conListUpDate.add(con);
                    }
                }
                if(!conListUpDate.isEmpty() && conListUpDate.size()>0 ){
                    Update conListUpDate;
                }
            }
    }
}

------------------------------------------------------------------------------------------------------------------------------
Scenario 11
----------------------------------------------------------------------------------------------------------------

trigger AccountTrigger on Account (before update, after update,after insert) {
   
    if(Trigger.isBefore  && Trigger.isUpdate){
        AccountTriggerHandler.accountTriggerHandlerBeforeUpdate(Trigger.new,Trigger.OldMap);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        AccountTriggerHandler.accountTriggerHandlerAfterUpdate(Trigger.new,Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isInsert){
       AccountTriggerHandler.createContacts(Trigger.New);
    }
}



public static void createContacts(List<Account> accList){
        //Create contact records based on Create N contacts field on Account Record.
        List<Contact> conListUpdate = new List<Contact>();
        for(Account acc : accList){   
             if(acc.N_Contacts__c != null){ 
                 for( integer n=0; n < acc.N_Contacts__c; n++){
                     contact con = new Contact();
                     con.LastName =acc.Name+'-'+n;
                     con.AccountId = acc.id;
                     conListUpdate.add(con);
                 }
            }    
        }
        
        if(conListUpdate.size() > 0){
            insert conListUpdate;
        }

        }



----------------------------------------------------------------------------------------------------------
Scebario 12
----------------------------------------------------------------------------------------------




*/