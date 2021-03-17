@isTest
public class AccountSearchControllerTest {

    @IsTest
    static void methodName(){
        Test.startTest();
        List<Account> result = AccountSearchController.searchAccounts('test');
        System.assert(result.isEmpty(), 'message');
        Test.stopTest();
    }
}
