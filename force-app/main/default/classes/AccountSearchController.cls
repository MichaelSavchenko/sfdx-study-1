public with sharing class AccountSearchController {
    @AuraEnabled
    public static List<Account> searchAccounts(String searchTerm){
        try {
            
            List<Account> result = new List<Account>();
            if (String.isNotBlank(searchTerm)) {
                List<List<SObject>> searchResults = 
                [FIND :searchTerm
                RETURNING Account(Id, Name, Phone, Website, BillingStreet, BillingCity, BillingState, BillingPostalCode
                ORDER BY Name
                LIMIT 10)
                ];

                result = searchResults[0];
            }

            return result;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
