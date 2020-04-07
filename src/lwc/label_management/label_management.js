/**
 * Created by Adelchi on 26/03/2020.
 */

import {LightningElement, wire, track, api} from 'lwc';
import getAssignedLabels from '@salesforce/apex/AnyLabelCtrl.getAssignedLabelsList';
import getObjectLabels from '@salesforce/apex/AnyLabelCtrl.getSObjectLabelsListAll';
import update_picklist from '@salesforce/apex/GlobalPicklistEngine.runUpdate';
import is_admin from '@salesforce/apex/AnyLabelCtrl.isAdmin';
import LABELS_OBJECT from  '@salesforce/schema/AnyLabel__c';
import LABEL_FONT_COLOR from '@salesforce/schema/AnyLabel__c.Font_Color__c';
import LABEL_BACKGROUND_COLOR from '@salesforce/schema/AnyLabel__c.Background_Color__c';
import ASSIGNEE_NAME from '@salesforce/schema/AnyLabel__c.Assignee__c';
import LABEL_NAME from '@salesforce/schema/AnyLabel__c.Name';
import { updateRecord } from 'lightning/uiRecordApi';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class label_management extends LightningElement {

    showModal = false;

    @api recordId;
    @api objectApiName;
    @track labelColor = '#FFFFFF';
    @track fontColor;

    @track labelsList;
    @track allLabelsList;

    @track error;
    @track error2;

    // @wire  (getAssignedLabels, {recordId: '$recordId'}) labelsList;
    // @wire  (getObjectLabels, {recordId: '$recordId'}) allLabelsList;
    @wire  (is_admin) isAdmin;
    @track labelsAvailable = [];


    @api isAdmin = false;

    // @api drag_handler;
    // @api dragstart_handler;
    // @api drop_handler;
    // @api dragend_handler;
    // @api  dragover_handler;

    connectedCallback(){
        is_admin().then(result => {
            console.log(result);
            this.isAdmin = result;
        });
        getAssignedLabels({recordId: this.recordId}).then(result => {this.labelsList = result;}).then( result =>{
            getObjectLabels({recordId: this.recordId}).then(result => {this.allLabelsList = result;}).then(result => {
                for(let i=0; i<this.allLabelsList.length; i++){
                    if(!this.labelsList.includes(this.allLabelsList[i])){
                        this.labelsAvailable.push(this.allLabelsList[i]);
                    }
                }
                // this.drag_handler = function(ev) {
                //     ev.dataTransfer.setData("text", ev.target.firstChild.textContent);
                // };
                // this.dragstart_handler = function(ev) {
                //     ev.dataTransfer.setData("text", ev.target.firstChild.textContent);
                // };
                // this.drop_handler = function(ev) {
                //     let data = ev.dataTransfer.getData('text', ev.target.firstChild.textContent);
                //     let nodeChild = document.createElement("span");
                //     let textnode = document.createTextNode(dataTransf);
                //     console.log("data .. "+textnode.wholeText);
                //     nodeChild.classList.add("slds-m-around--xx-small");
                //     nodeChild.appendChild(textnode);
                //     let node = document.createElement("div");
                //     node.classList.add("slds-pill");
                //     node.setAttribute("draggable", "true");
                //     node.addEventListener("drag", this.drag_handler);
                //     node.addEventListener("dragstart", this.dragstart_handler);
                //     node.addEventListener("dragend", this.dragend_handler);
                //     node.setAttribute("data-id", data);
                //     node.appendChild(nodeChild);
                //     if(ev.currentTarget.classList == 'slds-pill-container current' || ev.currentTarget.classList == 'slds-pill-container available'){
                //         console.log('target removed.... '+ev.currentTarget.classList);
                //         console.log('target removed.... '+ev.target.classList);
                //         let el = this.template.querySelector('[data-id="'+data+'"]');
                //         console.log(el);
                //         el.remove();
                //     }
                //     ev.currentTarget.appendChild(node);
                // };
                // this.dragend_handler = function(ev){
                //     ev.preventDefault();
                //     // console.log('dragend target .... '+ev.target.classList);
                //     // if(ev.currentTarget.classList == 'slds-pill-container current' || ev.currentTarget.classList == 'slds-pill-container available'){
                //     // ev.currentTarget.appendChild(node);
                //     // ev.target.remove();
                //     // }
                //     // console.log("start handler ..."+ev.target.classList);
                //     // if(ev.currentTarget.classList('slds-pill-container current') || ev.currentTarget.classList('available')){
                //     //     console.log("destroyed ...");
                //     //     ev.target.remove();
                //     // }
                // };
                // this.dragover_handler = function(ev) {
                //     ev.preventDefault();
                //     console.log("dragOver");
                // };
            });
        });
    }

    toggleModal(){
        if(this.showModal == false){
            this.showModal = true;
        }else{
            this.showModal = false;
        }

    }

    handleDialogClose() {
        alert('closed ... ');
        this.showModal = false;
        //Let parent know that dialog is closed (mainly by that cross button) so it can set proper variables if needed
        // const closedialog = new CustomEvent('closedialog');
        // this.dispatchEvent(closedialog);
        // this.hide();
    }

    createNewLabel() {
        let el = this.template.querySelector("lightning-input");
        let name = JSON.parse(JSON.stringify(el.value));
        let background_Color = this.labelColor;
        let font_Color = this.fontColor;
        if(!background_Color || !font_Color){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Incomplete',
                    message: 'Select a color',
                    variant: 'error',
                    mode: 'pester'
                }),
            );
        }else{
            const fields = {};
            console.log(name+' '+background_Color+' '+font_Color);
            fields[LABEL_NAME.fieldApiName] = name;
            fields[LABEL_FONT_COLOR.fieldApiName] = font_Color;
            fields[LABEL_BACKGROUND_COLOR.fieldApiName] = background_Color;
            fields[ASSIGNEE_NAME.fieldApiName] = this.objectApiName;
            const recordInput = { apiName: LABELS_OBJECT.objectApiName, fields };
            createRecord(recordInput).then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Label created',
                        variant: 'success',
                    }),
                );
                window.location.reload();
            }).catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                        mode: 'pester'
                    }),
                );
            });

        }
    }

    saveLabels(){
        let labels = this.template.querySelector(".current");
        let labelsList = '';
        console.log(labels.children.length);
        for(let i=1; i<labels.children.length; i++){
            labelsList += labels.children[i].textContent+";";
        }
        // console.log("labels ..."+labelsList);
        let recordInput = {fields:{
                Id:  this.recordId,
                Labels__c: labelsList,
            },
        };
        console.log(recordInput.fields.Labels__c);
        console.log(recordInput.fields.Id);
        updateRecord(recordInput)
            .then(() => {
                console.log("saved ...");
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Case Labels updated',
                        variant: 'success'
                    }),
                );
                // location.reload();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.message,
                        variant: 'error',
                        mode: "pester"
                    }),
                );
            });
    }


    drag_handler(ev) {
        ev.dataTransfer.setData("text", ev.target.firstChild.textContent);
    }

    dragstart_handler(ev) {
        ev.dataTransfer.setData("text", ev.target.firstChild.textContent);
    }

    drop_handler(ev) {
        let data = ev.dataTransfer.getData('text', ev.target.firstChild.textContent);
        let nodeChild = document.createElement("span");
        let textnode = document.createTextNode(data);
        console.log("data .. "+textnode.wholeText);
        nodeChild.classList.add("slds-m-around--xx-small");
        nodeChild.appendChild(textnode);
        let node = document.createElement("div");
        node.classList.add("slds-pill");
        node.setAttribute("draggable", "true");
        node.addEventListener("drag", this.drag_handler);
        node.addEventListener("dragstart", this.dragstart_handler);
        node.addEventListener("dragend", this.dragend_handler);
        node.appendChild(nodeChild);
        node.setAttribute("data-id", data);
        if(ev.currentTarget.classList == 'slds-pill-container current' || ev.currentTarget.classList == 'slds-pill-container available'){
            console.log('target removed.... '+ev.currentTarget.classList);
            console.log('target removed.... '+ev.target.classList);
            let el = this.template.querySelector('[data-id="'+data+'"]');
            console.log(el);
            el.remove();
        }
        ev.currentTarget.appendChild(node);
    }

    dragend_handler(ev){
        ev.preventDefault();
        console.log('dragend target .... '+ev.target.classList);
        // if(ev.currentTarget.classList == 'slds-pill-container current' || ev.currentTarget.classList == 'slds-pill-container available'){
        // ev.currentTarget.appendChild(node);
        // ev.target.remove();
        // }
        // console.log("start handler ..."+ev.target.classList);
        // if(ev.currentTarget.classList('slds-pill-container current') || ev.currentTarget.classList('available')){
        //     console.log("destroyed ...");
        //     ev.target.remove();
        // }
    }

    dragover_handler(ev) {
        ev.preventDefault();
        console.log("dragOver");
    }

    getColor(event){
        event.preventDefault();
        let color = event.target.value;
        this.labelColor = color;
        this.fontColor = this.getContrastYIQ(color);
    }

    getContrastYIQ(hexColor){
        if (hexColor.slice(0, 1) === '#') {
            hexColor = hexColor.slice(1);
        }
        if (hexColor.length === 3) {
            hexColor = hexColor.split('').map(function (hex) {
                return hex + hex;
            }).join('');
        }
        let r = parseInt(hexColor.substr(0,2),16);
        let g = parseInt(hexColor.substr(2,2),16);
        let b = parseInt(hexColor.substr(4,2),16);
        let yiq = ((r*299)+(g*587)+(b*114))/1000;
        return (yiq >= 128) ? 'black' : 'white';
    }
}