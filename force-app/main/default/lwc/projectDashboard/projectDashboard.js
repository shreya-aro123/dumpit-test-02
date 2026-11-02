import { LightningElement, track } from 'lwc';

export default class ProjectDashboard extends LightningElement {
    @track projects = [];
    columns = [
        { label: 'Project Name', fieldName: 'Name' },
        { label: 'Status', fieldName: 'Status__c' },
        { label: 'Budget', fieldName: 'Budget__c', type: 'currency' }
    ];
}