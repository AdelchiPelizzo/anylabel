/**
 * Created by Adelchi on 14/04/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


public with sharing class AnyLabelAutomation {
    /**
 * Purpose : (Write a succinct description of this method here.)
 * @param (parameter name) (Describe the first parameter here)
 * @param (parameter name) (Do the same for each additional parameter)
 * @return (description of the return value)
 */

    public String objectName {get; set;}
    public String fieldName {get; set;}
    public List<SelectOption> fieldNames {get; set;}
    public String[] labelName {get; set;}
    public String conditionName {get; set;}
    public String InputValue {get; set;}
    public String triggerId {get; set;}
    public List<SelectOption> ConditionNames ;

    private final AnyLabel__c a;

    ApexPages.StandardController stdCtrl;

//    public static List<ApexTrigger> triggers {get{
//        return [SELECT Id, Name, TableEnumOrId, Status  FROM ApexTrigger];
//    }set;}

    public List<triggerWrapper> triggerList = new List<triggerWrapper>();
    public List<ApexTrigger> selectedTriggers = new List<ApexTrigger>();

    public List<triggerWrapper> getTriggers()
    {
        for(ApexTrigger a : [SELECT Id, Name, TableEnumOrId, Status, CreatedDate FROM ApexTrigger WHERE Name LIKE 'AL_%' ORDER BY CreatedDate DESC ]){
            triggerList.add(new triggerWrapper(a));
        }
        return triggerList;
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
            if(objectFields.values()[i].getDescribe().isAccessible() && objectFields.values()[i].getDescribe()
                    .isCreateable() && !objectFields.values()[i].getDescribe().isAutoNumber() && !objectFields.values
                    ()[i].getDescribe().isIdLookup() && !objectFields.values()[i].getDescribe().isExternalId()){
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
        system.debug('hello ...');
        system.debug('hello ...'+fieldName);
        fieldNames = fieldNames;
        List<SelectOption> so = new List<SelectOption>();
        so.add(new SelectOption('',''));
        so.add(new SelectOption('Includes', 'Includes'));
        so.add(new SelectOption('Not Includes', 'Not Includes'));
        so.add(new SelectOption('Is Changed', 'Is Changed'));
        so.add(new SelectOption('Equal to', 'Equal to'));
        so.add(new SelectOption('Not Equal to', 'Not Equal to'));
        so.add(new SelectOption('Start with', 'Start with'));
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
        system.debug('filtering ...'+fld);
        if(fld.contains('CURRENCY') || fld.contains('DOUBLE') || fld.contains('INTEGER') || fld.contains('DATE')){
            system.debug('inside filter check 1 ... '+fld);
            ConditionNames.remove(6);
        }else if(ConditionNames.size()<6){
            system.debug('inside filter check 2 ... '+fld);
            ConditionNames.add(new SelectOption('Start with', 'Start with'));
        }
        return null;
    }

    @RemoteAction
    public static void createTrigger(List<String> setup){
        for(Integer i=0; i<setup.size(); i++){
            system.debug('I am running ...'+setup[i]);
        }
        String x = String.valueOf(Datetime.now());
        String y = x.replace(' ', '_');
        String z = y.replace('-', '_');
        String w = z.replace(':', '_');
//        AnyLabelTrigger__c alt = new AnyLabelTrigger__c(
//                Name = setup[0],
//                fieldName__c = setup[1],
//                condition__c = setup[2],
//                inputValue__c = setup[3],
//                labelsName__c = setup[4]
//        );
//        insert alt;
        String json = '{ "Name" : "AnyLabelsTrigger", "TableEnumOrId" : "'+setup[0]+'", "Body" : "trigger AnyLabelTrigger_'+w+' on '+setup[0]+' (before update,after insert){String objectSelected=\''+setup[0]+'\';String fieldSelected=\''+setup[1]+'\';String conditionSelected=\''+setup[2]+'\';String checkValue=\''+setup[3]+'\';String labelsSelected=\''+setup[4]+'\';List<AnyLabel__c> aList= [SELECT Name FROM AnyLabel__c WHERE Assignee__c INCLUDES(\''+setup[0]+'\')];system.debug(aList.size());}"}'; //List<String> lstLab=labelsSelected.split(\',\');List<AnyLabel__c> al=[SELECT Name FROM  AnyLabel__c WHERE Assignee__c INCLUDES (\''+setup[0]+'\')];List<'+setup[0]+'> acc=new List<'+setup[0]+'>(); JSON format to create trigger
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



    @future (callout=true)
//    @InvocableMethod
    public static void anyLabelProcessAction(List<String> recId){
        String recordId = recId[0];
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://anylabel.herokuapp.com/1/2');
        req.setMethod('GET');
        Http httpReq = new Http();
        HttpResponse res  = httpReq.send(req);
        System.debug(res.getBody());
        Account a = [SELECT test__c from Account WHERE Id = :recordId LIMIT 1];
        a.test__c = res.getBody();
        update a;
    }
}