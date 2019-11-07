

module ApplicationHelper

    # This method create a link with `data-id` `data-fields` attributes. These attributes are used to create new instances of the nested fields through Javascript.
    def link_to_add_fields(name, f, association)

        # Takes an object (@person) and creates a new instance of its associated model (:addresses)
        # To better understand, run the following in your terminal:
        # rails c --sandbox
        # @person = Person.new
        # new_object = @person.send(:addresses).klass.new
        new_object = f.object.send(association).klass.new

        # Saves the unique ID of the object into a variable. 
        # This is needed to ensure the key of the associated array is unique. This is makes parsing the content in the `data-fields` attribute easier through Javascript.
        # We could use another method to achive this.
        id = new_object.object_id

        # https://api.rubyonrails.org/ fields_for(record_name, record_object = nil, fields_options = {}, &block) 
        # record_name = :addresses
        # record_object = new_object
        # fields_options = { child_index: id }
            # 1child_index` is used to ensure the key of the associated array is unique, and that it matched the value in the `data-id` attribute.
            # `person[addresses_attributes][child_index_value][_destroy]`
        fields = f.fields_for(association, new_object, child_index: id) do |builder|
            
            # `association.to_s.singularize + "_fields"` ends up evaluating to `address_fields`
            # The render function will then look for `views/people/_address_fields.html.erb`
            # The render function also needs to be passed the value of 'builder', because `views/people/_address_fields.html.erb` needs this to render the form tags.
            render(association.to_s.singularize + "_fields", f: builder)
        end

        # This renders a simple link, but passes information into `data` attributes.
            # This info can be named anything we want, but in this case we chose `data-id:` and `data-fields:`.
        # The `id:` is from `new_object.object_id`.
        # The `fields:` are rendered from the `fields` blocks.
            # We use `gsub("\n", "")` to remove anywhite space from the rendered partial.
        # The `id:` value needs to match the value used in `child_index: id`.
        link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
        
    end
end
