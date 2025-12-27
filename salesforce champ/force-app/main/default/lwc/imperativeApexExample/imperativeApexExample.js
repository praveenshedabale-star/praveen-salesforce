import {LightningElement} from 'lwc';
import getAccounts from '@salesforce/apex/ImperativeApex.getAccounts';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
export default class imperativeApexExample extends LightningElement{
    
    Accounts = [];
    error;
    isChecked = false;

    onClickGetAccounts(){
        getAccounts()
            .then(result => {
                this.Accounts = result;
                this.error = undefined;
                this.isChecked = !this.isChecked;
                if(this.isChecked){
                    this.showNotification();
                }
            })
            .catch(error => {
                this.error = error;
                this.Accounts = undefined;
            });
    }

    showNotification(){
        const evt = new ShowToastEvent({
            title : "Success",
            message : "Records detch successfull",
            variant : "Success",
            mode : "pester"
        });
        this.dispatchEvent(evt);
    }
}
