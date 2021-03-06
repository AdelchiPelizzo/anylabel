/*
 * Copyright (c) 2020.  adelForce (Adelchi Ltd)
 *  All Rights Reserved
 *  NOTICE:  All information contained herein is, and remains the property of adelForce (Adelchi Ltd) .
 *  The intellectual and technical concepts contained are protected by trade secret or copyright law.
 *  Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained from  adelForce (Adelchi Ltd).
 */

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