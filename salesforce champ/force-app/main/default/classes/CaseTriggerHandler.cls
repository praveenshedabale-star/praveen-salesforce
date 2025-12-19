public class CaseTriggerHandler {

    Public static void caseTeriggerBeforeDelete(List<Case> oldRecList){
        
        //Allow system admins only to delete Cases.
        String ProfileId = UserInfo.GetProfileId();
        Id systemADminProfileId = [Select id from profile where name = 'System Administrator'].Id;
        for(Case cas : oldRecList){
            if(ProfileId != systemADminProfileId){
               cas.addError('Case can be deleted only by system administrator');
            }
        }
            
    }
}