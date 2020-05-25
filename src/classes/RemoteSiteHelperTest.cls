/*
 * Copyright (c) 2020.  adelForce (Adelchi Ltd)
 *  All Rights Reserved
 *  NOTICE:  All information contained herein is, and remains the property of adelForce (Adelchi Ltd) .
 *  The intellectual and technical concepts contained are protected by trade secret or copyright law.
 *  Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained from  adelForce (Adelchi Ltd).
 */

@IsTest
private class RemoteSiteHelperTest 
{
	@IsTest
	private static void testCheckMetadataAPIConnection()
	{			
    	// Metadata API web Service mock implementation for tests
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
		
		RemoteSiteHelperController controller = new RemoteSiteHelperController();
		System.assertEquals(true, controller.MetadataConnectionWarning);		
		controller.MetadataResponse = '';
		controller.displayMetadataResponse();
		System.assertEquals(false, controller.MetadataConnectionWarning);
		controller.MetadataResponse = 'Some Error Creating Remote Site Setting';
		controller.displayMetadataResponse();
		System.assertEquals(true, controller.MetadataConnectionWarning);
	}
	
    /**
     * Metadata API web service mock class for tests above
     **/
	private class WebServiceMockImpl implements WebServiceMock 
	{
		public void doInvoke(
			Object stub, Object request, Map<String, Object> response,
			String endpoint, String soapAction, String requestName,
			String responseNS, String responseName, String responseType) 
		{
			throw new TestException();
		}
	}
	
	public class TestException extends Exception { }
}