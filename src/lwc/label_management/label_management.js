/**
 * Created by Adelchi on 26/03/2020.
 */

import {LightningElement, wire, track, api} from 'lwc';
import getAssignedLabels from '@salesforce/apex/AnyLabelCtrl.getAssignedLabelsList';
import deleteLabelsFromObject from '@salesforce/apex/AnyLabelCtrl.removeLabelsFromObject';
import getGlobal from '@salesforce/apex/AnyLabelCtrl.getGlobalLabels';
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

    @api myAttribute = 'background-color: red; color: white';

    @api showModal = false;
    @api recordId;
    @api objectApiName;
    @track labelColor = '#FFFFFF';
    @track fontColor;
    @api labelSample ;
    @track labelsList = [];
    @track allLabelsList = [];
    @track allUnassignedObjectLabList = [];
    @api allAssignedObjectLabList = [];
    @api globalLabelsList = [];
    @track labelsToBeRemoved;
    @track error;
    @track error2;
    @wire (is_admin) isAdmin;
    @track labelsAvailable = [];
    @track colorHEX;
    @api openAvailable = false;
    @track tempList = [];

    connectedCallback(){
        is_admin().then(result => {
            this.isAdmin = result;
        });
        getGlobal().then(  result => {
            for(let i=0; i<result.length; i++){
                if(!result[i].Assignee__c.includes(this.objectApiName)){
                    this.allUnassignedObjectLabList.push({
                        Name : result[i].Name,
                        Styling : "background-color: "+result[i].Background_Color__c+"; color: "+result[i].Font_Color__c+"; cursor: grab",
                        Assigned : result[i].Assignee__c,
                    });
                }
                if(result[i].Assignee__c.includes(this.objectApiName)){
                    this.allAssignedObjectLabList.push({
                        Name : result[i].Name,
                        Styling : "background-color: "+result[i].Background_Color__c+"; color: "+result[i].Font_Color__c+"; cursor: grab",
                        Assigned : result[i].Assignee__c,
                    });
                }
            }
        }).then(result => {
                getAssignedLabels({recordId: this.recordId}).then( result => {
                    if(result!=null){
                        for(let i=0; i<result.length; i++){
                            this.labelsList.push({
                                Name : result[i].Name,
                                Styling : "background-color: "+result[i].Background_Color__c+"; color: "+result[i].Font_Color__c+"; cursor: grab",
                                Assigned : result[i].Assignee__c,
                            });
                        }
                    }}).then(result =>{
                    for(let i=0; i<this.allAssignedObjectLabList.length; i++){
                        let recordAssignedLabels = [];
                        for(let i=0; i<this.labelsList.length; i++){
                            recordAssignedLabels.push(this.labelsList[i].Name);
                        }
                        if(!recordAssignedLabels.includes(this.allAssignedObjectLabList[i].Name)){
                            this.labelsAvailable.push(this.allAssignedObjectLabList[i]);
                        }
                    }
                });

            }
        );
    }

    openAvailableLabels(event){
        let el = this.template.querySelector(".availableContainer");
        el.classList.toggle("close");
    }

    filterLabel(event){
        if(event.target.value.length>2){
            let patt = new RegExp(event.target.value.toUpperCase());
            let unAss = [];
            for(let i=0; i<this.allUnassignedObjectLabList.length; i++ ){
                let str = this.allUnassignedObjectLabList[i].Name.toUpperCase();
                if(patt.test(str)){
                    unAss.push(this.allUnassignedObjectLabList[i]);
                }
            }
            this.allUnassignedObjectLabList = unAss;
        }else if (event.target.value.length <2 || event.target.value == ''){
            getGlobal().then( result => {
                let list = [];
                for(let i=0; i<result.length; i++){
                    if(!result[i].Assignee__c.includes(this.objectApiName)){
                        list.push({
                            Name : result[i].Name,
                            Styling : "background-color: "+result[i].Background_Color__c+"; color: "+result[i].Font_Color__c+"; cursor: grab",
                            Assigned : result[i].Assignee__c,
                        });
                    }
                }
                this.allUnassignedObjectLabList = list;
            });
        }
    }

    deleteLabelForObject(event){
        let name = event.target.getAttribute("data-target-Id");
        alert("you are about to delete this label <"+name+"> for all "+this.objectApiName+'.');
        deleteLabelsFromObject({labelsName: name, recordId: this.recordId}).then(result =>{
            console.log(result);
        });
    }

    manageObjectLabel(){
        let object = '';
        object = this.objectApiName;
        let objectStyled = object.toUpperCase();
        let conf = confirm("You are about to modify "+objectStyled+" labels GLOBALLY");
        if(conf){
            let elAss = this.template.querySelector(".associated");
            let elGlob = this.template.querySelector(".global");
            let elAssSize = elAss.querySelectorAll("span").length;
            let elAssChild = elAss.querySelectorAll("span");
            let elGlobSize = elGlob.querySelectorAll("span").length;
            let elGlobChild = elGlob.querySelectorAll("span");
            let labToAdd = [''];
            let labToRem = [''];
            for(let i=0; i<elGlobSize; i++){
                // console.log(elGlobChild[i].innerText);
                labToRem.push(elGlobChild[i].innerText);
            }
            for(let i=0; i<elAssSize; i++){
                // console.log(elAssChild[i].innerText);
                labToAdd.push(elAssChild[i].innerText);
            }
            // console.log(labToAdd.length+'<>'+labToRem.length);
            deleteLabelsFromObject({labelsToRemoveName: labToRem, labelsToAddName: labToAdd, recordId: this.recordId}).then(result =>{
                // console.log(result);
            });
            this.handleDialogClose();
        }else{
            this.handleDialogClose();}
    }

    grabColor(event){
        console.log("start ...");
    }

    toggleModal(){
        if(this.showModal == false){
            this.showModal = true;
        }else{
            this.showModal = false;
        }
    }

    handleDialogClose() {
        this.showModal = false;
    }

    createNewLabel() {
        let el = this.template.querySelector("lightning-input");
        let name = JSON.parse(JSON.stringify(el.value));
        let val = [];
        val = this.globalLabelsList;
        let globList = [];
        let i;
        for(i=0; i<val.length; i++){
            globList.push(val[i]["Name"]);
        }
        if(this.allLabelsList.includes(name)){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error on saving!',
                    message: this.objectApiName+" "+"\""+name+"\" Label Duplicate!",
                    variant: 'error',
                    mode: 'pester'
                }),
            );
        }else if(globList.includes(name)){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error on saving!',
                    message: "Global \""+name+"\" Label Duplicate!",
                    variant: 'error',
                    mode: 'pester'
                }),
            );
        }else{
            let background_Color = this.labelColor;
            let font_Color = this.fontColor;
            if(!background_Color || !font_Color){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Incomplete',
                        message: 'Select a name and color',
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
    }

    saveLabels(){
        let labels = this.template.querySelector(".current");
        let labelsList = '';
        // console.log(labels.children.length);
        for(let i=1; i<labels.children.length; i++){
            labelsList += labels.children[i].textContent+";";
        }
        // console.log("labels ..."+labelsList);
        let recordInput = {fields:{
                Id:  this.recordId,
                Labels__c: labelsList,
            },
        };
        // console.log(recordInput.fields.Labels__c);
        // console.log(recordInput.fields.Id);
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

    // grab(event){
    //     console.log('grab ... set grabbing');
    //     event.target.setAttribute("style", "cursor: grabbing");
    // }
    //
    // grabbing(event){
    //     console.log('grabbing ... set to grab');
    //     event.target.setAttribute("style", "cursor: grab");
    // }

    removeFromAvailableLabels(event){
        console.log('removeFromAvailableLabels');
        event.preventDefault();
        let st = event.dataTransfer.getData("style");
        let label = event.dataTransfer.getData("text");
        // let choice = confirm('Are you sure?\nYou are about to remove > "'+label+'" from available labels for all '+'"'+this.objectApiName+'".');
        // if(choice){
            console.log("Removed ..."+label);
            // let data = event.dataTransfer.getData('text', event.target.firstChild.textContent);
            // let objName = event.dataTransfer.getData("text", event.target.getAttribute("data-object"));
            // console.log(objName);
            let node = document.createElement("div");
            let nodeChild = document.createElement("span");
            nodeChild.classList.add("slds-m-around--xx-small");
            let textnode = document.createTextNode(label);
            nodeChild.setAttribute("style", "margin-top: 3px; margin-right: 6px; margin-left: 6px; margin-bottom: 2px; padding: 2px");
            nodeChild.appendChild(textnode);
            // let buttonNode = document.createElement("button");
            // let icon = document.createElement("span");
            // let iconSymbol = document.createTextNode("+");
            // icon.addEvententListener("click", this.removeFromAvailableLabels);
            // icon.appendChild(iconSymbol);
            // icon.setAttribute("style","display: block; font-family: Arial, sans-serif; font-size: 28px; font-weight: 100");
            // icon.setAttribute("data-target-id", data);
            // icon.setAttribute("data-target-object", objName);
            // buttonNode.classList.add("slds-button", "slds-button_icon", "slds-button_icon", "slds-pill__remove");
            // buttonNode.setAttribute("style", " transform: rotate(45deg); margin-bottom: 8.5px; padding-left: 2px; padding-bottom: 2px");
            // buttonNode.appendChild(icon);
            node.classList.add("slds-pill");
            node.style = st;
            node.setAttribute("draggable", "true");
            node.addEventListener("drag", this.drag_handler);
            node.addEventListener("dragstart", this.dragstart_handler);
            node.addEventListener("dragend", this.dragend_handler);
            node.appendChild(nodeChild);
            // node.appendChild(buttonNode);
            node.setAttribute("data-id", label);
            if(event.currentTarget.classList == 'slds-pill-container slds-listbox slds-listbox_horizontal slds-m-top_small associated' || event.currentTarget.classList == 'slds-pill-container slds-listbox slds-listbox_horizontal global'){
                // console.log('drop zone .... inside');
                // console.log('target removed.... '+'[data-id="'+label+'"]');
                // console.log('target removed.... '+event.currentTarget.classList);
                // console.log('target removed.... '+event.target.classList);
                let el = this.template.querySelector('[data-id="'+label+'"]');
                console.log(el);
                el.remove();
            }
            event.currentTarget.appendChild(node);
        // }else{
        //     console.log("Cancelled ...");
        // }
    }

    drag_handler(ev) {

        // console.log('drag_handler');
        // console.log("drag handler "+ev.target.firstChild.textContent+" "+ev.target.getAttribute("style"));
        // ev.dataTransfer.setData("text", ev.target.firstChild.textContent);
        // ev.dataTransfer.setData("style", ev.target.getAttribute("style"));
    }

    dragstart_handler(ev) {
        ev.dataTransfer.setData("text", ev.target.firstChild.textContent);
        ev.dataTransfer.setData("style", ev.target.getAttribute("style"));
        console.log('drargstart_handler setData >> text >'+ ev.target.firstChild.textContent+' < style >> '+ev.target.getAttribute("style"));
    }

    drop_handler(event) {
        event.preventDefault();
        let style = event.dataTransfer.getData("style");
        let name = event.dataTransfer.getData("text");
        console.log('drop_handler getData>> '+style+' << label >> '+name);
        // let b = event.currentTarget.style.cssText;
        // let data = event.target.className;
        // let computedStyle = window.getComputedStyle(data, null);
        // let s = ev.dataTransfer.getData("style");
        // console.log("dropped pay load ... "+data);
        // let objName = ev.dataTransfer.getData("text", ev.target.getAttribute("data-object"));
        // console.log(objName);
        let node = document.createElement("div");
        node.classList.add("slds-pill");
        node.classList.add("grab");
        node.style = style;
        node.setAttribute("draggable", "true");
        node.addEventListener("drag", this.drag_handler);
        node.addEventListener("dragstart", this.dragstart_handler);
        node.addEventListener("dragend", this.dragend_handler);
        node.addEventListener("mousedown", this.grabbing);
        node.addEventListener("mouseup", this.grab);
        node.setAttribute("data-id", name);
        let nodeChild = document.createElement("span");
        nodeChild.className = "slds-m-around--xx-small";
        let textnode = document.createTextNode(name);
        // let buttonNode = document.createElement("button");
        // let icon = document.createElement("span");
        // let iconSymbol = document.createTextNode("+");
        // icon.addEventListener("click", this.removeFromAvailableLabels);
        // icon.appendChild(iconSymbol);
        // icon.setAttribute("style","display: block; font-family: Arial, sans-serif; font-size: 28px; font-weight: 100");
        // icon.setAttribute("data-target-id", data);
        // icon.setAttribute("data-target-object", objName);
        // buttonNode.classList.add("slds-button", "slds-button_icon", "slds-button_icon", "slds-pill__remove");
        // buttonNode.setAttribute("style", " transform: rotate(45deg); margin-bottom: 8.5px; padding-left: 2px; padding-bottom: 2px");
        // buttonNode.appendChild(icon);
        // nodeChild.setAttribute("style", '"'+style+'"');
        nodeChild.appendChild(textnode);
        node.appendChild(nodeChild);
        // node.appendChild(buttonNode);
        if(event.currentTarget.classList == 'slds-pill-container slds-listbox slds-listbox_horizontal current' || event.currentTarget.classList == 'slds-pill-container slds-listbox slds-listbox_horizontal available'){
            // console.log('target removed.... '+event.currentTarget.classList);
            // console.log('target removed.... '+event.target.classList);
            let el = this.template.querySelector('[data-id="'+name+'"]');
            el.remove();
        }
        event.currentTarget.appendChild(node);
    }

    dragend_handler(ev){
        console.log('dragend_handler');
        ev.preventDefault();
        // console.log('dragend target .... ');
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
        console.log('dragover_handler');
        ev.preventDefault();
        // console.log("dragOver");
    }

    getColor(event){
        event.preventDefault();
        let color = event.target.value;
        this.labelColor = color;
        this.fontColor = this.getContrastYIQ(color);
        this.labelSample = "background-color: "+color+"; color: "+this.fontColor+"; width: 50%; margin-bottom: 6px; text-align: center";
        // el.children[2].style.backgroundColor =  color;
        // el.children[2].style.color = this.fontColor;
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