/*
 * Copyright (c) 2020.  adelForce (Adelchi Ltd)
 *  All Rights Reserved
 *  NOTICE:  All information contained herein is, and remains the property of adelForce (Adelchi Ltd) .
 *  The intellectual and technical concepts contained are protected by trade secret or copyright law.
 *  Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained from  adelForce (Adelchi Ltd).
 */

public class MetadataDeployController{
	public String ZipData { get; set; }	
	public String hwObjName { get{return hwObjName;} set; }

	public MetadataService.AsyncResult AsyncResult {get; private set;}

	public String getPackageXml()
	{
		return '<?xml version="1.0" encoding="UTF-8"?>' + 
			'<Package xmlns="http://soap.sforce.com/2006/04/metadata">' + 
    			'<types>' + 
        			'<members>HelloWorld</members>' +
        			'<members>HelloWorldTest</members>' +
        			'<name>ApexClass</name>' +
    			'</types>' + 
    			'<version>26.0</version>' + 
			'</Package>';		
	}
	
	public String getHelloWorldMetadata()
	{
		return '<?xml version="1.0" encoding="UTF-8"?>' +
			'<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">' +
			    '<apiVersion>28.0</apiVersion>' + 
			    '<status>Active</status>' +
			'</ApexClass>';		
	}
	
	public String getHelloWorld()
	{
		return 'public class HelloWorld' +
			'{' + 
				'public static void helloWorld()' +
				'{' + 
					'System.debug('+'\''+hwObjName+'\');' +
				'}' +
			'}';
	}

	public String getHelloWorldTestMetadata()
	{
		return '<?xml version="1.0" encoding="UTF-8"?>' +
				'<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">' +
				'<apiVersion>28.0</apiVersion>' +
				'<status>Active</status>' +
				'</ApexClass>';
	}

	public String getHelloWorldTest()
	{
		return	'@IsTest' +
				' private class HelloWorldTest' +
					'{'+
						'static testMethod void helloWorldTest()' +
						'{' +
							'HelloWorld.helloWorld() ;' +
						'}' +
					'}';
	}


		public PageReference deployZip()
	{
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Deploying...'));

		// Deploy zip file posted back from the page action function				
		MetadataService.MetadataPort service = createService();
		MetadataService.DeployOptions deployOptions = new MetadataService.DeployOptions();
        deployOptions.allowMissingFiles = false;
        deployOptions.autoUpdatePackage = false;
        deployOptions.checkOnly = false;
        deployOptions.ignoreWarnings = false;
        deployOptions.performRetrieve = false;
        deployOptions.purgeOnDelete = false;
        deployOptions.rollbackOnError = true;
		deployOptions.testLevel = 'NoTestRun';
        deployOptions.singlePackage = true;		
		AsyncResult = service.deploy(ZipData, DeployOptions);				
		return null;
	}	
	
	public PageReference checkAsyncRequest()
	{	
		// Check the status of the retrieve request
		MetadataService.MetadataPort service = createService();
		MetadataService.DeployResult deployResult = service.checkDeployStatus(AsyncResult.Id, true);
		if(deployResult.done)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Deployment complete'));

			// Deployment errors?
			if(deployResult.details!=null && deployResult.details.componentFailures!=null)
				for(MetadataService.DeployMessage deployMessage : deployResult.details.componentFailures)
					if(deployMessage.problem!=null)
						ApexPages.addMessage(
							new ApexPages.Message(ApexPages.Severity.Error, 
								deployMessage.fileName + 
									' (Line: ' + deployMessage.lineNumber + ': Column:' + deployMessage.columnNumber + ') : ' + 
										deployMessage.problem));
			AsyncResult = null;
		}
		else
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Deploying...'));
		}	
		return null;
	}
	
	private static MetadataService.MetadataPort createService()
	{ 
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = UserInfo.getSessionId();
		return service;		
	}		
}