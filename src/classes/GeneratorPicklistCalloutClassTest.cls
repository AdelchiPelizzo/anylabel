/**
 * Created by Adelchi on 18/04/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


@IsTest
private class GeneratorPicklistCalloutClassTest {
    @IsTest
    static void testBehavior () {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorGPicklistEngine());
        GlobalPicklistEngine.getGlobalPicklistId('SObject');
    }
}