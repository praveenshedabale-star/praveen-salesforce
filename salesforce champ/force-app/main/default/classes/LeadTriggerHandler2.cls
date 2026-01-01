//write a logic to avoid duplicate lead creation  based on Email.
public class LeadTriggerHandler2{

    public static void stopDuplicateLeadCreation(List<Lead> newLeadList){
        Set<String> leadEmails = new Set<String>();
        for(Lead ld : newLeadList){
            if(ld.Email != null){
                leadEmails.add(ld.Email.toLowerCase());
            }
        }

        if(!leadEmails.isEmpty()){
            Map<String,Lead> leadMap = new Map<String,Lead>();
            for(Lead emailLead : [select id, Email from Lead where Email In : leadEmails]){
                leadMap.put(emailLead.Email.toLowerCase(),emailLead);
            }

            for(Lead ld : newLeadList){
                if(!leadMap.isEmpty() && leadMap.ContainsKey(ld.Email.toLowerCase())){
                    Id existingId = leadMap.get(ld.Email).id;
                   // ld.addError('Duplicate Email creation is strictly prohbited!! pls go to this Lead record to see the already existing email -  '+existingId);
                }
            }
        }
    }

    //when lead is created /updated  if a contact with same email exist, then restrict the lead to being saved.
    public static void  stopDuplicateLeadBasedOnContactEmail(List<Lead> newListLead, Map<Id,Lead> oldMap){
         Set<String> emailSet = new Set<String>();
          for(Lead ld : newListLead){
                if(ld.Email != null && (Trigger.isInsert || (Trigger.isUpdate && ld.Email != oldMap.get(ld.id).Email))){
                        emailSet.add(ld.Email.toLowerCase());
                }
          }
          if(!emailSet.isEmpty()){
                Map<Id,Contact> existingConMap = new Map<Id,Contact>();
                for(Contact con : [select id, Email from Contact where Email in : emailSet]){
                        existingConMap.put(con.Email.toLowerCase(),con);
                }

                for(Lead ld : newListLead){
                    if(!existingConMap.isEmpty() && existingConMap.containsKey(ld.Email.toLowerCase())){
                         Id existingId = existingConMap.get(ld.Email.toLowerCase()).id;
                         ld.addError('There is an existing Contact with Id : '+existingId+' pls don\'t add same Email in new Lead or existing Lead');
                    }
                }
          }
    }
}