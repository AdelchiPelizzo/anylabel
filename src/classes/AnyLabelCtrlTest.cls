/**
 * Created by Adelchi on 18/04/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


@IsTest
private class AnyLabelCtrlTest {
    public static AnyLabel__c anyL = new AnyLabel__c(
            Assignee__c = 'Account',
            Background_Color__c = '#122222',
            Font_Color__c = 'white',
            Name = 'LabelTest'
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
            Name = 'testaccount'
    );
    @IsTest
    static void testBehavior () {
        insert u;
        insert us;
        insert anyL;
        Database.insert(shareInsert,false);
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
    }
}