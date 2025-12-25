//write a logic to avoid duplicate lead creation .
public class LeadTriggerHandler2{


    public static void  stopDuplicateLeadCreation(List<Lead> newLeadList){
        Set<String> emails = new Set<String>();
        for(Lead ld : newLeadList){
            if(ld.Email != null){
                    emails.add(ld.Email?.toLowerCase());
            }
        }

        Map<String,Lead> mapLead = new Map<String,Lead>();
        if(!emails.isEmpty()){
            for(Lead ld : [select id,Email from Lead where Email in : emails]){
                mapLead.put(ld.Email,ld);
            }

            for(Lead l : newLeadList){
                if(!mapLead.isEmpty() && mapLead.containsKey(l.Email?.toLowerCase())){
                    l.addError('hey guys!...Duplicate Leads cannot be created, there is an existing lead with same email');
                }
            }
        }
    }

}