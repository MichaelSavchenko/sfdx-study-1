({
    handleSearch : function(component) {
        let action = component.get("c.searchAccounts");
        action.setParams({
            searchTerm: component.get("v.searchTerm")
        });

        action.setCallback(this, function(response){
            let accounts = response.getReturnValue();
            let event = $A.get("e.c:AccountsLoaded");
            event.setParams({
                accounts: accounts
            });

            event.fire();
        });

        $A.enqueueAction(action);
    }
})
