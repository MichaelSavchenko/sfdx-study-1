@isTest
public class AccountSearchControllerTest {

    @IsTest
    static void methodName(){
        Test.startTest();
        List<SObject> result = AccountSearchController.searchAccounts('test');
        //break
        System.assert(!result.isEmpty(), 'message');
        Test.stopTest();
    }
}
