public class AccountnewTrigger {
    
    public static void updateChildRecords(List<Account> accList,Map<Id,Account> oldMap){
        Map<Id,Account> accMap = new Map<Id,Account>();
        List<Contact> conUpdateList = new List<Contact>();
        for(Account acc : accList){
            if(Trigger.isInsert || (Trigger.isUpdate && oldMap.get(acc.id).Rating != acc.Rating)){
                accMap.put(acc.id,acc);
			}
		}
        
        if(!accMap.isEmpty()){
            List<Contact> conList = [select id,AccountId,Rating__c from Contact where AccountId in : accMap.keyset()];
            if(!conList.isEmpty()){
                for(Contact con : conList){
                    con.Rating__c = accMap.get(con.AccountId).Rating;
                    conUpdateList.add(con);
				}
			}
            if(!conUpdateList.isEmpty()){
                update conUpdateList;
			}
            Id pfId = [select id from Profile limit 1].id;
            Id usrrlId = [select UserRoleId from user limit 1].UserRoleId;
            User s = new user(
            Username = 'Wecfxbxvvbbx@gmail.com', 
            LastName = 'rtt@gmail.com',
            Email = 'rtt@gmail.com',
            Alias = 'sss',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId  = pfId,
            LanguageLocaleKey = 'en_US');
            insert s;
             
            s.UserRoleId = usrrlId;
            update s;
            
			Account acc = new Account(Name = 'testaaz');       
            insert acc;
            
		}
    }
    
    @future
    public static void myMethod(id caseid){
     
        List<Case> listCase = [select id from Case where id = : caseid];
        
        listCase[0].description = 'hellowvgg';
        
        update listCase;
        //system.enqueueJob(new myQueueableClass());
       // myMethod1(listCase[0].id);
	
    }
    
    //Account budget distribution among all the child opportunity.
    public static void budjetCalulation(){
        
    }
}