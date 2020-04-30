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
        system.debug(al.size());
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

    @AuraEnabled
    public static void removeLabelsFromObject(List<String> labelsToRemoveName, List<String> labelsToAddName, String recordId){
        Id recId = recordId;
        String obj = recId.getSobjectType().getDescribe().localName;
        String labR = '';
        String labA = '';
        String queryR;
        String queryA;
        for(Integer i=1; i<labelsToRemoveName.size(); i++){
            if(i!=(labelsToRemoveName.size()-1)){
                labR += '\''+labelsToRemoveName[i]+'\',';
            }else{
                labR += '\''+labelsToRemoveName[i]+'\'';
            }
        }
        for(Integer i=1; i<labelsToAddName.size(); i++){
            if(i!=(labelsToAddName.size()-1)){
                labA += '\''+labelsToAddName[i]+'\',';
            }else{
                labA += '\''+labelsToAddName[i]+'\'';
            }
        }
        List<AnyLabel__c> alR = new List<AnyLabel__c>();
        if(labR!=''){
            queryR = 'SELECT Id, Assignee__c FROM AnyLabel__c WHERE Name IN ('+labR+')';
            alR = Database.query(queryR);
        }
        system.debug(queryR);
        List<AnyLabel__c> alA = new List<AnyLabel__c>();
        if(labA!=''){
            queryA = 'SELECT Id, Assignee__c FROM AnyLabel__c WHERE Name IN ('+labA+')';
            alA = Database.query(queryA);
        }
        system.debug(queryA);
        system.debug(alA.size()+'<>'+alR.size());
        
        List<AnyLabel__c> alToAdd = new List<AnyLabel__c>();
//        String target = obj+';';
        String addObj = ';'+obj;
        for(Integer i=0; i<alA.size(); i++){
            if(!alA[i].Assignee__c.contains(obj)){
                system.debug(alA[i].Assignee__c+' '+addObj);
                alA[i].Assignee__c = alA[i].Assignee__c+addObj;
                alToAdd.add(alA[i]);
            }
        }
        system.debug(alToAdd.size());
        update alToAdd;
        List<AnyLabel__c> alToRem = new List<AnyLabel__c>();
        String targetR = obj+';';
        String targetR2 = ';'+obj;
        String replace = '';
        String assignee;
        for(Integer i=0; i<alR.size(); i++){
            system.debug(alR[i].Assignee__c+' '+obj);
            if(alR[i].Assignee__c.contains(targetR)){
                assignee = alR[i].Assignee__c.replace(targetR, replace);
                alR[i].Assignee__c = assignee;
                alToRem.add(alR[i]);
            }else if(alR[i].Assignee__c.contains(targetR2)){
                assignee = alR[i].Assignee__c.replace(targetR2, replace);
                alR[i].Assignee__c = assignee;
                alToRem.add(alR[i]);
            }else if(alR[i].Assignee__c.contains(obj)){
                assignee = alR[i].Assignee__c.replace(obj, replace);
                alR[i].Assignee__c = assignee;
                alToRem.add(alR[i]);
            }
        }
        system.debug(alToRem.size());
        update alToRem;
    }

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
        system.debug('getting assigned labels to record ...');
        Id recId = recordId;
        String obj = recId.getSobjectType().getDescribe().localName;
        system.debug(obj);
        String query = 'SELECT Labels__c FROM '+obj+' WHERE Id = \''+recordId+'\'';
        List<SObject> record = Database.query(query);
        system.debug('Number of record '+recId+' assigned labels list .. '+record.size());
        List<AnyLabel__c> anyLabelsList = new List<AnyLabel__c>();
        List<AnyLabel__c> anyLabelsListToReturn = new List<AnyLabel__c>();
        List<String> labelsList = new List<String>();
        if(record[0].get('labels__c')!= ''&& record[0].get('labels__c') != null){
            String labelsListString = (String) record[0].get('Labels__c');
            labelsList = labelsListString.split(';');
        }else{
            system.debug(record[0].get('Labels__c'));
            return null;
        }
        anyLabelsList = [SELECT Assignee__c, Font_Color__c, Background_Color__c, Name FROM AnyLabel__c WHERE Name IN :labelsList];
        for(Integer i=0; i<anyLabelsList.size(); i++){
            if(anyLabelsList[i].Assignee__c.contains(obj)){
                anyLabelsListToReturn.add(anyLabelsList[i]);
            }else{system.debug('no labels to return for this record');}
        }
        if(anyLabelsListToReturn.size()==0){
            return null;
        }else{
            return anyLabelsListToReturn;
        }
    }

    @AuraEnabled(Cacheable=true)
    public static List<String> getSObjectList(){
        system.debug(GlobalPicklistEngine.getSObjectList());
        return(GlobalPicklistEngine.getSObjectList());
    }
}