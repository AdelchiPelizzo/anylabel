/**
 * Created by Adelchi on 18/04/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


@IsTest
private class GlobalPicklistEngineTest {

    public static globalValueSet gblV = new GlobalValueSet();
    private static AnyLabel__c a = new AnyLabel__c();
    private static ApexPages.StandardController stdCtrl = new ApexPages.StandardController(a);
    @IsTest
    static void testBehavior () {
        AnyLabelAutomation ctrl = new AnyLabelAutomation(stdCtrl);
        ctrl.objectName = 'Account';
        Test.startTest();
        ctrl.runEngine();
        system.assert(ctrl.fieldNames.size()>0);
        ctrl.getObjectNames();
        system.assert();
        Test.stopTest();

    }
}