/**
 * Created by Adelchi on 07/04/2020.
 */

import {LightningElement} from 'lwc';
import update_picklist from '@salesforce/apex/GlobalPicklistEngine.runUpdate';

export default class RunPicklistUpdate extends LightningElement {

    connectedCallback(){
        update_picklist().then(result =>{console.log('updated ...');});
    }
}