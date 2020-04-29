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

    @AuraEnabled(cacheable=true)
    public static Boolean isAdmin(){
        List<AnyLabel__Share> shareList = [SELECT UserOrGroupId, AccessLevel FROM AnyLabel__Share];
        List<String> userIdList = new List<String>();
        for(Integer i=0; i<shareList.size(); i++){
            userIdList.add(shareList[i].UserOrGroupId);
        }
        if(userIdList.contains(UserInfo.getUserId())){
            System.debug(true);
            return false;
        }else{
            System.debug(false);
            return true;
        }
    }

    @AuraEnabled
    public static List<AnyLabel__c> getGlobalLabels(){
        List<AnyLabel__c> al = [SELECT Font_Color__c, Background_Color__c, Assignee__c, Name FROM AnyLabel__c];
        system.debug(al);
        return al;
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

    @AuraEnabled
    public static void NewLabelMultiAssign(List<String> objectNames, String fc, String bc, String n){
        system.debug('saving from apex ... !');
        String objs = '';
        for(Integer i=0; i<objectNames.size(); i++){
            objs += objectNames[i]+';';
        }
        try {
            AnyLabel__c a = new AnyLabel__c(
                    Assignee__c = objs,
                    Font_Color__c = fc,
                    Background_Color__c = bc,
                    Name = n
            );
            insert a;
        } catch(DmlException e)
        {
            system.debug(e.getMessage());
        }
    }

//    @AuraEnabled
//    public static void removeLabelsFromObject(List<String> labelsList, String recordId){
//        Id recId = recordId;
//        String obj = recId.getSobjectType().getDescribe().localName;
//        String query = 'SELECT Name FROM AnyLabel__c WHERE Assignee__c INCLUDES (\''+obj+'\') ORDER BY Name ASC';
//    }

    @AuraEnabled(cacheable=true)
    public static List<AnyLabel__c> getSObjectLabelsListAll(String recordId){
        Id recId = recordId;
        String obj = recId.getSobjectType().getDescribe().localName;
        List<AnyLabel__c> values = new List<AnyLabel__c>();
        String query = 'SELECT Font_Color__c, Background_Color__c, Name FROM AnyLabel__c WHERE Assignee__c INCLUDES (\''+obj+'\') ORDER BY Name ASC';
                values = Database.query(query);
        return  values;
    }

    @AuraEnabled(cacheable=true)
    public static List<AnyLabel__c> getAssignedLabelsList(String recordId){
        Id recId = recordId;
        String obj = recId.getSobjectType().getDescribe().localName;
        String query = 'SELECT Labels__c FROM '+obj+' WHERE Id = \''+recordId+'\'';
        List<SObject> record = Database.query(query);
        system.debug('Number of record '+recId+' assigned labels list .. '+record.size());
        List<AnyLabel__c> anyLabelsList = new List<AnyLabel__c>();
        List<String> labelsList = new List<String>();
        if(record[0].get('labels__c')!= ''&& record[0].get('labels__c') != null){
            String labelsListString = (String) record[0].get('Labels__c');
            labelsList = labelsListString.split(';');
        }
        anyLabelsList = [SELECT Assignee__c, Font_Color__c, Background_Color__c, Name FROM AnyLabel__c WHERE Name IN :labelsList];
        system.debug(anyLabelsList);
        return anyLabelsList;
    }

    @AuraEnabled(Cacheable=true)
    public static List<String> getSObjectList(){
        system.debug(GlobalPicklistEngine.getSObjectList());
        return(GlobalPicklistEngine.getSObjectList());
    }
}