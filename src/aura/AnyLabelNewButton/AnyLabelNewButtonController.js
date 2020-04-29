/**
 * Created by Adelchi on 20/04/2020.
 */

({
    doInit : function(component, event, helper) {
        let getAllSObjects = component.get("c.getSObjectList");
        getAllSObjects.setCallback(this, (response) => {
            let state = response.getState();
            if (state === "SUCCESS") {
                let objectsList = response.getReturnValue();
                let options = [];
                for(let i=0; i<objectsList.length; i++){
                    options.push({label: objectsList[i], value: objectsList[i]});
                };
                component.set("v.assign", options);
            }else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(getAllSObjects);
    },

    assignObjects: function(component, event, helper){
        let assObjTmp = [];
        for(let i=0; i<event.getParams().value.length; i++){
            assObjTmp.push(event.getParams().value[i]);
        }
        component.set("v.assignedObjects", assObjTmp);
        let v =component.get("v.assignedObjects")
        console.log('..... '+v);
        console.log(v);

    },

    setFontColor: function(component, event, helper){
        let val =  component.get("v.bckColor");
        console.log(val);
        component.set("v.fntColor", helper.getContrastYIQ(val));
        console.log(component.get("v.fntColor"));
    },

    handleSaveSuccess : function(component, event, helper){
        // $A.get("e.force:closeQuickAction").fire();
        // helper.editingStatus(component);
        // helper.onDestroy(component, event, helper);
    },

    saveLabel: function(component, event, helper) {
        let fc = component.get("v.fntColor");
        let bc = component.get("v.bckColor");
        let n = document.getElementById("labelName").value;
        let o = component.get("v.assignedObjects");
        if(fc!=''&&fc!=null&&bc!=''&&bc!=null&&n!=''&&n!=null&&o!=''&&o!=null){
            let saveLabel = component.get('c.NewLabelMultiAssign');
            saveLabel.setParams({
                objectNames: o,
                fc: fc,
                bc: bc,
                n : n
            });
            saveLabel.setCallback(this, function(response){
                if(response.getState()==='SUCCESS'){
                    let toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"Success",
                        "message": "New Label created successfully."
                    });
                    toastEvent.fire();

                    let homeEvent = $A.get("e.force:navigateToObjectHome");
                    homeEvent.setParams({
                        "scope": "AnyLabel__c"
                    });
                    homeEvent.fire();
                }
            });
            $A.enqueueAction(saveLabel);
        }else{
            let toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"Error",
                "message": "Make sure ALL fields are filled with valid a input.",
                "mode": "sticky"
            });
            toastEvent.fire();
        }
    },

    closing: function(component, event, helper) {
        let homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "AnyLabel__c"
        });
        homeEvent.fire();
    },

    destroyUnchanged: function(component, event, helper) {
        console.log("destroying ....");
        // helper.onDestroy(component);
    },
});