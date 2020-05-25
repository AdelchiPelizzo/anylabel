/*
 * Copyright (c) 2020.  adelForce (Adelchi Ltd)
 *  All Rights Reserved
 *  NOTICE:  All information contained herein is, and remains the property of adelForce (Adelchi Ltd) .
 *  The intellectual and technical concepts contained are protected by trade secret or copyright law.
 *  Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained from  adelForce (Adelchi Ltd).
 */

/**
 * Created by Adelchi on 13/04/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


public with sharing class UpdateLabelsList {
    /**
 * Purpose : (Write a succinct description of this method here.)
 * @param (parameter name) (Describe the first parameter here)
 * @param (parameter name) (Do the same for each additional parameter)
 * @return (description of the return value)
 */

    @InvocableMethod
    public static void createTrigger(List<String> setup){
        system.debug('I am running ...'+setup);
        String json = '{ "Name" : "UpdateLabelsTrigger", "TableEnumOrId" : "'+setup[0]+'", "Body" : "trigger UpdateLabelsTrigger on '+setup[0]+' (before update) {}"}'; // JSON format to create trigger
        system.debug(json);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getOrgDomainUrl().toExternalForm()+'/services/data/v47.0/sobjects/ApexTrigger');
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        req.setBody(json);
        Http httpReq = new Http();
        HttpResponse res  = httpReq.send(req);
        System.debug(res.getBody());
    }
}