public class LeadTriggerHandler {
  //when Lead is created, create a follow - up task
    Public Static Void leadTriggerAfterInsert(List<Lead> newLeadList){
        List<Task> newTaskList = new List<Task>();
        for(Lead leadRec : newLeadList){
            	Task taskRec = new task();
                taskRec.OwnerId = leadRec.OwnerId;
                taskRec.WhoId   = leadRec.Id;
                taskRec.Description = 'Follow - Up';
                taskRec.Priority = 'High';
				taskRec.Subject = 'Follow - Up';
                newTaskList.add(taskRec);
        }
        if(!newTaskList.isEmpty() && newTaskList.size()>0){
            insert newTaskList;
        }
    }
    
    //Do not allow lead deletion if lead is working - contacted.
    Public static void leadDeletionNotAllowed(List<Lead> oldRecList){
        for(Lead ld : oldRecList){
            if(ld.Status == 'Working - Contacted'){
                ld.addError('This Lead record cannot be deleted');
            }
        }
    }
    
}