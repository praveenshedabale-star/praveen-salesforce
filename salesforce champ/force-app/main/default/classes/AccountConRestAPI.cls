@RestResource(urlmapping = '/AccountContactApi')
global with sharing class AccountConRestAPI {
    
    @HttpPost
    global static void saveAccountContactFromExtSystem(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String body = req.requestBody.toString();

        MyJsonCls myObj = (MyJsonCls)JSON.deserialize(body,MyJsonCls.class);

        if(myObj.isAccount == true){
            Account acc = new Account(Name = myObj.CustomerName);
            insert acc;
        }
        else if(myObj.isAccount == false){
                Contact con = new Contact(LastName = myObj.CustomerName);
                insert con;
        }
    }
}