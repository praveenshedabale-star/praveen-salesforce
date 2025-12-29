public class HelloWorldApexClass {
    public static void updateBookPrice(List<Book__c> newBookList){
        for(Book__c b : newBookList){
            b.Price__c *= 0.9;
        }
    }
}