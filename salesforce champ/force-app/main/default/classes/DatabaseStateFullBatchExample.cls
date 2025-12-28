public class DatabaseStateFullBatchExample implements Database.Batchable <Sobject>, Database.Stateful {
    public Set<Id> failedIds = new Set<Id>();
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('Select id from Case where CaseOrigin = Email');
    }
    public void execute(Database.BatchableContext bc, List<Case> scope){
        for(Case cs : scope){
            cs.Description = 'hello';
        }
        Database.saveResult result = Datbase.update(scope,false);
        for(Integer i=0; i<result.size(); i++){
            if(!result[i].isSuccess()){
                failedIds.add(scope[i].id);
            }
        }
    }
    public void finish(Database.BatchableContext  bc){
        Messaging.SingleEmailMessage em = new Messaging.SingleEmailMessage();
        em.setToAddresses('pavishe43@gmail.com');
        em.setPlainTextBody('Batch processed with an error :' +failedIds);
        em.setSubject('Batch processed successfully').

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { em });
    }
}