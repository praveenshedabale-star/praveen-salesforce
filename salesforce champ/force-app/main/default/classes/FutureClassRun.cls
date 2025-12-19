public class FutureClassRun {
  
    public static void dmlError(){
            Account acc = new Account(Name = 'Praveen test 1234');
            insert acc;
            
            Id pfId = [select id from Profile limit 1].id;
            Id usrrlId = [select UserRoleId from user limit 1].UserRoleId;
            User s = new user(
            Username = 'Wecfxbxvvbzzbx@gmail.com', 
            LastName = 'rtt@gmail.com',
            Email = 'rtt@gmail.com',
            Alias = 'sss',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId  = pfId,
            LanguageLocaleKey = 'en_US');
            insert s;
        
    }
}