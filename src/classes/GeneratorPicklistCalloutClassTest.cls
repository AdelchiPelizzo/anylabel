/**
 * Created by Adelchi on 18/04/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


@IsTest
private class GeneratorPicklistCalloutClassTest {
    private static List<String> lstL = new List<String>();
    @IsTest
    static void testBehavior () {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorGPicklistEngine());

        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        GlobalPicklistEngine.getGlobalPicklistId('SObject');
    }
}