public with sharing class EnrollmentScoreController {
    public class ScoreWrapper {
        @AuraEnabled public Decimal score;
        @AuraEnabled public String recommendedAction;
        @AuraEnabled public String sourceSystem;
        @AuraEnabled public Datetime scoredAt;
    }
    @AuraEnabled(cacheable=true)
    public static ScoreWrapper getLatestScore(Id contactId) {
        if (!Schema.sObjectType.Enrollment_Score__c.isAccessible()) {
            throw new AuraHandledException('No access to Enrollment Score object');
        }
        List<Enrollment_Score__c> records = [
            select Score__c, Recommended_Action__c, Source_System__c, Scored_At__c
            from Enrollment_Score__c
            where Contact__c = :contactId
            ORDER by Scored_At__c desc
            limit 1
        ];

        if (records.isEmpty()) {
            return null;
        }
        Enrollment_Score__c rec = records[0];
        ScoreWrapper wrapper = new ScoreWrapper();

        if (Schema.sObjectType.Enrollment_Score__c.fields.Score__c.isAccessible()) {
            wrapper.score = rec.Score__c;
        }
        if (Schema.sObjectType.Enrollment_Score__c.fields.Recommended_Action__c.isAccessible()) {
            wrapper.recommendedAction = rec.Recommended_Action__c;
        }
        if (Schema.sObjectType.Enrollment_Score__c.fields.Source_System__c.isAccessible()) {
            wrapper.sourceSystem = rec.Source_System__c;
        }
        if (Schema.sObjectType.Enrollment_Score__c.fields.Scored_At__c.isAccessible()) {
            wrapper.scoredAt = rec.Scored_At__c;
        }

        return wrapper;
    }
}