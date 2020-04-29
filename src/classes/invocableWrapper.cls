/**
 * Created by Adelchi on 23/04/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


global with sharing class invocableWrapper {
    /**
 * Purpose : (Write a succinct description of this method here.)
 * @param (parameter name) (Describe the first parameter here)
 * @param (parameter name) (Do the same for each additional parameter)
 * @return (description of the return value)
 */

//    @InvocableVariable(label='Record Id')
    global static String input = '0013z00002Q64YnAAJ';

    @InvocableMethod
    global static void runUpdate(List<String> inputStrings){
        anyLabelProcessAction(inputStrings);
//        updateLabel up = New updateLabel(input);
    }

    @Future(callout=true)
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