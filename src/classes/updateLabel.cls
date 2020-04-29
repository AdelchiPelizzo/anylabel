/**
 * Created by Adelchi on 23/04/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


public with sharing class updateLabel implements Queueable, Database.AllowsCallouts{
    /**
 * Purpose : (Write a succinct description of this method here.)
 * @param (parameter name) (Describe the first parameter here)
 * @param (parameter name) (Do the same for each additional parameter)
 * @return (description of the return value)
 */

    public static String recordId;
    private static Account a;

    public updateLabel(String recId){
        system.debug('constructor ... '+recId);
        String recordId = recId;
        a = [SELECT test__c from Account WHERE Id = :recordId LIMIT 1];

    }

    public void execute(QueueableContext context) {
        //1 - creates the callout payload
//        String reqBody = JSON.serialize(createFromCase(this.ticket));

        //2 - gets the already created Callout__c object
//        Callout__c currentCallout = [Select Id, Status__c, Sent_on__c, Response__c, Case__c,
//                Job_ID__c From Callout__c Where Job_ID__c = :context.getJobId()];

        //3 - starting time (to get Duration__c)
//        Long start = System.now().getTime();

        //4 - tries to make the REST call
        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://anylabel.herokuapp.com/1/2');
            req.setMethod('GET');
            Http httpReq = new Http();
            HttpResponse res  = httpReq.send(req);
            System.debug(res.getBody());
            a.test__c = res.getBody();
            update a;
            //4a - Response OK
//            if(response.getStatusCode() == 200){
//                currentCallout.status__c = 'OK';
//                //4b - Reponse KO
//            }else{
//                currentCallout.status__c = 'KO';
//            }
            //4c - saves the response body
//            currentCallout.Response__c = response.getBody();
        }catch(Exception e){
            //5 - callout failed (e.g. timeout)
//            currentCallout.status__c = 'Failed';
//            currentCallout.Response__c = e.getStackTraceString().replace('\n',' / ')+' - '+e.getMessage();
            system.debug(e.getStackTraceString().replace('\n',' / ')+' - '+e.getMessage());

            //6 - it would have been cool to reschedule the job again 🙁
            /*
             * Apprently this cannot be done due to "Maximum callout depth has been reached." exception
            ID jobID = System.enqueueJob(new CaseQueuebleJob(this.ticket));
            Callout__c retry = new Callout__c(Job_ID__c = jobID,
                                                 Case__c = this.ticket.Id,
                                                Status__c = 'Queued');
            insert retry;
            */
        }
        //7 - sets various info about the job
//        currentCallout.Sent_on__c = System.now();
//        currentCallout.Duration__c = system.now().getTime()-start;
//        update currentCallout;
//        //8 - created an Attachment with the request sent (it could be used to manually send it again with a bonification tool)
//        Attachment att = new Attachment(Name = 'request.json',
//                Body = Blob.valueOf(reqBody),
//                ContentType='application/json',
//                ParentId = currentCallout.Id);
//        insert att;
    }
}