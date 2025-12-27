public with sharing class ImperativeApex {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(){
        List<Account> accList = [select id,Industry from Account limit 10];
        return accList;
    }
}