@isTest
public class ReferralTriggerHandlerTest {
    @isTest
    static void testRunAfterInsert() {
        Referral__c ref = new Referral__c(Referral_Status__c = 'New', Referral_Type__c = 'Consultation', Source_System__c = 'Test', Priority__c = 'Medium');
        Test.startTest();
        // Simulate trigger context
        Trigger.isAfter = true;
        Trigger.isInsert = true;
        Trigger.new = new List<SObject>{ref};
        ReferralTriggerHandler handler = new ReferralTriggerHandler();
        handler.run();
        Test.stopTest();
        List<Referral_Event__c> events = [SELECT Id FROM Referral_Event__c WHERE Referral__c = :ref.Id];
        System.assertEquals(1, events.size(), 'Should create event on insert');
    }

    @isTest
    static void testRunAfterUpdate() {
        Referral__c ref = new Referral__c(Referral_Status__c = 'New', Referral_Type__c = 'Consultation', Source_System__c = 'Test', Priority__c = 'Medium');
        insert ref;
        ref.Referral_Status__c = 'Validated';
        Test.startTest();
        Trigger.isAfter = true;
        Trigger.isUpdate = true;
        Trigger.new = new List<SObject>{ref};
        Trigger.oldMap = new Map<Id, SObject>{ref.Id => new Referral__c(Id = ref.Id, Referral_Status__c = 'New')};
        ReferralTriggerHandler handler = new ReferralTriggerHandler();
        handler.run();
        Test.stopTest();
        List<Referral_Event__c> events = [SELECT Id FROM Referral_Event__c WHERE Referral__c = :ref.Id];
        System.assertEquals(2, events.size(), 'Should have insert and update events');
    }
}