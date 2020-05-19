/*
 * Copyright (c) 2020.  adelForce (Adelchi Ltd)
 *  All Rights Reserved
 *  NOTICE:  All information contained herein is, and remains the property of adelForce (Adelchi Ltd) .
 *  The intellectual and technical concepts contained are protected by trade secret or copyright law.
 *  Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained from  adelForce (Adelchi Ltd).
 */

public class MetadataDeployController2{
    public String ZipData { get; set; }
    public String ObjName { get{return ObjName;} set; }
    public String FldName { get{return FldName;} set; }
    public String OptName { get{return OptName;} set; }
    public String InpVal { get{return InpVal;} set; }
    public String[] Labs { get{return Labs;} set; }
    public String triggerId {get{return triggerId;}set;}

    public MetadataService.AsyncResult AsyncResult {get; private set;}

    public String getFieldName(){
        return fldName;
    }

    public String getInpVal(){
        return InpVal;
    }

    public String getPackageXml()
    {
        return '<?xml version="1.0" encoding="UTF-8"?>' +
                '<Package xmlns="http://soap.sforce.com/2006/04/metadata">' +
                '<types>' +
                '<members>AL_'+triggerId+'</members>' +
                '<name>ApexTrigger</name>' +
                '</types>' +
                '<types>'+
                '<members>AL_'+triggerId+'Test</members>' +
                '<name>ApexClass</name>' +
                '</types>'+
                '<version>26.0</version>' +
                '</Package>';
    }

    public String getHelloWorldMetadata()
    {
        return '<?xml version="1.0" encoding="UTF-8"?>' +
                '<ApexTrigger  xmlns="http://soap.sforce.com/2006/04/metadata">' +
                '<apiVersion>28.0</apiVersion>' +
                '<status>Active</status>' +
                '</ApexTrigger >';
    }

    public String getHelloWorld() {
        List<String> Lab = new List<String>();
        if(Labs!=null){
            Lab = Labs;
        }
        String Label1 = '';
        if(lab.size()>0){
            Label1 = lab[0];
        }
        system.debug(OptName);
        String i = getInpVal();
        String f = '';
        if (fldName != null) {
            f = getFieldName().substringBefore('-');
        }
        String lb = ';';
        if (Labs != null) {
            for (String l : Labs) {
                lb += l;
            }
        } else {
            system.debug('Is null ... ');
        }
        System.debug(lb);
        String cond;
        String dataTp ='';
        switch on OptName {
            when 'Includes' {
                DataTp = 'String';
                cond = 'vNew.contains(\''+i+'\')';
            }
            when 'Not Includes' {
                DataTp = 'String';
                cond = '!vNew.contains(\''+i+'\')';
            }
            when 'Is Changed' {
                DataTp = 'String';
                cond = 'vOld!=vNew';
            }
            when 'Equal to' {
                DataTp = 'String';
                cond = 'vNew=='+'\''+i+'\'';
            }
            when 'Not Equal to' {
                DataTp = 'String';
                cond = 'vNew!='+'\''+i+'\'';
            }
            when 'Start with' {
                DataTp = 'String';
                cond = 'vNew.startsWith(\''+i+'\')';
            }
            when 'Greater than' {
                DataTp = 'Decimal';
                if(i!=null){
                    cond = 'vNew>'+Decimal.valueOf(i);
                }
            }
            when 'Less than' {
                DataTp = 'Decimal';
                if(i!=null){
                    cond = 'vNew<'+Decimal.valueOf(i);
                }
            }
            when 'Changed' {
                DataTp = 'Decimal';
                cond = 'vNew!=vOld';
            }
            when 'Higher' {
                DataTp = 'Decimal';
                if(i!=null){
                    cond = 'vNew>'+Decimal.valueOf(String.valueOf(i));
                }
            }
            when 'Lower' {
                DataTp = 'Decimal';
                if(i!=null){
                    cond = 'vNew<'+Decimal.valueOf(String.valueOf(i));
                }
            }
            when 'Equal' {
                DataTp = 'Decimal';
                cond = 'vNew!=vOld';
            }
            when 'Is True' {
                DataTp = 'Boolean';
//                if(i!=null){
                    cond = 'vNew == true';
//                }
            }
            when 'Is False' {
                DataTp = 'Boolean';
//                if(i!=null){
                    cond = 'vNew == false';
//                }
            }
            when 'Has Value Changed' {
                DataTp = 'Boolean';
                cond = 'vNew!=vOld';
            }
        }
        String s = 'trigger AL_' + triggerId + ' on ' + ObjName + ' (before update, before insert) ' +
                '{' +
                'Map<Id,' + ObjName + '>  oldObj  =  Trigger.oldMap;' +
                'Map<Id,' + ObjName + '>  newObj  =  Trigger.newMap;' +
                'List<String> labListD = new List<String>();'+
                'List<String> labList = new List<String>();'+
                'String s = \''+lab+'\'.remove(\')\').remove(\'(\');'+
                'labListD = s.split(\',\');'+
                'for(String labStr : labListD){' +
                'LabList.add(labStr.removeStart(\' \'));' +
                '}'+
                'if(Trigger.isInsert)' +
                '{' +
                'for(' + ObjName + ' aNew : Trigger.new)' +
                '{' +
                DataTp+' vNew = aNew.'+f+';'+
                DataTp+' vOld = aNew.'+f+';'+
                'if('+cond+'){' +
                'if(labList.size()>'+1+'){' +
                'for(Integer i=0; i<labList.size(); i++){'+
                'if(aNew.Labels__c == null){' +
                'aNew.Labels__c = \'\';' +
                '}' +
                'if(i<labList.size()-1){' +
                'aNew.Labels__c += labList[i]+\';\';' +
                '}else{' +
                'aNew.Labels__c += labList[i];' +
                '}' +
                '}'+
                '}else{' +
                'aNew.Labels__c += \''+Label1+'\';'+
                '}' +
                '}'+
                '}' +
                '}else if (Trigger.isUpdate){' +
                'for(' + ObjName + ' aOld : Trigger.old)' +
                '{' +
                ObjName+' rec = [SELECT Labels__c FROM '+ObjName+' WHERE Id =: aOld.Id ];'+
                ObjName+' objOld = Trigger.oldMap.get(aOld.Id);'+
                ObjName+' objNew = Trigger.newMap.get(aOld.Id);'+
                DataTp+' vOld = objOld.'+f+';'+
                DataTp+' vNew = objNew.'+f+';'+
                'if('+cond+'){' +
                'if(labList.size()>'+1+'){' +
                'for(String s : labList){'+
                'System.debug(s);'+
                'if(rec.Labels__c == null){rec.Labels__c = \'\';}'+
                'if(!rec.Labels__c.contains(s)){'+
                'objNew.Labels__c += \';\'+s;'+
                '}'+
                '}'+
                '}else if (rec.Labels__c==null){'+
                'objNew.Labels__c = \'\';'+
                'objNew.Labels__c += \''+Label1+'\';'+
                '}else{' +
                'objNew.Labels__c += \';'+Label1+'\';'+
                '}' +
                '}' +
                '}'+
                '}' +
                '}';
        system.debug(s);
        return s;
    }

    public String getHelloWorldTestMetadata()
    {
        return '<?xml version="1.0" encoding="UTF-8"?>' +
                '<ApexTrigger xmlns="http://soap.sforce.com/2006/04/metadata">' +
                '<apiVersion>28.0</apiVersion>' +
                '<status>Active</status>' +
                '</ApexTrigger>';
    }




    public String getHelloWorldTest()
    {
        String s;
        String f = '';
        Schema.DisplayType fieldDisplayType;
        if(fldName!=null ){f = getFieldName().substringBefore('-');
            if(ObjName!=null){
                fieldDisplayType = Schema.getGlobalDescribe().get(ObjName).getDescribe().fields.getMap().get(f).getDescribe().getType();
                System.debug(fieldDisplayType);
            }
        }
        if(ObjName == 'Opportunity'){
            if(f == 'Probability'){
                s = '@IsTest ' +
                        'private class  AL_'+triggerId+'Test {'+
                        'static testMethod void run() {'+
                        ObjName+' a = New '+ObjName+'();'+
                        'a.Name = \'test\' ;'+
                        'a.CloseDate = Date.today();'+
//                        'a.'+f+' =  \'test\' ;'+
                        'a.StageName = \'Qualification\';'+
                        'insert a;'+
                        'System.debug(a.'+f+');' +
                        '}'+
                        '}';
                system.debug(s);
                return s;
            }else{
                s = '@IsTest ' +
                        'private class  AL_'+triggerId+'Test {'+
                        'static testMethod void run() {'+
                        ObjName+' a = New '+ObjName+'();'+
                        'a.Name = \'test\' ;'+
                        'a.CloseDate = Date.today();'+
                        'a.StageName = \'Qualification\';'+
//                        'a.'+f+' =  Decimal.valueOf(\'50\') ;'+
                        'insert a;'+
                        'System.debug(a.'+f+');' +
                        '}'+
                        '}';
                system.debug(s);
                return s;
            }
        }else if(ObjName == 'Contract'){
            s = '@IsTest ' +
                    'private class  AL_'+triggerId+'Test {'+
                    'static testMethod void run() {'+
                    'Account acc = new Account();'+
                    'acc.Name = \'test\';'+
                    'insert acc;'+
                    ObjName+' a = New '+ObjName+'();'+
                    'a.Status = \'Draft\' ;'+
                    'a.AccountId = acc.Id;'+
                    'a.StartDate = Date.today();'+
                    'a.ContractTerm = '+12+';'+
                    'insert a;'+
                    '}'+
                    '}';
            system.debug(s);
            return s;
        }else if (ObjName=='Case') {
            s =	'@IsTest ' +
                    'private class AL_'+triggerId+'Test {'+
                    'static testMethod void run() {'+
                    ObjName+' a = New '+ObjName+'();'+
                    'a.Status = \'New\';'+
                    'a.Origin = \'Phone\';'+
                    'insert a;'+
                    '}' +
                    '}';
            system.debug(s);
            return s;
        }else{
            s = '@IsTest ' +
                    'private class AL_'+triggerId+'Test {'+
                    'static testMethod void run() {'+
                    ObjName+' a = New '+ObjName+'();'+
                    'a.Name = \'test\';'+
                    'insert a;'+
                    '}' +
                    '}';
            system.debug(s);
            return s;
        }
    }

    public PageReference deployZip()
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Creating Rule >>> please wait.'));

        // Deploy zip file posted back from the page action function
        MetadataService.MetadataPort service = createService();
        MetadataService.DeployOptions deployOptions = new MetadataService.DeployOptions();
        deployOptions.allowMissingFiles = false;
        deployOptions.autoUpdatePackage = false;
        deployOptions.checkOnly = false;
        deployOptions.ignoreWarnings = false;
        deployOptions.performRetrieve = false;
        deployOptions.purgeOnDelete = false;
        deployOptions.rollbackOnError = true;
        String[] s = new String[]{'AL_'+triggerId+'Test'};
        deployOptions.runTests = s;
        deployOptions.testLevel = 'RunSpecifiedTests';
//      deployOptions.testLevel = 'NoTestRun';
        deployOptions.singlePackage = true;
        AsyncResult = service.deploy(ZipData, DeployOptions);
        return null;
    }

    public PageReference checkAsyncRequest()
    {
        // Check the status of the retrieve request
        MetadataService.MetadataPort service = createService();
        MetadataService.DeployResult deployResult = service.checkDeployStatus(AsyncResult.Id, true);
        if(deployResult.done)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, '<br/><br/>Processing has been completed.<br/><span style="color: darkblue">Minimize this window, or hit "refresh", to create new rules.</span>'));

            // Deployment errors?
            if(deployResult.details!=null && deployResult.details.componentFailures!=null)
                for(MetadataService.DeployMessage deployMessage : deployResult.details.componentFailures)
                    if(deployMessage.problem!=null)
                        ApexPages.addMessage(
                                new ApexPages.Message(ApexPages.Severity.Error, deployMessage.fileName +'<br/>Line: ' + deployMessage.lineNumber + ': Column:' + deployMessage.columnNumber +' - '+deployMessage.problem));
            AsyncResult = null;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Processing...'));
        }
        return null;
    }

    private static MetadataService.MetadataPort createService()
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }
}