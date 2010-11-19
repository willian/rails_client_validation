require 'spec_helper'

describe RailsClientValidation::FormBuilder do
  describe '#jquery_validations' do
    before(:all) do
      @user = User.new
      @declarations = []
      @validations = { :rules => { "user[name]" => { "required" => true },
                                  "user[company]" => { "required" => true } },
                      :messages => { "user[email]" => { "required" => "Email can't be blank" },
                                     "user[company]" => { "required" => "Company can't be blank" } } }
    end
    
    it 'should return the JavaScript with jQuery Validator' do
      form_id = '#new_user, #user_new'
      
      subject.stub(:object).and_return(@user)
      subject.should_receive(:get_rails_form_id).with(nil).and_return(form_id)
      RailsClientValidation::JQuery.stub(:render_script).with(@user).and_return([@declarations, @validations])
      
      js = subject.jquery_validations.strip.gsub(/\s\s/, '')
      js.should == javascript_tag(form_id, @declarations, @validations).strip.gsub(/\s\s/, '')
    end
    
    it 'should return the JavaScript with jQuery Validator when user gives a custom form_id' do
      custom_form_id = 'new_user_profile'
      
      subject.stub(:object).and_return(@user)
      subject.should_receive(:get_rails_form_id).with(custom_form_id).and_return("##{custom_form_id}")
      RailsClientValidation::JQuery.stub(:render_script).with(@user).and_return([@declarations, @validations])
      
      js = subject.jquery_validations(custom_form_id).strip.gsub(/\s\s/, '')
      js.should == javascript_tag("##{custom_form_id}", @declarations, @validations).strip.gsub(/\s\s/, '')
    end
  end
  
  private
    def javascript_tag(form_id, declarations, validations)
      <<-EOF
        <script type="text/javascript">jQuery(function() {
          #{declarations}
          jQuery('#{form_id}').validate({
            rules: #{validations[:rules].to_json},
            messages: #{validations[:messages].to_json}
          });
        });\n</script>
      EOF
    end
end
