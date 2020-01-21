({
	createAdminUserInBluescape : function(component, event) {
	    const orgId = component.get('v.sObjectRecord').Org_Id__c;

        if ($A.util.isEmpty(orgId)) {
            this.showToast(component, event, 'warning', 'Waring!', 'You can\'t create Admin User when Org Id field is empty', 'sticky');

            return;
        }

        $A.util.removeClass(component.find('spinner'), 'slds-hide');

        const recordId = component.get('v.recordId');
        const action = component.get('c.createExtraAdminUserInBluescape');
        action.setParams({
            orgId : parseInt(orgId),
            recordId : recordId
        })
        action.setCallback(this, (response) => {
            if (response.getState() === 'SUCCESS') {
            	this.showToast(component, event, 'success', 'Success!', 'New Admin User was successfully created', 'dismissible');
				$A.get('e.force:refreshView').fire();
        	} else {
        	    response.getError().forEach((error)=>{
                    if (error.message.indexOf('User is already in the organization') !== -1) {
                        this.showToast(component, event, 'error', 'Error!', 'You are already in this Organization', 'sticky');
                    } else {
                        let msg = error.message.split('{').join('');
                        msg = msg.split('}').join('');
            
                        this.showToast(component, event, 'error', 'Error!', msg, 'sticky');
                    }
                })
            }
            $A.util.addClass(component.find('spinner'), 'slds-hide');
        })
        
        $A.enqueueAction(action);
	},
    
    showToast : function(component, event, type, title, message, mode) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode : mode,
            type : type,
            title : title,
            message: message
        });
        toastEvent.fire();
    }
})