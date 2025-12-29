trigger BookTrigger on Book__c (before insert) {

    if(trigger.isBefore && trigger.isInsert){
        HelloWorldApexClass.updateBookPrice(trigger.new);
    }
    
}