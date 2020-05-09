/**
 * Created by Adelchi on 08/05/2020.
 * Purpose : (Write a succinct description of this class here.)
 */


@IsTest
private class  Opportunity1Test {
    static testMethod void run() {
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        Contract a = New Contract();
        a.Status = 'Draft' ;
        a.AccountId = acc.Id;
        a.StartDate = Date.today();
        a.ContractTerm = 12;
        insert a;
    }
}
