import { LightningElement } from 'lwc';
import fetchAccounts from '@salesforce/apex/AccountHandler1.fetchAccounts';
export default class ImperativeExample2 extends LightningElement {
    accounts = [];
    error;

    column = [
        {label : 'Account Revenue',FieldName : 'AccountRevenue'},
        {label : 'Account Name',FieldName : 'Name'}
    ];
    
    fetchData(){
        fetchAccounts()
            .then(result => {
                this.accounts = result;
            })
            .error(error => {
                this.error = error;
            })        
    }
}