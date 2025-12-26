import { LightningElement } from 'lwc';

export default class CondoitionalRenderingLWC extends LightningElement {

        isValid = false;
        name = 'praveen';
        onchangeCall(){
                this.isValid = true;
        }
}