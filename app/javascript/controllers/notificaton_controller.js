import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notificaton"
export default class extends Controller {
    connect() {
        this.notifications = [];
    }

    addNotification(message, type = "info") {
        this.notifications.push({ message, type });

        // Show the notification immediately if no other notifications are visible
        if (this.notifications.length === 1) {
            this.showNotification();
        }
    }

    // Method to show the next notification in the queue
    showNotification() {
        if (this.notifications.length === 0) {
            return; // No more notifications to show
        }

        const { message, type } = this.notifications[0];

        const toastMessage = document.createElement('div');
        toastMessage.classList.add('toast-message');
        toastMessage.textContent = message;

        if (type === 'success') {
            toastMessage.classList.add('success');
        } else if (type === 'error') {
            toastMessage.classList.add('error');
        } else if (type === 'warning') {
            toastMessage.classList.add('warning');
        } // Add more classes for other notification types if needed

        this.element.appendChild(toastMessage);

        // Trigger a reflow (read-write cycle) to apply CSS transition
        // This is necessary to initiate the sliding animation
        void toastMessage.offsetWidth;

        // Show the toast with the sliding animation
        toastMessage.style.opacity = '1';
        toastMessage.style.transform = 'translateX(0)';

        // Auto hide after 3 seconds (adjust the timeout as needed)
        setTimeout(() => {
            this.hideNotification(toastMessage);
        }, 3000);
    }

    // Method to hide the current notification
    hideNotification(toastMessage) {
        // Hide the toast with the sliding animation
        toastMessage.style.opacity = '0';
        toastMessage.style.transform = 'translateX(100%)';

        // Remove the hidden toast from the container and the queue
        toastMessage.addEventListener('transitionend', () => {
            this.element.removeChild(toastMessage);
            this.notifications.shift();

            // Show the next toast in the queue, if any
            this.showNotification();
        });
    }
}

