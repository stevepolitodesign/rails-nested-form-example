# Rails Nested Form Example

A guide to adding [fields on the fly](https://guides.rubyonrails.org/form_helpers.html#adding-fields-on-the-fly) in a [nested form](https://guides.rubyonrails.org/form_helpers.html#building-complex-forms) using Rails 6.

Inspired by [cocoon](https://github.com/nathanvda/cocoon) and [Ryan Bates](http://railscasts.com/episodes/196-nested-model-form-revised).

## 1. Configuring the Model

```ruby
class Person < ApplicationRecord
    has_many :addresses, inverse_of: :person
    accepts_nested_attributes_for :addresses, allow_destroy: true, reject_if: :all_blank
end
```

## 2. Declare the Permitted Parameters 

```ruby
class PeopleController < ApplicationController
    ...
    private

        def person_params
            params.require(:person).permit(:first_name, :last_name, addresses_attributes: [:id, :kind, :street, :_destroy])
        end
end
```

## 3. Create a Form Partial

```erb
<%# app/views/people/_address_fields.html.erb %>
<div class="nested-fields">
    <%= f.hidden_field :_destroy %>
    <div>
        <%= f.label :kind %>
        <%= f.text_field :kind %>
    </div>
    <div>
        <%= f.label :street %>
        <%= f.text_field :street %>
    </div>
    <div>
        <%= link_to "Remove", '#', class: "remove_fields" %>
    </div>
</div>
```

```erb
<%# app/views/people/_form.html.erb %>
<%= form_with model: @person, local: true do |f| %>
    ...
    <fieldset>
        <legend>Addresses:</legend>
        <%= f.fields_for :addresses do |addresses_form| %>
            <%= render "address_fields", f: addresses_form %> 
        <% end %>
        <%= link_to_add_fields "Add Addresses", f, :addresses %>
    </fieldset>

    <%= f.submit %>
<% end %>
```

## 4. Create a Helper Function

```ruby
# app/helpers/application_helper.rb
module ApplicationHelper
    def link_to_add_fields(name, f, association)
        new_object = f.object.send(association).klass.new
        id = new_object.object_id
        fields = f.fields_for(association, new_object, child_index: id) do |builder|
            render(association.to_s.singularize + "_fields", f: builder)
        end
        link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")}) 
    end
end
```

## 5. Add Javascript

```javascript
// app/javascript/packs/nested-forms/addFields.js
class addFields {
    constructor(){
        this.links = document.querySelectorAll('.add_fields');
        this.iterateLinks();
    }

    iterateLinks() {
        if(this.links.length === 0) return;
        this.links.forEach((link)=>{
            link.addEventListener('click', (e) => {
                this.handleClick(link, e);
            });
        });
    }

    handleClick(link, e) {
        if (!link || !e) return;
        e.preventDefault();
        let time = new Date().getTime();
        let linkId = link.dataset.id;
        let regexp = linkId ? new RegExp(linkId, 'g') : null ;
        let newFields = regexp ? link.dataset.fields.replace(regexp, time) : null ;
        newFields ? link.insertAdjacentHTML('beforebegin', newFields) : null ;
    }

}

window.addEventListener('turbolinks:load', () => new addFields() );
```

```javascript
// app/javascript/packs/nested-forms/removeFields.js
class removeFields {

    constructor(){
        this.links = document.querySelectorAll('.remove_fields');
        this.iterateLinks();
    }

    iterateLinks() {
        if(this.links.length === 0) return;
        this.links.forEach((link)=>{
            link.addEventListener('click', (e) => {
                this.handleClick(link, e);
            });
        });
    }

    handleClick(link, e) {
        if (!link || !e) return;
        e.preventDefault();
        let fieldParent = link.closest('.nested-fields');
        let deleteField = fieldParent ? fieldParent.querySelector('input[type="hidden"]') : null
        if (deleteField) {
            deleteField.value = 1;
            fieldParent.style.display = 'none';
        }
    }

}

window.addEventListener('turbolinks:load', () => new removeFields() );
```

```javascript
// app/javascript/packs/application.js
require("./nested-forms/addFields");
require("./nested-forms/removeFields");
```
