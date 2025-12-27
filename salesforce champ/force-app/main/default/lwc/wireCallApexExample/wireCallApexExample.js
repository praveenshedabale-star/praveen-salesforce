import {LightningElement,wire} from 'lwc';
import getAccounts from '@salesforce/apex/wirecall.getAccounts';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
export default class wireCallApexExample extends LightningElement{

      Accounts = [];

      @wire(getAccounts)
      wiredAccounts({data,Error}){
            if(data){
                  this.Accounts = data;
                  this.showToastNotification();
            }
            else if(Error){
                  console.error('There is an error');
            }
      }

      showToastNotification(){
            const evt = new ShowToastEvent({
                  title : "success",
                  message : "Wire Ran successfully",
                  variant : "success",
                  mode : "pester"
            });
             this.dispatchEvent(evt);
      }
}