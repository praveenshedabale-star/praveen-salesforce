import { LightningElement, api, wire } from 'lwc';
import getLatestScore from '@salesforce/apex/EnrollmentScoreController.getLatestScore';

export default class EnrollmentScoreCard extends LightningElement {

    @api recordId; // Contact Id

    scoreData;
    error;

    @wire(getLatestScore, { contactId: '$recordId' })
    wiredScore({ data, error }) {
        if (data) {
            this.scoreData = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.scoreData = undefined;
        }
    }

    get hasData() {
        return this.scoreData != null;
    }

    get badgeClass() {
        if (!this.scoreData || this.scoreData.score == null) return '';

        let score = this.scoreData.score;

        if (score >= 75) return 'badge hot';
        if (score >= 40) return 'badge warm';
        return 'badge cold';
    }

    get priorityLabel() {
        if (!this.scoreData || this.scoreData.score == null) return '';

        let score = this.scoreData.score;

        if (score >= 75) return 'Hot';
        if (score >= 40) return 'Warm';
        return 'Cold';
    }
}