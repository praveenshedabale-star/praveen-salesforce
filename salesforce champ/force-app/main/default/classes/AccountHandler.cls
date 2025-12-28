public class AccountHandler{
    //Before insert
    public static void populateShippingAddress(List<Account> accList){
        for(Account acc: accList){
            if(acc.BillingCity != null){
                acc.ShippingCity = acc.BillingCity;
            }
            system.debug('@@q'+acc.BillingCountry);
            if(acc.BillingCountry != null){
                system.debug('@@q'+acc.BillingCountry);
                acc.ShippingCountry = acc.BillingCountry;
            }
            if(acc.BillingCountryCode != null){
                system.debug('@@q'+acc.BillingCountry);
                acc.ShippingCountryCode = acc.BillingCountryCode;
            }
            if(acc.BillingStreet != null){
                system.debug('@@q'+acc.BillingStreet);
                acc.ShippingStreet = acc.BillingStreet;
            }
            if(acc.BillingPostalCode != null){
                system.debug('@@q'+acc.BillingCountry);
                acc.ShippingPostalCode = acc.BillingPostalCode;
            }
        }      
}
    public static void throwError(List<Account> accList){
            for(Account acc: accList){
                if(acc.AnnualRevenue < 1000){
                    acc.AnnualRevenue.addError('Annual revenue cannot be less than 1000');
                }
            }
        }
    
    public static void createContact(List<Account> accList){
        List<Contact> conList = new List<Contact>();
        for(Account acc: accList){
            Contact con = new Contact();
            con.LastName = acc.Name;
            con.AccountId = acc.id;
            conList.add(con);
        }
        if(!conList.isEmpty()){
            insert conList;
        }
    }

    //Update description with username whenever Account record is edited.
    public static void updateDescription(List<Account> newList,Map<id,Account> oldMap){
        for(Account acc : newList){
           if(Trigger.isUpdate && !oldMap.isEmpty()){
                acc.description = 'LastModified user name on this Account is : '+userInfo.getName();
           }
        }
      }
}