/*
 * Copyright (c) 2020.  adelForce (Adelchi Ltd)
 *  All Rights Reserved
 *  NOTICE:  All information contained herein is, and remains the property of adelForce (Adelchi Ltd) .
 *  The intellectual and technical concepts contained are protected by trade secret or copyright law.
 *  Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained from  adelForce (Adelchi Ltd).
 */
/**
 * Created by Adelchi on 18/04/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


@IsTest
private class AnyLabelCtrlTest {
    public static AnyLabel__c anyL = new AnyLabel__c(
            Assignee__c = 'Contact;Account',
            Background_Color__c = '#122222',
            Font_Color__c = 'white',
            Name = 'label test'
    );
    public static AnyLabel__c anyL2 = new AnyLabel__c(
            Assignee__c = 'Account;Contact',
            Background_Color__c = '#122222',
            Font_Color__c = 'white',
            Name = 'label test2'
    );
    public static AnyLabel__c anyL3 = new AnyLabel__c(
            Assignee__c = 'Account',
            Background_Color__c = '#122222',
            Font_Color__c = 'white',
            Name = 'label test2'
    );
    public static Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    public static User u = new User(
            Alias = 'admin',
            Email='adminuser@testorg.com',
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='adminuser@testorg.com'
    );
    public static User us = new User(
            Alias = 'admins',
            Email='adminusers@testorg.com',
            EmailEncodingKey='UTF-8',
            LastName='Testings',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='adminusers@testorg.com'
    );
    public static AnyLabel__Share shareInsert = new AnyLabel__Share(
            AccessLevel = 'All',
            UserOrGroupId = u.Id,
            ParentId = anyL.Id
    );
    public static Account acc = new Account(
            Name = 'testaccount',
            Labels__c = 'test label; test label2'
    );
    public static Account acc2 = new Account(
            Name = 'testaccount2',
            Labels__c = ''
    );

    public static List<String> objectNam = new List<String>();
    public static List<String> labelsToRemoveName = new List<String>();
    public static List<String> labelsToAddName = new List<String>();

    @IsTest
    static void testBehavior () {
        insert u;
        insert us;
        insert anyL;
        insert anyL2;
        insert anyL3;
        objectNam.add('Account');
        LabelsToRemoveName.add('test label2');
        LabelsToRemoveName.add('test label');
        LabelsToAddName.add('test label2');
        LabelsToAddName.add('test label');
        Database.insert(shareInsert,false);
        Test.startTest();
        System.runAs(u){
            System.assert(AnyLabelCtrl.isAdmin());
        }
        System.runAs(us){
            System.assert(AnyLabelCtrl.isAdmin());
        }
        System.assert(AnyLabelCtrl.getGlobalLabels().size()>0);
        insert acc;
        AnyLabelCtrl.NewLabel(acc.Id, '#122222', 'white', 'LabelTest');
        acc.Labels__c = 'LabelTest;';
        update acc;
        System.assert(AnyLabelCtrl.getSObjectLabelsListAll(acc.Id).size()>0);
        System.assert(AnyLabelCtrl.getAssignedLabelsList(acc.Id).size()>0);
        Exception unexpectedException;
        try
        {
            AnyLabelCtrl.NewLabelMultiAssign(objectNam, 'white', '#ffff', 'LabelTest');
        }
        catch (Exception e)
        {
            unexpectedException = e;
        }
        system.assertEquals(null, unexpectedException, '<message>');
        Exception unexpectedException2;
        try
        {
            AnyLabelCtrl.removeLabelsFromObject(labelsToRemoveName, labelsToAddName, acc.Id);
        }
        catch (Exception e)
        {
            unexpectedException2 = e;
        }
        system.assertEquals(null, unexpectedException2, '<message>');
        Exception unexpectedException3;
        insert acc2;
        try
        {
            AnyLabelCtrl.removeLabelsFromObject(labelsToRemoveName, labelsToAddName, acc2.Id);
        }
        catch (Exception e)
        {
            unexpectedException3 = e;
        }
        system.assertEquals(null, unexpectedException3, '<message>');
        system.assert(AnyLabelCtrl.getSObjectList().size()>0);
        Test.stopTest();
    }
}