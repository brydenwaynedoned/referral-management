import { LightningElement, api, wire } from 'lwc';
import getReferralEvents from '@salesforce/apex/ReferralController.getReferralEvents';

const columns = [
    { label: 'Event Type', fieldName: 'Event_Type__c' },
    { label: 'Description', fieldName: 'Description__c' },
    { label: 'Date', fieldName: 'CreatedDate', type: 'date' }
];

export default class ReferralTimeline extends LightningElement {
    @api recordId;
    events = [];
    columns = columns;

    @wire(getReferralEvents, { referralId: '$recordId' })
    wiredEvents({ error, data }) {
        if (data) {
            this.events = data;
        } else if (error) {
            console.error(error);
        }
    }
}