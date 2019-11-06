class addFields {
    constructor(){
        this.links = document.querySelectorAll('.add_fields');
        this.iterateLinks();
    }

    iterateLinks() {
        // If there are no links, stop the function from running.
        if(this.links.length === 0) {
            return;
        }
        this.links.forEach((link)=>{
            link.addEventListener('click', (e) => {
                // Prevent a click.
                e.preventDefault();
                // Save a unique timestamp to ensure the key of the associated array is unique.
                let time = new Date().getTime();
                // Save the data id attribute into a variable. This corresponds to `new_object.object_id`.
                let linkId = link.dataset.id;
                // Create a new regular expression needed to find any instance of the `new_object.object_id` used in the fields data attribute.
                let regexp = new RegExp(linkId, 'g');
                // Replace all instances of the `new_object.object_id` with `time`, and save markup into a variable.
                let newFields = link.dataset.fields.replace(regexp, time);
                // Add the new markup to the form.
                link.insertAdjacentHTML('beforebegin', newFields);
            });
        });
    }

}

// Wait for turbolinks to load, otherwise `document.querySelectorAll()` won't work 
window.addEventListener('turbolinks:load', () => new addFields() );
