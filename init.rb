require 'rails_client_validation'

# Hook into the default form builder
ActionView::Helpers::FormBuilder.send :include, RailsClientValidation::FormBuilder
