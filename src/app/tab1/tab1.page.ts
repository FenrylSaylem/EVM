import { Component } from '@angular/core';
import { formatDate } from '@angular/common';
import { NavController } from '@ionic/angular';
import { ToastController } from '@ionic/angular';

@Component({
  selector: 'app-tab1',
  templateUrl: 'tab1.page.html',
  styleUrls: ['tab1.page.scss']
})
export class Tab1Page {

  defBtn: any;

  constructor(public navCtrl: NavController, public toastController: ToastController) {
    
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

  ionViewDidEnter() {
    document.title = "EVStore";
  }
  
  async presentToast() {
    const toast = await this.toastController.create({
      message: 'Value could not be applied',
      duration: 2000
    });
    toast.present();
  }

  checkSliderValues(){
    if(this.minLevel>=this.maxLevel){
      this.maxLevel=this.minLevel;
      this.presentToast();
    }
    if(this.minLevel>=this.targetLevel){
      this.maxLevel=this.minLevel;
      this.presentToast();
    }
    if(this.targetLevel>this.maxLevel){
      this.targetLevel=this.maxLevel;
      this.presentToast();
    }
  }

  onChange(){
    //this.checkSliderValues();
  }
  onFocus(){
    this.pickedDate = Date.parse(this.datePick);
    
  }
  onBlur(){
    //this.checkSliderValues();
  }

  
}
