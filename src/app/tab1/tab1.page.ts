import { Component } from '@angular/core';
import { formatDate } from '@angular/common';
import { NavController } from '@ionic/angular';

@Component({
  selector: 'app-tab1',
  templateUrl: 'tab1.page.html',
  styleUrls: ['tab1.page.scss']
})
export class Tab1Page {

  defBtn: any;

  constructor(public navCtrl: NavController) {
    
  }

  maxLevel: any;
  minLevel: any;
  targetLevel: any;
  datePick: any;
  pickedDate: any;

  date = new Date();
  dateSeconds=this.date.getTime();
  readableDate= formatDate(this.date,"MMM/d/yy, h:mm a","en","UTC+1");
  isoDate = this.date.toISOString();
  


  onChange(){
    this.minLevel;
    if (this.minLevel>=this.maxLevel){
      this.maxLevel=this.minLevel;
    }
    if (this.minLevel>=this.targetLevel){
      this.targetLevel=this.minLevel;
    }
  }
  onFocus(){
    this.pickedDate = Date.parse(this.datePick);
    
  }
  onBlur(){
    if(this.maxLevel<this.minLevel){
      this.maxLevel=this.minLevel
    }
    if (this.minLevel>=this.targetLevel){
      this.targetLevel=this.minLevel;
    }
  }

  
}
