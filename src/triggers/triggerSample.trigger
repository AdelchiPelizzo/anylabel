/**
 * Created by Adelchi on 17/04/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


trigger triggerSample on Account (after update , after insert) {

//    for (Account objNew: Trigger.new) {
//        system.debug('trigger started');
//        updateLabel updt = new updateLabel(objNew.Id);
//        system.debug('trigger ended');
//    }




    List<Account> accs = new List<Account>();
    List<String> accsId = new List<String>();

    for (Account objNew: Trigger.new) {
        accsId.add(objNew.Id);
    }

    if(!System.isFuture() && !System.isBatch())
            AnyLabelAutomation.anyLabelProcessAction(accsId);
}





//    List<Account> acc = new List<Account>();
//    List<String> labelsList = new List<String>();
//
//    List<AnyLabel__c> al = new List<AnyLabel__c>();
//    al = [SELECT Name FROM  AnyLabel__c WHERE Assignee__c = 'Account'];
//    for (Account objNew: Trigger.new) {
//        String field = objNew.Name;
//        for(Account objOld: trigger.old){
//            if (field != objOld.Name) {
//                labelsList.toString();
//                objNew.Labels__c += ';'+labelsList;
//            }
//        }
//    }

//}