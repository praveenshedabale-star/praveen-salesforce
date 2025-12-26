public with sharing class wirecall {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(){
       List<Account> listAccounts = [select id,Industry from Account limit 5];
       return listAccounts;
    }
}