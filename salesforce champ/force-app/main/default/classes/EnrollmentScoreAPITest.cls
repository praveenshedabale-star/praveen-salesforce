@isTest
private class EnrollmentScoreAPITest {
    @testSetup
    static void setupData() {
        Account acc = new Account();
        acc.Name = 'Praveen_NewTest';
        insert acc;
        
        List<Contact> contacts = new List<Contact>{
            new Contact(AccountId = acc.Id,LastName = 'User1', Email = 'user1@test.com'),
            new Contact(AccountId = acc.Id,LastName = 'User2', Email = 'user2@test.com'),
            new Contact(AccountId = acc.Id,LastName = 'User3', Email = 'user3@test.com')
        };
        insert contacts;
    }
    @isTest
    static void testCreateScores_Positive() {

        Map<String, Object> payload = new Map<String, Object>();
        List<Object> scores = new List<Object>();

        scores.add(new Map<String, Object>{
            'contactEmail' => 'user1@test.com',
            'score' => 85,
            'recommendedAction' => 'Call',
            'sourceSystem' => 'Test',
            'scoredAt' => System.now()
        });

        payload.put('scores', scores);

        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/enrollment-scores/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(payload));

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        List<EnrollmentScoreAPI.ScoreResponse> response =
            EnrollmentScoreAPI.createScores();
        Test.stopTest();

        System.assertEquals(1, response.size());
        List<Enrollment_Score__c> records = [SELECT Id FROM Enrollment_Score__c];
    }
    @isTest
    static void testCreateScores_InvalidEmail() {

        Map<String, Object> payload = new Map<String, Object>();
        List<Object> scores = new List<Object>();

        scores.add(new Map<String, Object>{
            'contactEmail' => 'notfound@test.com',
            'score' => 50,
            'recommendedAction' => 'Email',
            'sourceSystem' => 'Test',
            'scoredAt' => System.now()
        });

        payload.put('scores', scores);

        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/enrollment-scores/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(payload));

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        List<EnrollmentScoreAPI.ScoreResponse> response =
            EnrollmentScoreAPI.createScores();
        Test.stopTest();

        System.assertEquals(1, response.size());
        System.assertEquals(false, response[0].success);
        System.assertEquals('Contact not found', response[0].message);
    }
    @isTest
    static void testCreateScores_Bulk() {

        Map<String, Object> payload = new Map<String, Object>();
        List<Object> scores = new List<Object>();
        for (Integer i = 1; i <= 3; i++) {
            scores.add(new Map<String, Object>{
                'contactEmail' => 'user' + i + '@test.com',
                'score' => 70,
                'recommendedAction' => 'Call',
                'sourceSystem' => 'BulkTest',
                'scoredAt' => System.now()
            });
        }

        scores.add(new Map<String, Object>{
            'contactEmail' => 'invalid1@test.com',
            'score' => 40,
            'recommendedAction' => 'Email',
            'sourceSystem' => 'BulkTest',
            'scoredAt' => System.now()
        });

        scores.add(new Map<String, Object>{
            'contactEmail' => 'invalid2@test.com',
            'score' => 30,
            'recommendedAction' => 'SMS',
            'sourceSystem' => 'BulkTest',
            'scoredAt' => System.now()
        });

        payload.put('scores', scores);

        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/enrollment-scores/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(payload));

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        List<EnrollmentScoreAPI.ScoreResponse> response =
            EnrollmentScoreAPI.createScores();
        Test.stopTest();

        System.assertEquals(5, response.size());

        Integer successCount = 0;
        Integer failCount = 0;

        for (EnrollmentScoreAPI.ScoreResponse res : response) {
            if (res.success) successCount++;
            else failCount++;
        }
    }
}