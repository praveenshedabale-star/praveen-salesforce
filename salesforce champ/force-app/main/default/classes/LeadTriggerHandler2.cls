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
                    ld.addError('Duplicate Email creation is strictly prohbited!! pls go to this Lead record to see the already existing email -  '+existingId);
                }
            }
        }
    }
}