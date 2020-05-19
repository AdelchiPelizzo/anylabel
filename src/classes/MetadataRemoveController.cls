/**
 * Created by Adelchi on 09/05/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


public class MetadataRemoveController {
    /**
 * Purpose : (Write a succinct description of this method here.)
 * @param (parameter name) (Describe the first parameter here)
 * @param (parameter name) (Do the same for each additional parameter)
 * @return (description of the return value)
 */
    public String ZipData { get; set; }
    public List<ApexTrigger> trigger_Name {get; set;}

    public MetadataService.AsyncResult AsyncResult {get; private set;}

    public String getPackageXml()
    {
        return '<?xml version="1.0" encoding="UTF-8"?>' +
                '<Package xmlns="http://soap.sforce.com/2006/04/metadata">'+
                '<version>26.0</version>' +
                '</Package>';
    }

    public String getMetadata()
    {   String members= '';
        if(trigger_Name!=null){
            for(ApexTrigger apxTrg : trigger_Name){
                members += '<members>'+apxTrg.Name+'</members>';
            }
        }else{
            members += '<members></members>';
        }
        system.debug(members);
        system.debug('<?xml version="1.0" encoding="UTF-8"?>'+
                '<Package xmlns="http://soap.sforce.com/2006/04/metadata">'+
                '<types>'+
                members+
                '<name>ApexTrigger</name>'+
                '</types>'+
                '<version>28.0</version>'+
                '</Package>');
        return '<?xml version="1.0" encoding="UTF-8"?>'+
                '<Package xmlns="http://soap.sforce.com/2006/04/metadata">'+
                    '<types>'+
                        members+
                        '<name>ApexTrigger</name>'+
                    '</types>'+
                '<version>28.0</version>'+
                '</Package>';
    }

    public PageReference deployZip()
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Removing Rules ... please wait.'));

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
//        String[] s = new String[]{'AnyLabelTrigger'+triggerId+'Test'};
//        deployOptions.runTests = s;
//        deployOptions.testLevel = 'RunSpecifiedTests' ;
        deployOptions.testLevel = 'RunLocalTests';
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
//            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Rules Removed - refresh page to continue.'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, '<span style="color: darkblue">Processing has been completed.<br/>Minimize this window, or hit "refresh", to continue removing rules.</span>'));


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
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Processing... please wait.'));
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