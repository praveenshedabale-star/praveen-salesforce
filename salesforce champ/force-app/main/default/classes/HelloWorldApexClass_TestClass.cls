@isTest
public class HelloWorldApexClass_TestClass {

     @isTest
     public static void testBookPriceFunctionality(){

        Book__c b = new Book__c(name = 'first Book',Price__c = 100);
        insert b;
        system.debug('price book value is '+b.price__c);


       b = [select Price__c from Book__c where id =: b.id];

        System.assertEquals(90, b.Price__c);
     }
}