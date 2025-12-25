import { LightningElement } from 'lwc';

export default class TwoWayBinding extends LightningElement {

    number;
    changeHandler(event){
        this.number = event.target.value;
    }
}