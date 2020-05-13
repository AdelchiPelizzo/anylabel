/**
 * Created by Adelchi on 18/04/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


@IsTest
private class AnyLabelAutomationTest {
    private static AnyLabel__c a = new AnyLabel__c();
    private static ApexPages.StandardController stdCtrl = new ApexPages.StandardController(a);
    @IsTest
    static void testBehavior () {
        AnyLabelAutomation ctrl = new AnyLabelAutomation(stdCtrl);
        ctrl.objectName = 'Account';
        ctrl.fieldName = 'Name';
        ctrl.selectedTriggers = new List<ApexTrigger>();
        Account acc = new Account();
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.CloseDate = System.today();
        opp.StageName = 'Prospecting';
        acc.Name = 'test';
        acc.AccountNumber = '123456';
        ApexTrigger apxTr = new ApexTrigger();
        Test.startTest();
        PageReference pageRef = Page.triggerEngine;
        ctrl.runEngine();
        system.assert(ctrl.fieldNames.size()>0);
        system.assert(ctrl.getObjectNames()!=null);
        system.assert(ctrl.getFieldNames('Account')!=null);
        system.assert(ctrl.getConditionNames()!=null);
        system.assert(ctrl.getLabelsNames()!=null);
        system.assert(ctrl.getFieldName()==null);
        system.assert(ctrl.triggerLink!=null);
        system.assert(ctrl.getTriggers()!=null);
        system.assert(ctrl.getSelected()==null);
        system.assert(ctrl.getSelectedTriggers()==null);
        system.assert(ctrl.getConditionName() == null);
        system.assert(ctrl.getInputValue() == null);
        system.assert(ctrl.getLabelName() == null);
        system.assert(ctrl.filterOptions('CURRENCY')==null);
        system.assert(ctrl.filterOptions('PERCENT')==null);
        system.assert(ctrl.filterOptions('STRING')==null);
        Test.stopTest();
    }
}