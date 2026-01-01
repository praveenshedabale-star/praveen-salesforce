//Prevent Creation of lead if there are duplicate Lead based On email.
trigger LeadTrigger3 on Lead (Before insert) {

    if(trigger.isBefore && Trigger.isInsert){
        Set<String> emailStrings = new Set<String>();
        for(Lead ld : Trigger.new){
            if(ld.Email != null){
                emailStrings.add(ld.Email.toLowerCase());
            }
        }

        if(!emailStrings.isEmpty()){
            Map<String,Lead> leadMap = new Map<String,Lead>();
            for(Lead ld : [select id,Email from Lead where Email In : emailStrings]){
                leadMap.put(ld.Email.toLowerCase(),ld);
            }

            for(Lead ld : Trigger.new){
                if(!leadMap.isEmpty() & leadMap.containsKey(ld.Email.toLowerCase())){
                    Id leadId = leadMap.get(ld.Email).Id;
                    ld.addError('there is an already existing Lead with same Email Id : '+leadId);
                }
            }
        }
    }
}