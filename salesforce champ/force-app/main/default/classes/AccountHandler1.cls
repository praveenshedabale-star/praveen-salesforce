public with sharing class AccountHandler1 {
    @AuraEnabled
    public static List<Account> fetchAccounts(){
        return [select id, Name, Description from Account limit 10];
    }
} 