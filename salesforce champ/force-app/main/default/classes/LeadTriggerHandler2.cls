public with sharing class LeadTriggerHandler2 {
   
    public static void duplicateLead(List<Lead> newLeadList){
        Set<String> emails = new Set<String>();
        for(Lead l : newLeadList){
            if(l.Email != null){
                emails.add(l.email?.toLowerCase());
            }
        }

        if(!emails.isEmpty()){
            Map<String,Lead> leadMap = new Map<String,Lead>();
          for(Lead l : [select id, Email from Lead where Email in : emails]){
                leadMap.put(l.Email,l):
          }
           for(Lead l : newLeadList){
                if(leadMap.isEmpty() && leadMap.containsKey(l.Email)){
                    l.addError('Email already exist');
                }
           }
        }
    }
}