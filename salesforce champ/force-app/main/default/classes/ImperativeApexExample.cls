public with sharing class ImperativeApexExample {
    
    @AuraEnabled(cacheable = true)
    public static List<Contact> getContacts(){
        List<Contact> listContacts = [select id,Email from Contact where Email != null limit 5];
        return listContacts;
    }
}