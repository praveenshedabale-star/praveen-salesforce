public class MyFirstScheduledBatch implements schedulable{

    public void execute(SchedulableContext context){
        system.debug('hi praveen');
        system.enqueueJob(New myQueueableClass3());
    }
}