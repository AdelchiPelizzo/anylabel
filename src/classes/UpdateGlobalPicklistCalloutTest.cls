/**
 * Created by Adelchi on 18/04/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


@IsTest
private class UpdateGlobalPicklistCalloutTest {
    @IsTest
    static void testBehavior () {
        Test.setMock(HttpCalloutMock.class, new MockHttpRespGeneUpdateGlobalPicklist());
        List<String> lsS = new List<String>();
        lsS.add('Account');
        lsS.add('Contact');
        GlobalPicklistEngine.updateGlobalPicklist(lsS, '12345678910');
    }
}