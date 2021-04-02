@isTest
public class AccountSearchControllerTest {

    @IsTest
    static void methodName(){
        Test.startTest();
        List<SObject> result = AccountSearchController.searchAccounts('test');
        System.assert(result.isEmpty(), 'should be empty');
        Test.stopTest();
    }
}
