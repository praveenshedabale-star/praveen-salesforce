public with sharing class AccountHandler1 {
    @AuraEnabled
    public static List<Account> fetchAccounts(){
        List<Account> accList = [select id, Name, Description from Account limit 10];
        if(!accList.isEmpty()){
            return accList;
        }
    }
} 