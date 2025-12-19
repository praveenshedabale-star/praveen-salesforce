Public Class MyFirstBatch implements Database.batchable<Sobject>{
    
    public database.QueryLocator start(Database.batchableContext bc){
        return Database.getqueryLocator( 'select  id , description from case limit 1');
    }
    public void execute(database.batchableContext bc, List<Case> scope){
        List<Case> caseListUpdate = new List<Case>();
        for(Case cs : scope){
            system.debug('@@'+cs.id);
 			cs.Description = 'hi praveen';
            caseListUpdate.add(cs);
        }
        if(!caseListUpdate.isEmpty()){
            update caseListUpdate;
        }
        
    }
    public void finish(database.batchableContext bc){
    	system.debug('hi praveen');    
    }
}