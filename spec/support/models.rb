class User
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :id, :name, :company, :company_id, :time_zone, :active, :description, :created_at, :updated_at,
    :credit_limit, :age, :password, :delivery_time, :born_at, :special_company_id, :country, :url, :tag_ids,
    :avatar, :email, :status, :residence_country, :phone_number

  def initialize(options={})
    options.each do |key, value|
      send("#{key}=", value)
    end if options
  end

  def new_record!
    @new_record = true
  end

  def persisted?
    !(@new_record || false)
  end

  def company_attributes=(*)
  end

  def column_for_attribute(attribute)
    column_type, limit = case attribute.to_sym
      when :name, :status, :password then [:string, 100]
      when :description   then :text
      when :age           then :integer
      when :credit_limit  then [:decimal, 15]
      when :active        then :boolean
      when :born_at       then :date
      when :delivery_time then :time
      when :created_at    then :datetime
      when :updated_at    then :timestamp
    end
    Column.new(attribute, column_type, limit)
  end

  def self.human_attribute_name(attribute)
    case attribute
      when 'name'
        'Super User Name!'
      when 'description'
        'User Description!'
      when 'company'
        'Company Human Name!'
      else
        attribute.humanize
    end
  end

  def self.reflect_on_association(association)
    case association
      when :company
        Association.new(Company, association, :belongs_to, {})
      when :tags
        Association.new(Tag, association, :has_many, {})
      when :first_company
        Association.new(Company, association, :has_one, {})
      when :special_company
        Association.new(Company, association, :belongs_to, { :conditions => { :id => 1 } })
    end
  end

  def errors
    @errors ||= begin
      hash = Hash.new { |h,k| h[k] = [] }
      hash.merge!(
        :name => ["can't be blank"],
        :description => ["must be longer than 15 characters"],
        :age => ["is not a number", "must be greater than 18"],
        :company => ["company must be present"],
        :company_id => ["must be valid"]
      )
    end
  end
  
  validates :name, :presence => true
  validates :company, :presence => true
end
