/**
 * Created by Adelchi on 24/03/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


public with sharing class AnyLabelCtrl {
    /**
 * Purpose : (Write a succinct description of this method here.)
 * @param (parameter name) (Describe the first parameter here)
 * @param (parameter name) (Do the same for each additional parameter)
 * @return (description of the return value)
 */

    public class Items {
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String name {get; set;}
        @AuraEnabled
        public String id {get; set;}
        @AuraEnabled
        public Boolean assigned {get; set;}
        @AuraEnabled
        public String color {get; set;}

        public Items(string label, string name, String id, Boolean check, String color) {
            this.label = label;
            this.name = name;
            this.id = id;
            this.assigned = check;
            this.color = color;
        }
    }

    @AuraEnabled(cacheable=true)
    public static Boolean isAdmin(){
        List<AnyLabel__Share> shareList = [SELECT UserOrGroupId, AccessLevel FROM AnyLabel__Share];
        List<String> userIdList = new List<String>();
        for(Integer i=0; i<shareList.size(); i++){
            userIdList.add(shareList[i].UserOrGroupId);
        }
        if(userIdList.contains(UserInfo.getUserId())){
            System.debug(true);
            return true;
        }else{
            System.debug(false);
            return false;
        }
    }

    @AuraEnabled(cacheable=true)
    public static void NewLabel(String recordId, String fc, String bc, String n){
        Id recId = recordId;
        String obj = recId.getSobjectType().getDescribe().localName;
        try {
            AnyLabel__c a = new AnyLabel__c(
                    Assignee__c = obj,
                    Font_Color__c = fc,
                    Background_Color__c = bc,
                    Name = n);
                    insert a;
        } catch(DmlException e)
        {
            system.debug(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getSObjectLabelsListAll(String recordId){
        Id recId = recordId;
        String obj = recId.getSobjectType().getDescribe().localName;
        Boolean gotLabel = false;
        List<String> values = new List<String>();
        String query = 'SELECT Name FROM AnyLabel__c WHERE Assignee__c INCLUDES (\''+obj+'\') ORDER BY Name ASC';
        DescribeFieldResult picklist = AnyLabel__c.Assignee__c.getDescribe();
        List<Schema.PicklistEntry> entries = picklist.getPicklistValues();
        for(Integer i=0; i<entries.size(); i++){
            PicklistEntry pickListValue = entries[i];
            if(pickListValue.value == obj){
                gotLabel = true;
                List<AnyLabel__c> v = Database.query(query);
                for(AnyLabel__c s : v){
                    values.add(s.Name);
                }
            }
        }
        system.debug(values);
        return values;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getAssignedLabelsList(String recordId){
        Id recId = recordId;
        String obj = recId.getSobjectType().getDescribe().localName;
//        SObjectType objType = Schema.getGlobalDescribe().get(obj);
//        Map<String,Schema.SObjectField> fields = objType.getDescribe().fields.getMap();
        String query = 'SELECT Labels__c FROM '+obj+' WHERE Id = \''+recordId+'\'';
        List<SObject> record = Database.query(query);
        system.debug(record.size());
        List<String> labelsList = new List<String>();
        if(record[0].get('labels__c')!= ''&& record[0].get('labels__c') != null){
            String labelsListString = (String) record[0].get('Labels__c');
            labelsList = labelsListString.split(';');
        }
        system.debug(labelsList);
        return labelsList;
    }

//    @AuraEnabled(cacheable=true)
//    public static void updateGlobalPicklist(){
//        List<String> SObjectList = new List<String>();
//        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
//            String name = objTyp.getDescribe().getName();
//            if(!objTyp.getDescribe().isCreateable())
//                continue;
//            if(!objTyp.getDescribe().isCustom() && objTyp.getDescribe().getRecordTypeInfos().size() > 0 && objTyp.getDescribe().isAccessible()
//                    && name != 'DuplicateRecordSet'
//                    && name != 'PartyConsent'
//                    && name != 'ContentVersion'
//                    && name != 'ContentVersion'
//                    && name != 'SearchPromotionRule'
//                    && name != 'Pricebook2'
//                    && name != 'Individual'
//                    && name != 'Event'
//                    && name != 'Task'
//                    && name != 'ContentVersion'
//                    && name != 'Product2'
//                    && name != 'Macro'
//                    && name != 'MacroInstruction'
//                    && name != 'Address'
//                    && name != 'Location'
//                    && name != 'AssociatedLocation'
//                    && name != 'CalendarView'
//                    && name != 'QuickText'
//                    && name != 'SOSSession'
//                    && name != 'DuplicateRecordItem'
//                    && name != 'AssetRelationship'
//                    && name != 'ListEmail'
//                    && name != 'ListEmailRecipientSource'
//                    && name != 'RecordAction'
//                    && name != 'OrgDeleteRequest'
//                    && name != 'FlowRecordRelation'
//                    && name != 'ContactRequest'
//                    && name != 'ContactPointEmail'
//                    && name != 'ContactPointPhone'
//                    && name != 'ListEmailIndividualRecipient'
//                    && name != 'UserEmailPreferredPerson'
//                    && name != 'ConsumptionSchedule'
//                    && name != 'ConsumptionRate'
//                    && name != 'ProductConsumptionSchedule'
//                    && name != 'AppAnalyticsQueryRequest'
//                    && name != 'ContactPointConsent'
//                    && name != 'ContactPointTypeConsent'
//                    && name != 'DataUseLegalBasis'
//                    && name != 'DataUsePurpose'
//                    && name != 'ExpressionFilter'
//                    && name != 'ExpressionFilterCriteria'
//                    && name != 'Image'
//                    && name != 'Recommendation'
//                    && name != 'AuthorizationForm'
//                    && name != 'AuthorizationFormConsent'
//                    && name != 'AuthorizationFormDataUse'
//                    && name != 'AuthorizationFormText'
//                    && name != 'PromptAction'
//                    && name != 'OrgMetric'
//                    && name != 'OrgMetricScanResult'
//                    && name != 'OrgMetricScanSummary'
//                    && name != 'RevenueElement'
//                    && name != 'CommSubscription'
//                    && name != 'CommSubscriptionChannelType'
//                    && name != 'CommSubscriptionConsent'
//                    && name != 'CommSubscriptionTiming'
//                    && name != 'EngagementChannelType'
//                    ){
//                SobjectList.add(name);
//                System.debug( 'Name : ' + name);
//            } else if(objTyp.getDescribe().isCustom() && name != 'AnyLabel__c'){
//                SobjectList.add(name);
//                System.debug( 'Name : ' + name);
//            }
//        }
//        System.debug( SObjectList.size());


//        DescribeFieldResult pickList = SObjectType.AnyLabel__c.fields.Assignee__c;
//        List<PicklistEntry> pickListEntries = pickList.getPicklistValues();
//
//        List<String> pickListValuesActive   = new List<String>();
//        List<String> pickListValuesInactive = new List<String>();
//
//        for(Schema.PicklistEntry pickListVal : pickListEntries) {
//            if(pickListVal.isActive()) {
//                pickListValuesActive.add(pickListVal.getLabel());
//            } else {
//                pickListValuesInactive.add(pickListVal.getLabel());
//            }
//        }
//        system.debug(pickListValuesActive+'  '+pickListValuesInactive);

//        List<AnyLabel__c> anyLabelList = new List<AnyLabel__c>();
//        anyLabelList = [SELECT Assignee__c FROM AnyLabel__c];
//        system.debug(anyLabelList.size());
//        for(AnyLabel__c a : anyLabelList){
//            a.Assignee__c = '';
//            a.Assignee__c = String.join(SObjectList,';');
//        }
//        update anyLabelList;





//        HttpRequest reqGET = new HttpRequest();
//        reqGET.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
//        reqGET.setHeader('Content-Type', 'application/json');
//        reqGET.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v48.0/tooling/query/?q=SELECT+Id,FullName+FROM+GlobalValueSet');
//        reqGET.setMethod('GET');
//        Http httpReqGET = new Http();
//        HttpResponse resGET  = httpReqGET.send(reqGET);
//        JSONParser parser = JSON.createParser(resGET.getBody());
//        String globalPicklistName = '';
//        String globalPicklistId = '';
//        while (parser.nextToken() != null) {
//            if (parser.getText() == 'FullName') {
//                parser.nextToken();
//                globalPicklistName = parser.getText();
//            }
//            if(globalPicklistName == 'SObject'){
//                parser.nextToken();
//                if(parser.getText() == 'Id'){
//                    parser.nextToken();
//                    globalPicklistId = parser.getText();
//                    System.debug(globalPicklistId);
//                }
//            }
//        }


//        String fieldDef = '{"Metadata": {"customValue": [';
//
////        for(Integer i=0; i<SObjectList.size(); i++){
//
////        }
////
////        for(String s : SObjectList){
//            fieldDef += '{"color": null,"default": false,"description": null,"isActive": true,"label": "'+SObjectList[0]+'",urls": null,"valueName": "'+SObjectList[0]+'"}';
////        }
//
//        fieldDef += '],"description": null,"masterLabel": "SObject","sorted": false,"urls": null},"FullName": "SObject"}';
//
////        String fieldDef = '{"Metadata": {"customValue": [{"color": null,"default": false,"description": null,"isActive": true,"label": "Opportunity2","urls": null,"valueName": "Opportunity2"}],"description": null,"masterLabel": "SObject","sorted": false,"urls": null},"FullName": "SObject"}';
//        HttpRequest req = new HttpRequest();
//        system.debug(fieldDef);
//        req.setBody(fieldDef);
//        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
//        req.setHeader('Content-Type', 'application/json');
//        system.debug(globalPicklistId);
//        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v47.0/tooling/sobjects/GlobalValueSet/'+globalPicklistId+'?_HttpMethod=PATCH');//replace id with your GlobalPicklist Id**
//        req.setMethod('POST');
//        req.setHeader('X-HTTP-Method-Override','PATCH');
//        Http httpreq = new Http();
//        HttpResponse res  = httpreq.send(req);
//        system.debug(res.getBody());
    }

//}



//    }

//    public static void createField()
//    {
//        MetadataService.MetadataPort service = createService();
//        MetadataService.CustomField customField = new MetadataService.CustomField();
//        customField.fullName = 'Test__c.TestField__c';
//        customField.label = 'Test Field';
//        customField.type_x = 'Text';
//        customField.length = 42;
//        List<MetadataService.SaveResult> results =
//                service.createMetadata(
//                        new MetadataService.Metadata[] { customField });
//        handleSaveResults(results[0]);
//    }
//
//    public static MetadataService.MetadataPort createService()
//    {
//        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
//        service.SessionHeader = new MetadataService.SessionHeader_element();
//        service.SessionHeader.sessionId = UserInfo.getSessionId();
//        return service;
//    }
//
//    Id sampleid = 'a003z00000svdVjAAI';
//    System.debug('object is '+ sampleid.getsobjecttype().getDescribe().localName);
//
//    public static string createField(string objectAPIName, string fieldAPIName, string fieldLabel, string fieldDescription) {
//        HttpRequest request = new HttpRequest();
//        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
//        request.setHeader('Content-Type', 'application/json');
//        request.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v41.0/tooling/sobjects/CustomField/');
//        request.setMethod('POST');
//
//        request.setBody('{"Metadata" : {"MasterDetail" : "Text","description" : "'+fieldDescription+'", "inlineHelpText" : "","precision" : null,"label" : "'+fieldLabel+'","length" : 255,"required" : false}, "FullName" : "'+objectAPIName+'.'+fieldAPIName+'"}');
//
//        Http http = new Http();
//        HTTPResponse res = http.send(request);
//        return res.getBody();
//    }
//
//    createField('AnyLabel__c', 'MDtest__c', 'MDtest', 'test');
//
//
//
//
//
//    String fieldDef = '{"Metadata": {"customValue": [{"color": null,"default": false,"description": null,"isActive": null,"label": "Opportunity2","urls": null,"valueName": "Opportunity2"}],"description": null,"masterLabel": "SObject","sorted": false,"urls": null},"FullName": "SObject"}';
//    HttpRequest req = new HttpRequest();
//    req.setBody(fieldDef);
//req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
//req.setHeader('Content-Type', 'application/json');
//req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v47.0/tooling/sobjects/GlobalValueSet/0Nt3z000000g8BO?_HttpMethod=PATCH');//replace id with your GlobalPicklist Id**
//req.setMethod('POST');
//req.setHeader('X-HTTP-Method-Override','PATCH');
//Http httpreq = new Http();
//HttpResponse res  = httpreq.send(req);
//system.debug(res.getBody());
//
//
//
//
//DescribeFieldResult picklistUsingGlobal = SObjectType.AnyLabel__c.fields.Assignee__c;
//List<PicklistEntry> entries = picklistUsingGlobal.getPicklistValues();
//system.debug(entries);

//}