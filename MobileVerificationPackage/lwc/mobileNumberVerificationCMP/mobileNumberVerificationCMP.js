import { LightningElement,api, wire } from 'lwc';

import getDetails from '@salesforce/apex/MobileNumberVerificationController.mobileNumberVerificationAPICall';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MobileNumberVerificationCMP extends LightningElement {
    @api recordId;
    isLoading = false; // spinner will show in default
   
    connectedCallback() {
        this.isLoading = true;
        console.log('recordId '+this.recordId);
        getDetails({
            recordID: this.recordId
        }).then(data => {
            if(data=='Mobile Number Verified'){
                this.showSucessNotification('Mobile Number Verified');
                this.handleCancel();
                window.location.reload();
            }
            else{
                this.isLoading = false;
                this.showErrorNotification(data);
            }
           
        }).catch(error => {
            this.isLoading = false;
           this.showErrorNotification(error);
        });
    }
     // method to show default success notification
    showSucessNotification(message) {
        this.showToast({
            message,
            variant: 'success',
            mode: 'dismissible'
        });
    }
    // method to show error methods
    showErrorNotification( message) {
        this.showToast({
            message,
            variant: 'error',
            mode: 'dismissible'
        });
    }
    // generic method to show toast.
    showToast(params) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: params.title,
                message: params.message,
                variant: params.variant,
                mode: params.mode
            })
        );
    }
    // method to close the qucik action modal
    handleCancel() {
        this.dispatchEvent(new CustomEvent('closeModal'));
        this.dispatchEvent(new CustomEvent('closecancel',{}));
    }
}