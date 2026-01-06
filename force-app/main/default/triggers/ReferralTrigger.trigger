trigger ReferralTrigger on Referral__c (before insert, before update, after insert, after update) {
    new ReferralTriggerHandler().run();
}