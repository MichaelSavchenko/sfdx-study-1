@isTest
public class AccountSearchControllerTest {

    @IsTest
    static void methodName(){
        Test.startTest();
        List<Account> result = AccountSearchController.searchAccounts('test')[0];
        System.assert(result.isEmpty(), 'message');
        Test.stopTest();
    }
}
