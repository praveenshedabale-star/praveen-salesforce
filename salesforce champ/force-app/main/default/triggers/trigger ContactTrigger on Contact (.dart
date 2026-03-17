trigger ContactTrigger on Contact (
    after insert,
    after update,
    after delete,
    after undelete
) {
    Set<Id> accountIds = new Set<Id>();

    // Collect Account Ids from new records
    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Contact con : Trigger.new) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }
    }

    // Collect Account Ids from old records (for delete)
    if (Trigger.isDelete) {
        for (Contact con : Trigger.old) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }
    }

    if (accountIds.isEmpty()) return;

    // Map to store AccountId → List of phone numbers
    Map<Id, List<String>> accPhoneMap = new Map<Id, List<String>>();

    // Query all related contacts
    for (Contact con : [
        SELECT AccountId, Phone
        FROM Contact
        WHERE AccountId IN :accountIds
        AND Phone != null
    ]) {
        if (!accPhoneMap.containsKey(con.AccountId)) {
            accPhoneMap.put(con.AccountId, new List<String>());
        }
        accPhoneMap.get(con.AccountId).add(con.Phone);
    }

    // Prepare Accounts for update
    List<Account> accountsToUpdate = new List<Account>();

    for (Id accId : accPhoneMap.keySet()) {
        Account acc = new Account();
        acc.Id = accId;
        acc.Description = String.join(accPhoneMap.get(accId), ', ');
        accountsToUpdate.add(acc);
    }

    if (!accountsToUpdate.isEmpty()) {
        update accountsToUpdate;
    }
}
