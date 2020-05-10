trigger AnyLabelTrigger20_05_09_14_53 on Account (before update, before insert) {
    Map<Id,Account>  oldObj  =  Trigger.oldMap;
    Map<Id,Account>  newObj  =  Trigger.newMap;
    List<String> labList = new List<String>();
    List<String> labListDrt = new List<String>();
    String s = '(Label nr.S10, Label nr.S11, Label nr.S12)'.remove(')').remove('(');
    labListDrt = s.split(',');
    system.debug(labListDrt);
    for(String str : labListDrt){
        if(!str.startsWith(' ')){
            labList.add(str);
        }else{
            labList.add(str.removeStart(' '));
        }
    }
    if(Trigger.isInsert){
        for(Account aNew : Trigger.new){
        System.debug('hello world ...');
        }
    }else if (Trigger.isUpdate){
        for(Account aOld : Trigger.old){
            Account rec = [SELECT Labels__c FROM Account WHERE Id =: aOld.Id];
            system.debug(rec.Labels__c);
            Account objOld = Trigger.oldMap.get(aOld.Id);
            Account objNew = Trigger.newMap.get(aOld.Id);
            String vOld = objOld.billingcountry;
            String vNew = objNew.billingcountry;
            System.debug(vNew);
            if(vNew.startsWith('U')){
                System.debug(vNew.startsWith('U'));
                if(labList.size()>1){
                    System.debug(labList.size());
                    if(rec.Labels__c==null){
                        System.debug(rec.Labels__c);
                        objNew.Labels__c = '';
                        System.debug(rec.Labels__c);
                        for(String sString : labList){
                            System.debug(sString);
                            System.debug(objNew.Labels__c);
                            objNew.Labels__c += sString+';';
                        }
                    }else if(rec.Labels__c!=null){                        
                        for(String sString : labList){
                            if(!rec.Labels__c.contains(sString)){
                            	objNew.Labels__c += ';'+sString;                                
                            }
                        }
                    }
                }else{
                    objNew.Labels__c += 'Label nr.S10';
                }
            }
        }
    }
}