/*
 *  Copyright (c) 2020.  adelForce (Adelchi Ltd)
 *  All Rights Reserved
 *  NOTICE:  All information contained herein is, and remains the property of adelForce (Adelchi Ltd) .
 *  The intellectual and technical concepts contained are protected by trade secret or copyright law.
 *  Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained from  adelForce (Adelchi Ltd).
 */

/**
 * Created by Adelchi on 14/04/2020.
 * Purpose : (Controller for TriggerEngine.page and RemoveRule.page.)
 */


public with sharing class AnyLabelAutomation {

    public String objectName {get; set;}
    public String fieldName {get; set;}
    public List<SelectOption> fieldNames {get; set;}
    public String[] labelName {get; set;}
    public String conditionName {get; set;}
    public String InputValue {get; set;}
    public String triggerId {get; set;}
    public List<SelectOption> ConditionNames;
    public String triggerLink {get{
        return Url.getSalesforceBaseUrl().toExternalForm()+'/';
    }set;}
    private final AnyLabel__c a;
    ApexPages.StandardController stdCtrl;

    public AnyLabelAutomation(){}
    public List<triggerWrapper> triggerList = new List<triggerWrapper>();
    public List<ApexTrigger> selectedTriggers = new List<ApexTrigger>();

    public List<triggerWrapper> getTriggers()
    {
        for(ApexTrigger a : [SELECT Id, Name, TableEnumOrId, Status, CreatedDate FROM ApexTrigger WHERE Name LIKE 'AL_%' ORDER BY CreatedDate DESC ]){
            System.debug(a.Name);
            triggerList.add(new triggerWrapper(a));
        }
        return triggerList;
    }

    public static String stripPrefix(String nm){
        return nm.substringAfter('_');
    }

    public PageReference getSelected()
    {
        selectedTriggers.clear();
        for(triggerWrapper trgWrapper : triggerList)
            if(trgWrapper.selected == true)
                selectedTriggers.add(trgWrapper.apxTrg);
        return null;
    }

    public List<ApexTrigger> GetSelectedTriggers()
    {
        if(selectedTriggers.size()>0)
            return selectedTriggers;
        else
                return null;
    }

    public class triggerWrapper
    {
        public ApexTrigger apxTrg{get; set;}
        public Boolean selected {get; set;}
        public triggerWrapper(ApexTrigger a)
        {
            apxTrg = a;
            selected = false;
        }
    }

    public void getTriggerId(){
        triggerId = triggerId;
    }

    public AnyLabelAutomation(ApexPages.StandardController stdController) {
        stdCtrl = stdController;
        this.a = (AnyLabel__c)stdController.getRecord();
        List<SelectOption> so = new List<SelectOption>();
        so.add(new SelectOption('',''));
        so.add(new SelectOption('Includes', 'Includes'));
        so.add(new SelectOption('Not Includes', 'Not Includes'));
        so.add(new SelectOption('Is Changed', 'Is Changed'));
        so.add(new SelectOption('Equal to', 'Equal to'));
        so.add(new SelectOption('Not Equal to', 'Not Equal to'));
        so.add(new SelectOption('Start with', 'Start with'));
        so.add(new SelectOption('Greater than', 'Greater than'));
        so.add(new SelectOption('Less than', 'Less than'));
        ConditionNames = so;
    }

    public PageReference runEngine() {
        //retrieve relevant fields name from selected object
        system.debug('running engine ... '+objectName);
        fieldNames = getFieldNames(objectName);
        system.debug('running engine... '+fieldNames);
        return null;
    }

    public List<SelectOption> getObjectNames() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> opt = GlobalPicklistEngine.getSObjectList();
        options.add(new SelectOption('', ''));
        for(Integer i=0; i<opt.size(); i++){
            options.add(new SelectOption(opt[i], opt[i]));
        }
        return options;
    }

    public List<SelectOption> getFieldNames(String obj){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', ''));
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap();
        List<String> lst = new List<String>(objectFields.keySet());
        List<String> b = New List<String>();
        for(Integer i=0; i<objectFields.size(); i++){
            b.add(String.valueOf(objectFields.values()[i].getDescribe().getType()));
            if(objectFields.values()[i].getDescribe().name!='Labels__c' && objectFields.values()[i].getDescribe().isAccessible() && !objectFields.values()[i].getDescribe().isAutoNumber() && !objectFields.values()[i].getDescribe().isIdLookup() && !objectFields.values()[i].getDescribe().isExternalId() && objectFields.values()[i].getDescribe().getType()!=Schema.DisplayType.DATETIME && objectFields.values()[i].getDescribe().getType()!=Schema.DisplayType.DATE && objectFields.values()[i].getDescribe().getType()!=Schema.DisplayType.PHONE){
                options.add(new SelectOption(lst[i]+'-'+b[i], objectFields.values().get(i).getDescribe().getLabel()));
            }
        }
        system.debug(b);
        return options;
    }

    public List<SelectOption> getConditionNames(){
        return conditionNames;
    }

    public PageReference getInputValue(){
        system.debug('InputValue 1234 ... '+InputValue);
        InputValue = InputValue;
        return null;
    }

    public PageReference getLabelName(){
        system.debug('InputValue 1234 ... '+LabelName);
        LabelName = LabelName;
        return null;
    }

    public List<SelectOption> getLabelsNames(){
        List<SelectOption> so = new List<SelectOption>();
        List<AnyLabel__c> al = [SELECT Name FROM AnyLabel__c WHERE Assignee__c INCLUDES (: objectName)];
        for(Integer i=0; i<al.size(); i++){
            so.add(new SelectOption(al[i].Name, al[i].Name));
        }
        return so;
    }

    public PageReference getFieldName(){
        fieldNames = fieldNames;
        List<SelectOption> so = new List<SelectOption>();
        so.add(new SelectOption('',''));
        so.add(new SelectOption('Includes', 'Includes'));
        so.add(new SelectOption('Not Includes', 'Not Includes'));
        so.add(new SelectOption('Is Changed', 'Is Changed'));
        so.add(new SelectOption('Equal to', 'Equal to'));
        so.add(new SelectOption('Not Equal to', 'Not Equal to'));
        so.add(new SelectOption('Start with', 'Start with'));
        so.add(new SelectOption('Greater than', 'Greater than'));
        so.add(new SelectOption('Less than', 'Less than'));
        so.add(new SelectOption('Changed', 'Changed'));
        ConditionNames = so;
        filterOptions(fieldName);
        return null;
    }

    public PageReference getConditionName(){
        system.debug('passing condition name  ... '+conditionName);
        conditionName = conditionName;
        return null;
    }

    public PageReference filterOptions(String fld){
        ConditionNames = new List<SelectOption>();
        if(fld.contains('CURRENCY') || fld.contains('DOUBLE') || fld.contains('INTEGER') || fld.contains('DATE')){
            ConditionNames.add(new SelectOption('',''));
            ConditionNames.add(new SelectOption('Greater than', 'Greater than'));
            ConditionNames.add(new SelectOption('Less than', 'Less than'));
            ConditionNames.add(new SelectOption('Changed', 'Changed'));
        } else if(fld.contains('PERCENT')) {
            ConditionNames.add(new SelectOption('',''));
            ConditionNames.add(new SelectOption('Equal', 'Equal'));
            ConditionNames.add(new SelectOption('Higher', 'Higher'));
            ConditionNames.add(new SelectOption('Lower', 'Lower'));
        }else if (fld.contains('BOOLEAN')){
            ConditionNames.add(new SelectOption('',''));
            ConditionNames.add(new SelectOption('Is True', 'Is True'));
            ConditionNames.add(new SelectOption('Is False', 'Is False'));
            ConditionNames.add(new SelectOption('Has Value Changed', 'Has Value Changed'));
        }else{
            ConditionNames.add(new SelectOption('',''));
            ConditionNames.add(new SelectOption('Includes', 'Includes'));
            ConditionNames.add(new SelectOption('Not Includes', 'Not Includes'));
            ConditionNames.add(new SelectOption('Is Changed', 'Is Changed'));
            ConditionNames.add(new SelectOption('Equal to', 'Equal to'));
            ConditionNames.add(new SelectOption('Not Equal to', 'Not Equal to'));
            ConditionNames.add(new SelectOption('Start with', 'Start with'));
        }
        return null;
    }
}