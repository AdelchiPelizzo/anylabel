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
        Test.startTest();
        ctrl.runEngine();
        system.assert(ctrl.fieldNames.size()>0);
        system.assert(ctrl.getObjectNames()!=null);
        system.assert(ctrl.getFieldNames('Account')!=null);
        system.assert(ctrl.getConditionNames()!=null);
        system.assert(ctrl.getLabelsNames()!=null);
        Test.stopTest();
    }
}