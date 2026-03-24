trigger EnrollmentScoreTrigger on Enrollment_Score__c (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        EnrollmentScoreHandler.updateContactPriority(Trigger.new);
    }
}