/**
 * Created by Adelchi on 08/05/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


trigger opportunity1 on Opportunity (before update, before insert) {
    Map<Id,Opportunity>  oldObj  =  Trigger.oldMap;
    Map<Id,Opportunity>  newObj  =  Trigger.newMap;
    if(Trigger.isInsert){
        for(Opportunity aNew : Trigger.new){
            System.debug('hello world ...');
        }
    }else if (Trigger.isUpdate){
        for(Opportunity aOld : Trigger.old){
            Opportunity objOld = Trigger.oldMap.get(aOld.Id);
            Opportunity objNew = Trigger.newMap.get(aOld.Id);
            String vOld = objOld.stagename;
            String vNew = objNew.stagename;
            system.debug(vOld==vNew);
            if(vNew=='Closed Won'){
                objNew.Labels__c += ';2 Urgent';
            }
        }
    }
}
