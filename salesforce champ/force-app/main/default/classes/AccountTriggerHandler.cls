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
    
    
    	
    
    
        
    }