trigger TaskTrigger on Task (before insert) {
//Whenever Task is created, set priority to high.
    if(Trigger.isBefore && Trigger.isInsert){
        for(Task ts : Trigger.new){
            ts.Priority = 'High';
          }
    }
}