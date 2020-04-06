/**
 * Created by Adelchi on 06/04/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


public with sharing class GlobalPicklistEngine {
    /**
 * Purpose : (Write a succinct description of this method here.)
 * @param (parameter name) (Describe the first parameter here)
 * @param (parameter name) (Do the same for each additional parameter)
 * @return (description of the return value)
 */

    @AuraEnabled(cacheable=true)
    public static List<String> getSObjectList(){
        List<String> SObjectList = new List<String>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
            String name = objTyp.getDescribe().getName();
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
            } else if(objTyp.getDescribe().isCustom() && name != 'AnyLabel__c'){
                SobjectList.add(name);
            }
        }
        system.debug(SObjectList);
        return SObjectList;
    }


    public static String getGlobalPicklistId(String globalPicklistName){
        HttpRequest reqGET = new HttpRequest();
        reqGET.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        reqGET.setHeader('Content-Type', 'application/json');
        reqGET.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v48.0/tooling/query/?q=SELECT+Id,FullName+FROM+GlobalValueSet');
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
                    System.debug(globalPicklistId);
                }
            }
        }
        return globalPicklistId;
    }

    public static void updateGlobalPicklist(List<String> SObjectList, String globalPicklistId){
        for(Integer i=0; i<SObjectList.size(); i++){
            String s = SObjectList[i];
            String fieldDef = '{"Metadata":{"customValue":[{"color":null,"default":false,"description":null,"isActive":true,"label":"'+s+'","urls":null,"valueName":"'+s+'"}],"description":null,"masterLabel":"SObject","sorted":false,"urls":null},"FullName":"SObject"}';
//        String fieldDef = '{"Metadata": {"customValue": [';
//        fieldDef += '{"color": null,"default": false,"description": null,"isActive": true,"label": "'+s+'",urls": null,"valueName": "'+s+'"}';
//        fieldDef += '],"description": null,"masterLabel": "SObject","sorted": false,"urls": null},"FullName": "SObject"}';

//        String fieldDef = '{"Metadata": {"customValue": [{"color": null,"default": false,"description": null,"isActive": true,"label": "Opportunity2","urls": null,"valueName": "Opportunity2"}],"description": null,"masterLabel": "SObject","sorted": false,"urls": null},"FullName": "SObject"}';
            HttpRequest req = new HttpRequest();
//            system.debug(fieldDef);
            req.setBody(fieldDef);
            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
            req.setHeader('Content-Type', 'application/json');
            req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v47.0/tooling/sobjects/GlobalValueSet/'+globalPicklistId+'?_HttpMethod=PATCH');//replace id with your GlobalPicklist Id**
            req.setMethod('POST');
            req.setHeader('X-HTTP-Method-Override','PATCH');
            Http httpReq = new Http();
            HttpResponse res  = httpReq.send(req);
//            system.debug(res.getBody());

        }
    }
}