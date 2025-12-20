import { LightningElement } from 'lwc';

export default class BmiCalculator extends LightningElement {

    height;
    weight;
    showResult = false;
    bmiValue;

    callHeight(event){
        this.height = event.target.value;
    }

    callWeight(event){
        this.weight = event.target.value;
    }

    handleClick(){
        this.showResult = true;
       this.bmiValue = this.calculate(this.height,this.weight);
    }

    calculate(height,weight){
        const convertedHeight = height * 0.01;
        const bmiResult = weight /convertedHeight * convertedHeight;
        return bmiResult;
    }
    callRecalculate(){
      this.height = '';
      this.weight = '';
      this.showResult = false;
      this.bmiValue = '';
    }
}