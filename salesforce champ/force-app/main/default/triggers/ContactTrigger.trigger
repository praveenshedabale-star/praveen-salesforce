trigger ContactTrigger on Contact (before insert,After insert,after update) {
    
    if(Trigger.isInsert && Trigger.IsAfter){
        //Share the contact record with a public group as soon as a record is created
          ContactTriggerHandler.shareContactRecords(Trigger.New);
        
    }
    
    //when contact email is updated,update the account description.
    if(Trigger.isAfter && Trigger.isUpdate){
        ContactTriggerHandler.updateContactDescription(Trigger.new,Trigger.oldMap);
    }
    
   
    if(Trigger.isBefore && Trigger.isInsert){
        ContactTriggerHandler.contactTriggerBeforeInsert(Trigger.New);

     //Do not allow contact creation if a contact already exists with the same last name, email & phone
    // Collect unique combinations for new contacts
    Set<String> uniqueKeys = new Set<String>();
    for (Contact con : Trigger.new) {
        if (con.LastName != null && con.Email != null && con.Phone != null) {
            String key = con.LastName.trim().toLowerCase() + '|' + 
                         con.Email.trim().toLowerCase() + '|' + 
                         con.Phone.trim();
            uniqueKeys.add(key);
        }
    }

    // Query existing contacts with matching LastName, Email, and Phone
    Map<String, Contact> existingMap = new Map<String, Contact>();
    if (!uniqueKeys.isEmpty()) {
        for (Contact c : [
            SELECT Id, LastName, Email, Phone
            FROM Contact
            WHERE LastName != null AND Email != null AND Phone != null
                  
        ]) {
            String key = c.LastName.trim().toLowerCase() + '|' +
                         c.Email.trim().toLowerCase() + '|' +
                         c.Phone.trim();
            existingMap.put(key, c);
        }
    }

    // Add errors if duplicates exist
    for (Contact con : Trigger.new) {
        if (con.LastName != null && con.Email != null && con.Phone != null) {
            String key = con.LastName.trim().toLowerCase() + '|' + 
                         con.Email.trim().toLowerCase() + '|' + 
                         con.Phone.trim();
            if (existingMap.containsKey(key)) {
                con.addError('A contact with the same Last Name, Email, and Phone already exists.');
            }
        }
    }
}
            }