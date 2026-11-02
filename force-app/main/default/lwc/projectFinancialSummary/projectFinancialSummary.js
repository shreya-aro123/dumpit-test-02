import { LightningElement, api, wire, track } from 'lwc';

export default class ProjectFinancialSummary extends LightningElement {
    @api recordId;
    @track projectDetails;
    @track isLoading = false;
}