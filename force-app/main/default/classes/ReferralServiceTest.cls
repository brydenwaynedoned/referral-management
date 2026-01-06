@isTest
public class ReferralServiceTest {
    @isTest
    static void testHandleAfterInsert() {
        Referral__c ref = new Referral__c(Referral_Status__c = 'New', Referral_Type__c = 'Consultation', Source_System__c = 'Test', Priority__c = 'Medium');
        insert ref; // This will trigger, but since no trigger, manual call
        Test.startTest();
        ReferralService.handleAfterInsert(new List<Referral__c>{ref});
        Test.stopTest();
        List<Referral_Event__c> events = [SELECT Id, Event_Type__c, Event_Description__c FROM Referral_Event__c WHERE Referral__c = :ref.Id];
        System.assertEquals(1, events.size(), 'Should create one event');
        System.assertEquals('Status Change', events[0].Event_Type__c);
    }

    @isTest
    static void testHandleAfterUpdate() {
        Referral__c ref = new Referral__c(Referral_Status__c = 'New', Referral_Type__c = 'Consultation', Source_System__c = 'Test', Priority__c = 'Medium');
        insert ref;
        ref.Referral_Status__c = 'Validated';
        Test.startTest();
        ReferralService.handleAfterUpdate(new List<Referral__c>{ref}, new Map<Id, Referral__c>{ref.Id => new Referral__c(Id = ref.Id, Referral_Status__c = 'New')});
        Test.stopTest();
        List<Referral_Event__c> events = [SELECT Id, Event_Type__c FROM Referral_Event__c WHERE Referral__c = :ref.Id];
        System.assertEquals(2, events.size(), 'Should have two events: insert and update');
    }
}