public class BJ_AccountUpdate implements Database.Batchable<Sobject> {
  
    public DataBase.QueryLocator start(Database.BatchableContext bc){
        return DataBase.getQueryLocator('select id,Name,Phone from account');
      }
    public void execute(Database.BatchableContext bc, List<Account> accountList){
        for(Account acc : accountList){
            if(acc.Phone == Null){
                acc.Phone = '1234567891';
            }
        }
        Update accountList;
    }

    public void finish(Database.BatchableContext bc){
        system.debug('Completed');
    }
}