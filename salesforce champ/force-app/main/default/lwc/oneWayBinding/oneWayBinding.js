import { LightningElement } from 'lwc';

export default class OneWayBinding extends LightningElement {
     personName = 'Praveen KS';
     age = 20;

     connectedCallback(){
       console.log('hellow');
     }

     is18yearOld(){
          return this.age === 18;
     }
}