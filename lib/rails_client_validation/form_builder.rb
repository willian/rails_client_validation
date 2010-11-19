module RailsClientValidation
  module FormBuilder
    extend ActionView::Helpers::TagHelper
    class << self
      def jquery_validations(custom_form_id = nil)
        form_id = get_rails_form_id(custom_form_id)
      
        declarations, validations = RailsClientValidation::JQuery.render_script(object)
        js = <<-EOF
          jQuery(function() {
            #{declarations}
            jQuery('#{form_id}').validate({
              rules: #{validations[:rules].to_json},
              messages: #{validations[:messages].to_json}
            });
          });
        EOF
        
        content_tag(:script, js.html_safe, :type => "text/javascript").html_safe
      end
    
      private
        def get_rails_form_id(custom_form_id)
          return "##{custom_form_id}" if custom_form_id
          if object.new_record?
              rails_form_id = "new_#{object.class.model_name.singular}"
              simple_form_id = "#{object.class.model_name.singular}_new" # For SimpleForm plugin
            else
              rails_form_id = "edit_#{object.class.model_name.singular}_#{object.to_param}"
              simple_form_id = "#{object.class.model_name.singular}_#{object.to_param}_edit" # For SimpleForm plugin
          end
          "##{rails_form_id}, ##{simple_form_id}"
        end
    end
  end
end