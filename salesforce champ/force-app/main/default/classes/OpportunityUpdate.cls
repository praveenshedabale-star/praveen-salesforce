public with sharing class  OpportunityUpdate {
    
    public class FlowInputs{

        @invocableVariable 
        public List<Opportunity> Opportunity;

    }
    
@InvocableMethod(label = 'Update Opportunity' description='Opportunity Update' category = 'Opportyunity')
    public static void updateOpp(List<FlowInputs> inputs){
        
        List<Opportunity> oppUpdate = New List<Opportunity>();
        for(FlowInputs input :inputs){
           if(input.Opportunity != null){
            
            List<Opportunity> oppList = [select id,StageName from Opportunity where id in : input.Opportunity];
              
               for(Opportunity opp : oppList){
                   opp.StageName = 'Prospecting';
                   oppUpdate.add(opp);
               }
        } 
        }
        
        if(!oppUpdate.isEmpty()){
            Update oppUpdate;
        }
        
        
    }
}