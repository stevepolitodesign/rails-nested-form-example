class removeFields {
    
    // This executes when the function is instantiated.
    constructor(){
        this.links = document.querySelectorAll('.remove_fields');
        this.iterateLinks();
    }

    iterateLinks() {
        // If there are no links on the page, stop the function from executing.
        if(this.links.length === 0) return;
        // Loop over each link on the page.
        this.links.forEach((link)=>{
            link.addEventListener('click', (e) => {
                this.handleClick(link, e);
            });
        });
    }

    handleClick(link, e) {
        // Stop the function from executing if a link or event were not passed into the function. 
        if (!link || !e) return;
        // Prevent the browser from following the URL.
        e.preventDefault();
        // Find the parent wrapper for the set of nested fields. 
        let fieldParent = link.closest('.nested-fields');
        // If there is a parent wrapper, find the hidden delete field.
        let deleteField = fieldParent ? fieldParent.querySelector('input[type="hidden"]') : null
        // If there is a delete field, update the value to `1` and hide the corresponding nested fields.
        if (deleteField) {
            deleteField.value = 1;
            fieldParent.style.display = 'none';
        }
    }

}

// Wait for turbolinks to load, otherwise `document.querySelectorAll()` won't work 
window.addEventListener('turbolinks:load', () => new removeFields() );
