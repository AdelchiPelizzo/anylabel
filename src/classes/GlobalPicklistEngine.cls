/*
 * Copyright (c) 2020.  adelForce (Adelchi Ltd)
 *  All Rights Reserved
 *  NOTICE:  All information contained herein is, and remains the property of adelForce (Adelchi Ltd) .
 *  The intellectual and technical concepts contained are protected by trade secret or copyright law.
 *  Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained from  adelForce (Adelchi Ltd).
 */
/**
 * Created by Adelchi on 06/04/2020.
 */


global with sharing class GlobalPicklistEngine {
    /**
 * Purpose : (Write a succinct description of this method here.)
 * @param (parameter name) (Describe the first parameter here)
 * @return (description of the return value)
 */
    private final AnyLabel__c a;

    public static String SObjectSelected {get{System.debug('selected');return SobjectSelected;} set;}

    public static void setLabelsField(){
        if(SObjectSelected!=null){
            createCustomFieldLabels(SObjectSelected);
        }
    }

    public static void getSObjectSelected(){
        SObjectSelected = SObjectSelected;
    }

    public static List<SelectOption> SelOptObj = new List<SelectOption>();

    global static List<String> getSObjectListForFieldEnablement(){
        List<String> SObjectList = new List<String>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().values()){
            String name = objTyp.getDescribe().getName();
            Boolean isActivated = objTyp.getDescribe().fields.getMap().keySet().contains('Labels__c');
            if(!objTyp.getDescribe().isCreateable())
                continue;
            if(!objTyp.getDescribe().isCustom() && objTyp.getDescribe().getRecordTypeInfos().size() > 0 && objTyp.getDescribe().isAccessible()
                    && name != 'DuplicateRecordSet'
                    && name != 'PartyConsent'
                    && name != 'ContentVersion'
                    && name != 'ContentVersion'
                    && name != 'SearchPromotionRule'
                    && name != 'Pricebook2'
                    && name != 'Individual'
                    && name != 'Event'
                    && name != 'Task'
                    && name != 'ContentVersion'
                    && name != 'Product2'
                    && name != 'Macro'
                    && name != 'MacroInstruction'
                    && name != 'Address'
                    && name != 'Location'
                    && name != 'AssociatedLocation'
                    && name != 'CalendarView'
                    && name != 'QuickText'
                    && name != 'SOSSession'
                    && name != 'DuplicateRecordItem'
                    && name != 'AssetRelationship'
                    && name != 'ListEmail'
                    && name != 'ListEmailRecipientSource'
                    && name != 'RecordAction'
                    && name != 'OrgDeleteRequest'
                    && name != 'FlowRecordRelation'
                    && name != 'ContactRequest'
                    && name != 'ContactPointEmail'
                    && name != 'ContactPointPhone'
                    && name != 'ListEmailIndividualRecipient'
                    && name != 'UserEmailPreferredPerson'
                    && name != 'ConsumptionSchedule'
                    && name != 'ConsumptionRate'
                    && name != 'ProductConsumptionSchedule'
                    && name != 'AppAnalyticsQueryRequest'
                    && name != 'ContactPointConsent'
                    && name != 'ContactPointTypeConsent'
                    && name != 'DataUseLegalBasis'
                    && name != 'DataUsePurpose'
                    && name != 'ExpressionFilter'
                    && name != 'ExpressionFilterCriteria'
                    && name != 'Image'
                    && name != 'Recommendation'
                    && name != 'AuthorizationForm'
                    && name != 'AuthorizationFormConsent'
                    && name != 'AuthorizationFormDataUse'
                    && name != 'AuthorizationFormText'
                    && name != 'PromptAction'
                    && name != 'OrgMetric'
                    && name != 'OrgMetricScanResult'
                    && name != 'OrgMetricScanSummary'
                    && name != 'RevenueElement'
                    && name != 'CommSubscription'
                    && name != 'CommSubscriptionChannelType'
                    && name != 'CommSubscriptionConsent'
                    && name != 'CommSubscriptionTiming'
                    && name != 'EngagementChannelType'
                    ){
                SobjectList.add(name);
            } else if(objTyp.getDescribe().isCustom() && name != 'AnyLabel__c' && !isActivated){
                SobjectList.add(name);
            }
        }
        return SObjectList;
    }

    public static List<SelectOption> getSelOptObj(){
        List<String> AllObjStrLst = getSObjectListForFieldEnablement();

        SelOptObj.add(new SelectOption('',''));
        for(String s : AllObjStrLst){
            if(!AnalyzeObject.hasSObjectField('Labels__c', s)){
                SelOptObj.add(new SelectOption(s,s));
            }
        }
        return SelOptObj;
    }

    @AuraEnabled(cacheable=true)
    public static void runUpdate(){
        updateGlobalPicklist(getSObjectList(), getGlobalPicklistId('SObject'));
    }

    public GlobalPicklistEngine(ApexPages.StandardController stdController) {
        this.a = (AnyLabel__c)stdController.getRecord();
    }

    public static Map<String, Schema.DescribeFieldResult> getFieldMetaData(
            Schema.DescribeSObjectResult dsor, Set<String> fields) {
        // the map to be returned with the final data
        Map<String,Schema.DescribeFieldResult> finalMap =
                new Map<String, Schema.DescribeFieldResult>();
        // map of all fields in the object
        Map<String, Schema.SObjectField> objectFields = dsor.fields.getMap();

        // iterate over the requested fields and get the describe info for each one.
        // add it to a map with field name as key
        for(String field : fields){
            // skip fields that are not part of the object
            if (objectFields.containsKey(field)) {
                Schema.DescribeFieldResult dr = objectFields.get(field).getDescribe();
                // add the results to the map to be returned
                finalMap.put(field, dr);
            }
        }
        return finalMap;
    }

    @AuraEnabled(cacheable=true)
    global static List<String> getSObjectList(){
        List<String> SObjectList = new List<String>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().values()){
            Schema.DescribeSObjectResult sor = objTyp.getDescribe();
            Set<String> s = new Set<String>{'Labels__c'};
            Map<String, Schema.DescribeFieldResult> mapd =  getFieldMetaData(sor, s);
            String name = objTyp.getDescribe().getName();
            if(mapd.keySet().contains('Labels__c')){
                if(!objTyp.getDescribe().isCreateable())
                    continue;
                if(!objTyp.getDescribe().isCustom()  && objTyp.getDescribe().getRecordTypeInfos().size() > 0 && objTyp.getDescribe().isAccessible()
                        && name != 'DuplicateRecordSet'
                        && name != 'PartyConsent'
                        && name != 'ContentVersion'
                        && name != 'ContentVersion'
                        && name != 'SearchPromotionRule'
                        && name != 'Pricebook2'
                        && name != 'Individual'
                        && name != 'Event'
                        && name != 'Task'
                        && name != 'ContentVersion'
                        && name != 'Product2'
                        && name != 'Macro'
                        && name != 'MacroInstruction'
                        && name != 'Address'
                        && name != 'Location'
                        && name != 'AssociatedLocation'
                        && name != 'CalendarView'
                        && name != 'QuickText'
                        && name != 'SOSSession'
                        && name != 'DuplicateRecordItem'
                        && name != 'AssetRelationship'
                        && name != 'ListEmail'
                        && name != 'ListEmailRecipientSource'
                        && name != 'RecordAction'
                        && name != 'OrgDeleteRequest'
                        && name != 'FlowRecordRelation'
                        && name != 'ContactRequest'
                        && name != 'ContactPointEmail'
                        && name != 'ContactPointPhone'
                        && name != 'ListEmailIndividualRecipient'
                        && name != 'UserEmailPreferredPerson'
                        && name != 'ConsumptionSchedule'
                        && name != 'ConsumptionRate'
                        && name != 'ProductConsumptionSchedule'
                        && name != 'AppAnalyticsQueryRequest'
                        && name != 'ContactPointConsent'
                        && name != 'ContactPointTypeConsent'
                        && name != 'DataUseLegalBasis'
                        && name != 'DataUsePurpose'
                        && name != 'ExpressionFilter'
                        && name != 'ExpressionFilterCriteria'
                        && name != 'Image'
                        && name != 'Recommendation'
                        && name != 'AuthorizationForm'
                        && name != 'AuthorizationFormConsent'
                        && name != 'AuthorizationFormDataUse'
                        && name != 'AuthorizationFormText'
                        && name != 'PromptAction'
                        && name != 'OrgMetric'
                        && name != 'OrgMetricScanResult'
                        && name != 'OrgMetricScanSummary'
                        && name != 'RevenueElement'
                        && name != 'CommSubscription'
                        && name != 'CommSubscriptionChannelType'
                        && name != 'CommSubscriptionConsent'
                        && name != 'CommSubscriptionTiming'
                        && name != 'EngagementChannelType'
                        ){
                    SobjectList.add(name);
                } else if(objTyp.getDescribe().isCustom() && name != 'AnyLabel__c'){
                    SobjectList.add(name);
                }
            }

        }
        return SObjectList;
    }


    public static String getGlobalPicklistId(String globalPicklistName){
        HttpRequest reqGET = new HttpRequest();
        reqGET.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        reqGET.setHeader('Content-Type', 'application/json');
        reqGET.setEndpoint(URL.getOrgDomainUrl().toExternalForm()+'/services/data/v48.0/tooling/query/?q=SELECT+Id,FullName+FROM+GlobalValueSet');
        reqGET.setMethod('GET');
        Http httpReqGET = new Http();
        HttpResponse resGET  = httpReqGET.send(reqGET);
        JSONParser parser = JSON.createParser(resGET.getBody());
        String globalPicklistNameStoring = '';
        String globalPicklistId = '';
        while (parser.nextToken() != null) {
            if (parser.getText() == globalPicklistName) {
                parser.nextToken();
                globalPicklistNameStoring = parser.getText();
            }
            if(globalPicklistName == globalPicklistName){
                parser.nextToken();
                if(parser.getText() == 'Id'){
                    parser.nextToken();
                    globalPicklistId = parser.getText();
                }
            }
        }
        return globalPicklistId;
    }

    public static void createCustomFieldLabels(String SObj){
        System.debug(SObj);
        HttpRequest reqPOST = new HttpRequest();
        reqPOST.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        reqPOST.setHeader('Content-Type', 'application/json');
        reqPOST.setEndpoint(URL.getOrgDomainUrl().toExternalForm()+'/services/data/v48.0/tooling/sobjects/CustomField/');
        reqPOST.setMethod('POST');
        reqPOST.setBody('{"FullName": "'+SObj+'.Labels__c","Metadata": {"label": "Labels","description": "AnyLabel data", "required": false, "visibleLines" : 2, "externalId": false, "type": "LongTextArea", "length": 100000 }}');
        System.debug('{"FullName": "'+SObj+'.Labels__c","Metadata": {"label": "Labels","description": "AnyLabel data", "required": false, "visibleLines" : 2, "externalId": false, "type": "LongTextArea", "length": 100000 }}');
        Http httpReqPOST = new Http();
        SObject so = Schema.getGlobalDescribe().get(SObj).newSObject();
        if(!so.getSobjectType().getDescribe().fields.getMap().containsKey('Labels__c')){
            HttpResponse resPOST  = httpReqPOST.send(reqPOST);
            System.debug(resPOST);
        }
    }

    @AuraEnabled
    public static void updateGlobalPicklist(List<String> SObjectList, String globalPicklistId){
        Integer size = SObjectList.size();
        String fieldDef = '{"Metadata": {"customValue": [';
        for(Integer i=0; i<SObjectList.size(); i++){
            String s = SObjectList[i];
            fieldDef += '{"color":null,"default":false,"description":null,"isActive":true,"label":"'+s+'","urls":null,"valueName":"'+s+'"}';
            if(i<(size-1)){
                fieldDef += ',';
            }
        }
        fieldDef += '],"description": null,"masterLabel": "SObject","sorted": false,"urls": null},"FullName": "SObject"}';
        HttpRequest req = new HttpRequest();
        req.setBody(fieldDef);
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(URL.getOrgDomainUrl().toExternalForm()+'/services/data/v47.0/tooling/sobjects/GlobalValueSet/'+globalPicklistId+'?_HttpMethod=PATCH');//replace id with your GlobalPicklist Id**
        req.setMethod('POST');
        Http httpReq = new Http();
        HttpResponse res  = httpReq.send(req);
    }
}