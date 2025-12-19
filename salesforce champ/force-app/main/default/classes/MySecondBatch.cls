public Class MySecondBatch implements Database.batchable<Sobject>{
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('select id, description from case limit 1');
    }
    
    public void execute(Database.batchableContext bc,List<Case> scope){
        List<Case> caseListUpdate = new List<Case>();
        for(Case cs : scope){
            cs.Description = 'test details';
            caseListUpdate.add(cs);
        }
        if(!caseListUpdate.isEmpty()){
            Update caseListUpdate;
        }
    }
    public void finish(Database.batchableContext bc){
        system.debug('the update has been successfully finished');
    }
}