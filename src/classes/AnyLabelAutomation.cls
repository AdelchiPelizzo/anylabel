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


    public static String message {get{return 'hello man ...';} set;}
    public static List<String> objects {get{return GlobalPicklistEngine.getSObjectList();} set;}
    public static List<String> setupItems {get; set;}
    public static String objectName {get; set;}
    public static String objectNameTest {get; set;}
//    {objectNameTest = value; System.debug('value: '+value);}}
    public String fieldName {get; set;}
    public List<SelectOption> fieldNames {get; set;}
    public String labelName {get; set;}
    public String conditionName {get; set;}
    public String inputValue {get{return inputValue;} set{inputValue = inputValue;}}
//    public List<SelectOption> ConditionNames {get; set;}
    private final AnyLabel__c a;

    ApexPages.StandardController stdCtrl;


    public AnyLabelAutomation(ApexPages.StandardController stdController) {
        stdCtrl = stdController;
        this.a = (AnyLabel__c)stdController.getRecord();
    }

    public PageReference runEngine() {
        objectNameTest = objectName;
        //retrieve relevant fields name from selected object
        system.debug('running engine ... '+objectName);
        fieldNames = getFieldNames(objectName);
        system.debug('running engine ... '+fieldNames);
        return null;
    }

    public PageReference runEngine2() {
        //retrieve relevant fields name from selected object
        system.debug('running engine ... '+fieldName);
        return null;
    }

    public PageReference runSetup(){
//        List<String> setup = new List<String>();
//        setup.add(objectName);
        system.debug(objectNameTest);
        system.debug(objectName);
//        createTrigger(setup);
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

    public static List<SelectOption> getFieldNames(String obj){
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

    public static List<SelectOption> getConditionNames(){
        List<SelectOption> so = new List<SelectOption>();
        so.add(new SelectOption('',''));
        so.add(new SelectOption('Includes', 'Includes'));
        so.add(new SelectOption('Not Includes', 'Not Includes'));
        so.add(new SelectOption('Is Changed', 'Is Changed'));
        so.add(new SelectOption('Equal to', 'Equal to'));
        so.add(new SelectOption('Not Equal to', 'Not Equal to'));
        so.add(new SelectOption('Start with', 'Start with'));
        return so;
    }

    public static List<SelectOption> getLabelsNames(){
        List<SelectOption> so = new List<SelectOption>();
        List<AnyLabel__c> al = [SELECT Name FROM AnyLabel__c WHERE Assignee__c =: objectName];
        for(Integer i=0; i<al.size(); i++){
            so.add(new SelectOption(al[i].Name, al[i].Name));
        }
        return so;
    }

    @RemoteAction
    public static void createTrigger(List<String> setup){
        for(Integer i=0; i<setup.size(); i++){
            system.debug('I am running ...'+setup[i]);
        }
//        String x = String.valueOf(Datetime.now());
//        String y = x.replace(' ', '_');
//        String z = y.replace('-', '_');
//        String w = z.replace(':', '_');
//        String json = '{ "Name" : "AnyLabelsTrigger", "TableEnumOrId" : "'+setup[0]+'", "Body" : "trigger AnyLabelTrigger_'+w+' on '+setup[0]+' (before update) {}"}'; // JSON format to create trigger
//        system.debug(json);
//        HttpRequest req = new HttpRequest();
//        req.setEndpoint(URL.getOrgDomainUrl().toExternalForm()+'/services/data/v47.0/sobjects/ApexTrigger');
//        req.setMethod('POST');
//        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
//        req.setHeader('Content-Type', 'application/json');
//        req.setBody(json);
//        Http httpReq = new Http();
//        HttpResponse res  = httpReq.send(req);
//        System.debug(res.getBody());
    }
}