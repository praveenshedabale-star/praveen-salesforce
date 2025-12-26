import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/wirecall.getAccounts';
export default class WireCallApexExample extends LightningElement{

 Accounts = [];
 @wire(getAccounts)
 wiredAccounts({data,Error}){
      if(data){
            this.Accounts = data;
      }
      if(Error){
            console.Error('The Error has occured');
      }
 }

}