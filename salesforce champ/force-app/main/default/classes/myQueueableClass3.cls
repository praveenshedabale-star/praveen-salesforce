public class myQueueableClass3 implements queueable{
    
    public void execute(QueueableContext Context){
        List<Case> caseList = [select id from case where caseNumber = '00001033' limit 1];
        
       // AccountnewTrigger.myMethod(caseList[0].id);
       //system.enqueueJob(New myQueueableClass3());
       system.debug('hi i am job 3');
    }
}