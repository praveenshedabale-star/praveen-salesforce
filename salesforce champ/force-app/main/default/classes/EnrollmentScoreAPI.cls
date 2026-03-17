@RestResource(urlMapping='/enrollment-scores/*')
global with sharing class EnrollmentScoreAPI {

    global class ScoreRequest {
        public List<ScoreData> scores;
    }
    global class ScoreData {
        public String contactEmail;
        public Decimal score;
        public String recommendedAction;
        public String sourceSystem;
        public Datetime scoredAt;
    }
    global class ScoreResponse {
        public String contactEmail;
        public Boolean success;
        public String message;
        public Id recordId;
    }

    @HttpPost
    global static List<ScoreResponse> createScores() {
        RestRequest req = RestContext.request;
        String requestBody = req.requestBody.toString();
        ScoreRequest input = (ScoreRequest) JSON.deserialize(requestBody, ScoreRequest.class);
        List<ScoreResponse> responseList = new List<ScoreResponse>();
        if (input == null || input.scores == null || input.scores.isEmpty()) {
            return responseList;
        }
        Set<String> emails = new Set<String>();
        for (ScoreData sd : input.scores) {
            if (sd.contactEmail != null) {
                emails.add(sd.contactEmail.toLowerCase());
            }
        }
        Map<String, Contact> emailToContact = new Map<String, Contact>();
        for (Contact c : [ select Id, Email from Contact where Email IN :emails]) {
            emailToContact.put(c.Email.toLowerCase(), c);
        }
        List<Enrollment_Score__c> recordsToInsert = new List<Enrollment_Score__c>();
        List<ScoreResponse> tempResponses = new List<ScoreResponse>();

        for (ScoreData sd : input.scores) {
            ScoreResponse res = new ScoreResponse();
            res.contactEmail = sd.contactEmail;
            if (sd.contactEmail == null || !emailToContact.containsKey(sd.contactEmail.toLowerCase())) {
                res.success = false;
                res.message = 'Contact not found';
                responseList.add(res);
                continue;
            }
            Enrollment_Score__c record = new Enrollment_Score__c();
            record.Contact__c = emailToContact.get(sd.contactEmail.toLowerCase()).Id;
            record.Score__c = sd.score;
            record.Recommended_Action__c = sd.recommendedAction;
            record.Source_System__c = sd.sourceSystem;
            record.Scored_At__c = sd.scoredAt;

            recordsToInsert.add(record);
            tempResponses.add(res);
        }
        if (!recordsToInsert.isEmpty()) {
            Database.SaveResult[] results = Database.insert(recordsToInsert, false);
            for (Integer i = 0; i < results.size(); i++) {
                ScoreResponse res = tempResponses[i];
                if (results[i].isSuccess()) {
                    res.success = true;
                    res.recordId = results[i].getId();
                    res.message = 'Record created';
                } else {
                    res.success = false;
                    res.message = results[i].getErrors()[0].getMessage();
                }
                responseList.add(res);
            }
        }
        return responseList;
    }
}