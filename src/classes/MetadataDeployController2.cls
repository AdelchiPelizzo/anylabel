/**
 * Copyright (c) 2012, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors
 *      may be used to endorse or promote products derived from this software without
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

public class MetadataDeployController2{
    public String ZipData { get; set; }
    public String ObjName { get{return ObjName;} set; }
    public String FldName { get{return FldName;} set; }
    public String OptName { get{return OptName;} set; }
    public String InpVal { get{return InpVal;} set; }
    public String[] Labs { get{return Labs;} set; }
    public String triggerId {get{
        String x = String.valueOf(Datetime.now());
        String y = x.replace(' ', '_');
        String z = y.replace('-', '_');
        String w = z.replace(':', '_');
        String k = w.substring(2,16);
        return k;
    } set;}

    public MetadataService.AsyncResult AsyncResult {get; private set;}

    public String getFieldName(){
        return fldName;
    }

    public String getInpVal(){
        return InpVal;
    }

//    public String getPackageXml()
//    {
//        return '<?xml version="1.0" encoding="UTF-8"?>' +
//                '<Package xmlns="http://soap.sforce.com/2006/04/metadata">' +
//                '<types>' +
//                '<members>HelloWorld</members>' +
//                '<members>HelloWorldTest</members>' +
//                '<name>ApexClass</name>' +
//                '</types>' +
//                '<version>26.0</version>' +
//                '</Package>';
//    }

    public String getPackageXml()
    {
        return '<?xml version="1.0" encoding="UTF-8"?>' +
                '<Package xmlns="http://soap.sforce.com/2006/04/metadata">' +
                '<types>' +
                '<members>AnyLabelTrigger'+triggerId+'</members>' +
                '<name>ApexTrigger</name>' +
                '</types>' +
                '<types>'+
                '<members>AnyLabelTrigger'+triggerId+'Test</members>' +
                '<name>ApexClass</name>' +
                '</types>'+
                '<version>26.0</version>' +
                '</Package>';
    }


//    public String getHelloWorldMetadata()
//    {
//        return '<?xml version="1.0" encoding="UTF-8"?>' +
//                '<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">' +
//                '<apiVersion>28.0</apiVersion>' +
//                '<status>Active</status>' +
//                '</ApexClass>';
//    }

    public String getHelloWorldMetadata()
    {
        return '<?xml version="1.0" encoding="UTF-8"?>' +
                '<ApexTrigger  xmlns="http://soap.sforce.com/2006/04/metadata">' +
                '<apiVersion>28.0</apiVersion>' +
                '<status>Active</status>' +
                '</ApexTrigger >';
    }

//    public String getHelloWorld()
//    {
//        return 'public class HelloWorld' +
//                '{' +
//                'public static void helloWorld()' +
//                '{' +
//                'System.debug('+'\''+hwObjName+'\');' +
//                '}' +
//                '}';
//    }

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
        String f;
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
        switch on OptName {
            when 'Includes' {
                cond = 'vNew.contains(\''+i+'\')';
            }
            when 'Not Includes' {
                cond = '!vNew.contains(\''+i+'\')';
            }
            when 'Is Changed' {
                cond = 'vOld!=vNew';
            }
            when 'Equal to' {
                cond = 'vNew=='+'\''+i+'\'';
            }
            when 'Not Equal to' {
                cond = 'vNew!='+'\''+i+'\'';
            }
            when 'Start with' {
                cond = 'vNew.startsWith(\''+i+'\')';
            }
        }
        String s = 'trigger AnyLabelTrigger' + triggerId + ' on ' + ObjName + ' (before update, before insert) ' +
                '{' +
                    'Map<Id,' + ObjName + '>  oldObj  =  Trigger.oldMap;' +
                    'Map<Id,' + ObjName + '>  newObj  =  Trigger.newMap;' +
                    'List<String> labList = new List<String>();'+
                    'String s = \''+lab+'\'.remove(\')\').remove(\'(\');'+
                    'labList = s.split(\',\');'+
                    'if(Trigger.isInsert)' +
                    '{' +
                        'for(' + ObjName + ' aNew : Trigger.new)' +
                        '{' +
                            'System.debug(\'hello world ...\');' +
                        '}' +
                    '}else if (Trigger.isUpdate){' +
                        'for(' + ObjName + ' aOld : Trigger.old)' +
                        '{' +
                            ObjName+' rec = [SELECT Labels__c FROM '+ObjName+' WHERE Id =: aOld.Id ];'+
                            ObjName+' objOld = Trigger.oldMap.get(aOld.Id);'+
                            ObjName+' objNew = Trigger.newMap.get(aOld.Id);'+
                            'String vOld = objOld.'+f+';'+
                            'String vNew = objNew.'+f+';'+
                            'if('+cond+'){' +
                                'if(labList.size()>'+1+'){' +
                                    'for(String s : labList){'+
                                        'if(!rec.Labels__c.contains(s)){'+
                                            'objNew.Labels__c += \';\'+s;'+
                                            '}'+
                                    '}'+
                                '}else{'+
                                    'objNew.Labels__c += \''+Label1+'\';'+
                                '}' +
                            '}' +
                        '}'+
                    '}' +
                '}';
        system.debug(s);
        return s;
    }

//    String s = 'trigger AnyLabelTrigger'+triggerId+' on '+ObjName+'(after update)' +
//            '{'+
//            'List<'+ObjName+'> o = new List<'+ObjName+'>();'+
//            'for('+ObjName+' a : Trigger.new)' +
//            '{' +
//            ObjName+' aOld = Trigger.oldMap.get(a.Id);'+
//            'String vOld = aOld.'+f+';'+
//            'String vNew = a.'+f+';'+
//            'system.debug(vOld==vNew);'+
//            'System.debug(a.Id);' +
//            'System.debug(a.'+f+');' +
//            'System.debug(\''+OptName+'\');' +
//            'System.debug(\''+i+'\');' +
//            lb +
//            '}' +
//            '}';
//    system.debug(s);
//return s;


//    public String getHelloWorldTestMetadata()
//    {
//        return '<?xml version="1.0" encoding="UTF-8"?>' +
//                '<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">' +
//                '<apiVersion>28.0</apiVersion>' +
//                '<status>Active</status>' +
//                '</ApexClass>';
//    }

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
        String f;
        if(fldName!=null){f = getFieldName().substringBefore('-');}
        if(ObjName == 'Opportunity'){
//            System.debug('@IsTest ' +
//                        'private class  AnyLabelTrigger'+triggerId+'Test {'+
//                            'static testMethod void run() {'+
//                                ObjName+' a = New '+ObjName+'();'+
//                                'a.Name = \'test\' ;'+
//                                'a.CloseDate = Date.today();'+
//                                'a.'+f+' =  \'test\' ;'+
//                                'insert a;'+
//                                'System.debug(a.'+f+');' +
//                            '}'+
//                        '}');
                return '@IsTest ' +
                        'private class  AnyLabelTrigger'+triggerId+'Test {'+
                            'static testMethod void run() {'+
                                ObjName+' a = New '+ObjName+'();'+
                                'a.Name = \'test\' ;'+
                                'a.CloseDate = Date.today();'+
                                'a.'+f+' =  \'test\' ;'+
                                'insert a;'+
                                'System.debug(a.'+f+');' +
                            '}'+
                        '}';
            }else if(ObjName == 'Contract'){
            system.debug(
                    '@IsTest ' +
                            'private class  AnyLabelTrigger'+triggerId+'Test {'+
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
                            '}'
                    );
            return '@IsTest ' +
                    'private class  AnyLabelTrigger'+triggerId+'Test {'+
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

            }else{
            system.debug(
                    '@IsTest ' +
                            'private class  AnyLabelTrigger'+triggerId+'Test {'+
                            'static testMethod void run() {'+
                            ObjName+' a = New '+ObjName+'();'+
                            'a.Name = \'test\';'+
                            'insert a;'+
                            '}' +
                            '}');
                return	'@IsTest ' +
                        'private class  AnyLabelTrigger'+triggerId+'Test {'+
                            'static testMethod void run() {'+
                                ObjName+' a = New '+ObjName+'();'+
                                'a.Name = \'test\';'+
                                'insert a;'+
                            '}' +
                        '}';

            }
    }

//    public String getHelloWorldTest()
//    {
//        return	'@IsTest' +
//                ' private class HelloWorldTest' +
//                '{'+
//                'static testMethod void helloWorldTest()' +
//                '{' +
//                'HelloWorld.helloWorld() ;' +
//                '}' +
//                '}';
//    }


    public PageReference deployZip()
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Deploying...'));

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
        String[] s = new String[]{'AnyLabelTrigger'+triggerId+'Test'};
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
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Deployment complete'));

            // Deployment errors?
            if(deployResult.details!=null && deployResult.details.componentFailures!=null)
                for(MetadataService.DeployMessage deployMessage : deployResult.details.componentFailures)
                    if(deployMessage.problem!=null)
                        ApexPages.addMessage(
                                new ApexPages.Message(ApexPages.Severity.Error,
                                        deployMessage.fileName +
                                                ' (Line: ' + deployMessage.lineNumber + ': Column:' + deployMessage.columnNumber + ') : ' +
                                                deployMessage.problem));
            AsyncResult = null;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Deploying...'));
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