({
    requestOrg : function(component) {
        this.showSpinner(component);

        const requestOrgAction = component.get("c.makeOrgRequest");
        const orgName = "Trial: " + component.get("v.DemoFields").Primary_Contact__r.Email;

        requestOrgAction.setParams({
            "orgName" : orgName
        });
        let orgId = 0;
        let responseCode = 0;
        requestOrgAction.setCallback(this, response => {
            if (response.getState() === "SUCCESS" && response.getReturnValue().responseCode === 201) {
                orgId = response.getReturnValue().orgId;
                responseCode = response.getReturnValue().responseCode;

                const email = component.get("v.DemoFields").Primary_Contact__r.Owner.Email;

                this.createUser(component, orgId, email, 8);
            } else {
                this.hideSpinner(component);

                let toast = $A.get("e.force:showToast");     
                toast.setParams({
                    "type" : "Error",
                    "message" : "Create org process failed, retry please"
                });

                toast.fire();
            }
        });

        $A.enqueueAction(requestOrgAction);
    },

    createUser : function(component, orgId, email, orgRoleId) {
        const createUserAction = component.get("c.createUserRequest");
        createUserAction.setParams({
            "orgId" : orgId,
            "email" : email
        });

        createUserAction.setCallback(this, response => {
            if (response.getState() === "SUCCESS" && response.getReturnValue().responseCode === 200) {
                if (orgRoleId === 8) {
                    this.getUserForMakingAdmin(component, orgId, email);
                }
            } else {
                this.hideSpinner(component);

                let toast = $A.get("e.force:showToast");     
                toast.setParams({
                    "type" : "Error",
                    "message" : "Create user process failed, retry please"
                });

                toast.fire();
            }
        });

        $A.enqueueAction(createUserAction);
            },

    getUserForMakingAdmin : function(component, orgId, email) {
        const getUserForMakingAdminAction = component.get("c.getUserForMakingAdminRequest");
        getUserForMakingAdminAction.setParams({
            "orgId" : orgId,
            "email" : email
        });

        let toast = $A.get("e.force:showToast");     
        let userId = 0;
        getUserForMakingAdminAction.setCallback(this, response => {
            if (response.getState() === "SUCCESS" && response.getReturnValue().responseCode === 200) {
                userId = response.getReturnValue().userId;
                this.makeUserAdmin(component, orgId, userId);
            } else {
                this.hideSpinner(component);

                let toast = $A.get("e.force:showToast");     
                toast.setParams({
                    "type" : "Error",
                    "message" : "Make user an admin process failed, retry please"
                });

                toast.fire();
            }

        });

        $A.enqueueAction(getUserForMakingAdminAction);
    },

    makeUserAdmin : function(component, orgId, userId) {
        const makeUserAdminAction = component.get("c.makeUserAdminRequest");

        makeUserAdminAction.setParams({
            "orgId" : orgId,
            "userId" : userId
        });

        makeUserAdminAction.setCallback(this, response => {
            if (response.getState() === "SUCCESS" && response.getReturnValue().responseCode === 200) {

                const email = component.get("v.DemoFields").Primary_Contact__r.Email;

                this.createUser(component, orgId, email, 9);

                this.copyWorkspace(component, orgId);
            } else {
                this.hideSpinner(component);

                let toast = $A.get("e.force:showToast");     
                toast.setParams({
                    "type" : "Error",
                    "message" : "Make user an admin process failed, retry please"
                });

                toast.fire();
               }

        });

        $A.enqueueAction(makeUserAdminAction);
    },
    
    copyWorkspace : function(component, orgId) {
        let now = new Date();
        let month = now.getMonth() + 1;
        if (month <= 9) {
            month = '0' + month;
        }

        let date = now.getDate();
        if (date <= 9) {
            date = '0' + date;
        }

        let hours = now.getHours();
        if (hours <= 9) {
            hours = '0' + hours;
        }

        let minutes = now.getMinutes();
        if (minutes <= 9) {
            minutes = '0' + minutes;
        }

        let seconds = now.getSeconds();
        if (seconds <= 9) {
            seconds = '0' + seconds;
        }

        let timeStamp = now.getFullYear() + '-' + month + '-' + date + ' ' +
                            hours + ':' + minutes + ':' + seconds;

        let workspaceName = 'Getting Started with Your Free Trial [' + timeStamp + ']';

        const copyWorkspaceAction = component.get("c.copyWorkspaceRequest");
        copyWorkspaceAction.setParams({
            workspaceName : workspaceName
        });

        copyWorkspaceAction.setCallback(this, response => {
            if (response.getState() === "SUCCESS" && response.getReturnValue().responseCode === 200) {

                setTimeout(() => {
                    this.getNewWorkspaceId(component, orgId, workspaceName);
                }, 3000)


            } else {
                this.hideSpinner(component);

                let toast = $A.get("e.force:showToast");     
                toast.setParams({
                    "type" : "Error",
                    "message" : "Copy workspace process failed, retry please"
                });

                toast.fire();
            }

        });

        $A.enqueueAction(copyWorkspaceAction);
    },
    
    getNewWorkspaceId : function(component, orgId, workspaceName) {
        let workspaceId = 0;
        const getNewWorkspaceIdAction = component.get("c.getNewWorkspaceIdRequest");
        getNewWorkspaceIdAction.setParams({
            workspaceName : workspaceName
        });

        getNewWorkspaceIdAction.setCallback(this, response => {
            if (response.getState() === "SUCCESS" && response.getReturnValue().responseCode === 200) {
                workspaceId = response.getReturnValue().workspaceId;

                this.moveWorkspaceToOrg(component, orgId, workspaceId);
            } else {
                this.hideSpinner(component);

                let toast = $A.get("e.force:showToast");     
                toast.setParams({
                    "type" : "Error",
                    "message" : "Move workspace to the org process failed, retry please"
                });

                toast.fire();
           }

        });

        $A.enqueueAction(getNewWorkspaceIdAction);
    },
    
    moveWorkspaceToOrg : function(component, orgId, workspaceId) {
        const moveWorkspaceToOrgAction = component.get("c.moveWorkspaceToOrgRequest");

        moveWorkspaceToOrgAction.setParams({
            "orgId" : orgId,
            "workspaceId" : workspaceId
        });

        let toast = $A.get("e.force:showToast");     

        moveWorkspaceToOrgAction.setCallback(this, response => {
            this.hideSpinner(component);

            if (response.getState() === "SUCCESS" && response.getReturnValue().responseCode === 200) {
                toast.setParams({
                    "type" : "Success",
                    "message" : "Org was created"
                });
            } else {
                let toast = $A.get("e.force:showToast");     
                toast.setParams({
                    "type" : "Error",
                    "message" : "Move workspace to the org process failed, retry please"
                });
            }

            toast.fire();
        });

        $A.enqueueAction(moveWorkspaceToOrgAction);
    },

    showSpinner : function(component) {
        $A.util.removeClass(component.find('spinner'), 'slds-hide');
    },

    hideSpinner : function(component) {
        $A.util.addClass(component.find('spinner'), 'slds-hide');
    }

})