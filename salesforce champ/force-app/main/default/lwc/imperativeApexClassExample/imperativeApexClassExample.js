import { LightningElement } from 'lwc';
import getContacts from '@salesforce/apex/ImperativeApexExample.getContacts'
import { ShowToastEvent } from "lightning/platformShowToastEvent";
export default class ImperativeApexClassExample extends LightningElement {

    Contacts = [];
    isFirstClick = false;

    titleText = "Contacts fetch success";
    messageText = "Successfully contacts fetched";
    variant = "Success";
    onClieckGetContacts(){

          getContacts()
                .then(result => 
                {
                    this.Contacts = result;
                    console.log('here its printed');
                    /*
                    if(!this.isFirstClick){
                        this.isFirstClick = true;
                    }else{
                        this.isFirstClick = false;
                    }*/
                   this.isFirstClick = !this.isFirstClick;
                   if(this.isFirstClick){
                    this.showNotification();
                   }
                })
                .catch(Error => 
                {
                    console.Error('Error fetching the contacts',Error);
                }
                );
          }

    showNotification() {
        const evt = new ShowToastEvent({
        title: this.titleText,
        message: this.messageText,
        variant: this.variant,
        });
            this.dispatchEvent(evt);
     }
 }