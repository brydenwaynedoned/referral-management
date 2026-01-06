@isTest
public class ReferralControllerTest {
    @TestSetup
    static void makeData(){
        Referral__c ref = new Referral__c(Referral_Status__c = 'New', Referral_Type__c = 'Consultation', Source_System__c = 'Test', Priority__c = 'Medium');
        insert ref;
        Referral_Event__c event = new Referral_Event__c(Referral__c = ref.Id, Event_Type__c = 'Status Change', Event_Description__c = 'Test event', Event_Date__c = System.now());
        insert event;
    }

    @isTest
    static void testGetReferralEvents() {
        Referral__c ref = [SELECT Id FROM Referral__c LIMIT 1];
        Test.startTest();
        List<Referral_Event__c> events = ReferralController.getReferralEvents(ref.Id);
        Test.stopTest();
        System.assertEquals(1, events.size(), 'Should return one event');
        System.assertEquals('Status Change', events[0].Event_Type__c, 'Event type should match');
    }
}