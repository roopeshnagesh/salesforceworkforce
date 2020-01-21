trigger TotangoEntitlementUpdate on Entitlement (after insert, after update) {
	
    Set<String> updatedAcctIds = new Set<String>();
    
    for (Entitlement e : Trigger.new)
    {
        updatedAcctIds.add(e.AccountId);
    }
    
    for (String accountId : updatedAcctIds)
    {
        TotangoAccountDerivedCalculator.updateTotangoDerivedFields_Entitlements(accountId);
    }
}