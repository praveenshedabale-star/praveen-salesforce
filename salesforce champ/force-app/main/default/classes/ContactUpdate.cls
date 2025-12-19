public with sharing class  ContactUpdate {
    
    public class FlowInputs{

        @invocableVariable 
        public List<Contact> Contact;

    }
    
@InvocableMethod(label = 'Update contact' description='contact Update' category = 'Contact')
    public static void updateOpp(List<FlowInputs> inputs){
        
        List<Contact> conUpdate = New List<Contact>();
        for(FlowInputs input :inputs){
           if(input.Contact != null){
            
            List<Contact> conList = [select id,FirstName from Contact where id in : input.Contact];
              
               for(Contact con : conList){
                   con.FirstName = 'Salesforce test';
                   conUpdate.add(con);
               }
        } 
        }
        
        if(!conUpdate.isEmpty()){
				update conUpdate;		
        }
        
        
    }
}