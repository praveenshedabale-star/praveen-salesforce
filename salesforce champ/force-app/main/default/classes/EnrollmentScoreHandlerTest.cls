@isTest
private class EnrollmentScoreHandlerTest {
    @testSetup
    static void setupData() {
        Account acc = new Account();
        acc.Name = 'PraveenNewTest';
        insert acc;
        insert new Contact(
            LastName = 'Trigger Test',
            AccountId = acc.Id,
            Email = 'trigger@test.com'
        );
    }
    @isTest
    static void testPriorityMapping() {

        Contact c = [SELECT Id FROM Contact LIMIT 1];

        List<Enrollment_Score__c> scores = new List<Enrollment_Score__c>{
            new Enrollment_Score__c(
                Contact__c = c.Id,
                Score__c = 80,
                Scored_At__c = System.now()
            ),
            new Enrollment_Score__c(
                Contact__c = c.Id,
                Score__c = 50,
                Scored_At__c = System.now().addMinutes(-1)
            ),
            new Enrollment_Score__c(
                Contact__c = c.Id,
                Score__c = 20,
                Scored_At__c = System.now().addMinutes(-2)
            )
        };
        Test.startTest();
        insert scores;
        Test.stopTest();

        Contact updated = [
            SELECT Enrollment_Priority__c
            FROM Contact
            WHERE Id = :c.Id
        ];
        System.assertEquals('Hot', updated.Enrollment_Priority__c,
            'Latest score should determine priority');
    }
    @isTest
    static void testLatestScoreWins() {
        Contact c = [SELECT Id FROM Contact LIMIT 1];
        List<Enrollment_Score__c> scores = new List<Enrollment_Score__c>{
            new Enrollment_Score__c(
                Contact__c = c.Id,
                Score__c = 30,
                Scored_At__c = System.now().addHours(-2)
            ),
            new Enrollment_Score__c(
                Contact__c = c.Id,
                Score__c = 85,
                Scored_At__c = System.now()
            )
        };
        Test.startTest();
        insert scores;
        Test.stopTest();

        Contact updated = [
            SELECT Enrollment_Priority__c
            FROM Contact
            WHERE Id = :c.Id
        ];
        System.assertEquals('Hot', updated.Enrollment_Priority__c,
            'Latest timestamp record should win');
    }
    @isTest
    static void testNullContactIgnored() {
        Enrollment_Score__c score = new Enrollment_Score__c(
            Score__c = 90,
            Scored_At__c = System.now()
        );
        Test.startTest();
        insert score;
        Test.stopTest();
        System.assert(true, 'Record without contact should not fail');
    }
}