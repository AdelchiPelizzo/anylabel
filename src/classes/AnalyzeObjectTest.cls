/*
 * Copyright (c) 2020.  adelForce (Adelchi Ltd)
 *  All Rights Reserved
 *  NOTICE:  All information contained herein is, and remains the property of adelForce (Adelchi Ltd) .
 *  The intellectual and technical concepts contained are protected by trade secret or copyright law.
 *  Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained from  adelForce (Adelchi Ltd).
 */

/**
 * Created by Adelchi on 13/05/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


@IsTest
private class AnalyzeObjectTest {
    @IsTest
    static void testBehavior () {
        Account a = new Account();
        a.Name = 'test';
        a.Labels__c = 'test';
        Datetime dt = a.CreatedDate;
        Boolean b = true;
        Integer i = 0;
        Double d=3.14159;
        ID id='00300000003T2PGAA0';
        Blob exampleIv = Blob.valueOf('Example of IV123');
        insert a;
        List<Object> ob = new List<Object>();
        System.assert(AnalyzeObject.getRequiredFieldsName('Account')!=null);
        System.assert(AnalyzeObject.getTypeOf(a.Name)=='String');
        System.assert(AnalyzeObject.getTypeOf(System.now())=='Datetime');
        System.assert(AnalyzeObject.getTypeOf(b)=='Boolean');
        System.assert(AnalyzeObject.getTypeOf(i)=='Integer');
        System.assert(AnalyzeObject.getTypeOf(d)=='Decimal');
        System.assert(AnalyzeObject.getTypeOf(ID)=='Id');
        System.assert(AnalyzeObject.getTypeOf(a)=='Account');
        System.assert(AnalyzeObject.getTypeOf(exampleIv)=='Blob');
        System.assert(AnalyzeObject.getTypeOf(ob)=='List');
        System.assert(AnalyzeObject.hasSObjectField('Labels__c', 'Account')==true);
    }
}