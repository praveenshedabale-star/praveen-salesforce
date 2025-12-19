trigger AccountTrigger2 on Account (after insert,after update) {
    //if(trigger.isAfter && (Trigger.isInsert || trigger.isUpdate)){
    
    if(trigger.isUpdate){
        AccountnewTrigger.updateChildRecords(Trigger.new,Trigger.OldMap);
	}
         
    //}
}