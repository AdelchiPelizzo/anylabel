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
private class UpdateGlobalPicklistCalloutTest {
    @IsTest
    static void testBehavior () {
        Test.setMock(HttpCalloutMock.class, new MockHttpRespGeneUpdateGlobalPicklist());
        List<String> lsS = new List<String>();
        lsS.add('Account');
        lsS.add('Contact');
        GlobalPicklistEngine.updateGlobalPicklist(lsS, '12345678910');
        Test.setMock(HttpCalloutMock.class, new MockHttpRespGenUpdateGlobalPicklistId());
        GlobalPicklistEngine.getGlobalPicklistId('12345678910');
    }
}