/**
 * Created by Adelchi on 18/04/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


@IsTest
private class CalloutClassTest {
    private static List<String> lstL = new List<String>();
    @IsTest
    static void testBehavior () {
        lstL.add('Account');
        lstL.add('name');
        lstL.add('Not Equal to');
        lstL.add('aaa');
        lstL.add('Label nr.2,Label nr.3');
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        AnyLabelAutomation.createTrigger(lstL);
//        GlobalPicklistEngine.getGlobalPicklistId('SObject');
//        List<String> lsSO = new List<String>();
//        lsSo.add('a');
//        lsSo.add('b');
//        GlobalPicklistEngine.updateGlobalPicklist(lsSo, GlobalPicklistEngine.getGlobalPicklistId('SObject'));

        // Verify response received contains fake values
//        String contentType = res.getHeader('Content-Type');
//        System.assert(contentType == 'application/json');
//        String actualValue = res.getBody();
//        String expectedValue = '{"example":"test"}';
//        System.assertEquals(actualValue, expectedValue);
//        System.assertEquals(200, res.getStatusCode());
    }
}