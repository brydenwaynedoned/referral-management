public with sharing class ReferralTriggerHandler {
    public void run() {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                // Before insert logic if needed
            } else if (Trigger.isUpdate) {
                // Before update logic if needed
            }
        } else if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                ReferralService.handleAfterInsert(Trigger.new);
            } else if (Trigger.isUpdate) {
                ReferralService.handleAfterUpdate(Trigger.new, Trigger.oldMap);
            }
        }
    }
}