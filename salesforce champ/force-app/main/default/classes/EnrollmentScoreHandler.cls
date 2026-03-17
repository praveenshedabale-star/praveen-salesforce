public with sharing class EnrollmentScoreHandler {
    public static void updateContactPriority(List<Enrollment_Score__c> newScores) {
        Map<Id, Enrollment_Score__c> contactToLatestScore = new Map<Id, Enrollment_Score__c>();
        for (Enrollment_Score__c rec : newScores) {
            if (rec.Contact__c == null) continue;
            if (!contactToLatestScore.containsKey(rec.Contact__c)) {
                contactToLatestScore.put(rec.Contact__c, rec);
            } else {
                Enrollment_Score__c existing = contactToLatestScore.get(rec.Contact__c);
                 //latest score
                if (rec.Scored_At__c != null && existing.Scored_At__c != null &&
                    rec.Scored_At__c > existing.Scored_At__c) {
                    contactToLatestScore.put(rec.Contact__c, rec);
                }
            }
        }
        //quering contacts
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Contact con : [ select Id, Enrollment_Priority__c from Contact where Id IN :contactToLatestScore.keySet()]) {
            Enrollment_Score__c latest = contactToLatestScore.get(con.Id);
            String priority = getPriority(latest.Score__c);
            
            if (priority != null && con.Enrollment_Priority__c != priority) {
                con.Enrollment_Priority__c = priority;
                contactsToUpdate.add(con);
            }
        }
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
    private static String getPriority(Decimal score) {
        if (score == null) return null;
        if (score >= 75) return 'Hot';
        else if (score >= 40) return 'Warm';
        else return 'Cold';
    }
    
}