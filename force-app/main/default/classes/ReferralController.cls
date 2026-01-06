public with sharing class ReferralController {
    @AuraEnabled(cacheable=true)
    public static List<Referral_Event__c> getReferralEvents(Id referralId) {
        return [SELECT Id, Event_Type__c, Description__c, CreatedDate FROM Referral_Event__c WHERE Referral__c = :referralId ORDER BY CreatedDate DESC];
    }
}