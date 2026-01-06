public with sharing class ReferralService {
    public static void handleAfterInsert(List<Referral__c> newReferrals) {
        // Logic for after insert, e.g., create initial event
        List<Referral_Event__c> events = new List<Referral_Event__c>();
        for (Referral__c ref : newReferrals) {
            events.add(new Referral_Event__c(
                Referral__c = ref.Id,
                Event_Type__c = 'Status Change',
                Event_Description__c = 'Referral created with status: ' + ref.Referral_Status__c,
                Event_Date__c = System.now()
            ));
        }
        insert events;
    }

    public static void handleAfterUpdate(List<Referral__c> newReferrals, Map<Id, Referral__c> oldMap) {
        List<Referral_Event__c> events = new List<Referral_Event__c>();
        for (Referral__c ref : newReferrals) {
            Referral__c oldRef = oldMap.get(ref.Id);
            if (ref.Referral_Status__c != oldRef.Referral_Status__c) {
                events.add(new Referral_Event__c(
                    Referral__c = ref.Id,
                    Event_Type__c = 'Status Change',
                    Event_Description__c = 'Status changed from ' + oldRef.Referral_Status__c + ' to ' + ref.Referral_Status__c,
                    Event_Date__c = System.now()
                ));
            }
            if (ref.Is_Exception__c && !oldRef.Is_Exception__c) {
                events.add(new Referral_Event__c(
                    Referral__c = ref.Id,
                    Event_Type__c = 'Exception Detected',
                    Event_Description__c = 'Exception flagged: ' + ref.Exception_Reason__c,
                    Event_Date__c = System.now()
                ));
            }
        }
        if (!events.isEmpty()) {
            insert events;
        }
    }

    // Additional service methods for complex validation, etc.
}