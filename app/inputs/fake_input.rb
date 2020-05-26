# This is a custom class for simple form
# it allows to create 'fake' (hidden) input, non related to models in simple forms
# doc: https://github.com/heartcombo/simple_form/wiki/Create-a-fake-input-that-does-NOT-read-attributes

# Currently used in the view/devise/registrations/edit.html.erb file
# to pass a custom 'order_edit' params that allows us to trigger specific actions in the edit controller method

class FakeInput < SimpleForm::Inputs::StringInput
  # This method only create a basic input without reading any value from object
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    template.hidden_field_tag(attribute_name, nil, merged_input_options)
  end
end
