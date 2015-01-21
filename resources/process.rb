actions :start
default_action :start

attribute :process_name, :kind_of => String, :name_attribute => true
attribute :env_name, :kind_of => String
attribute :process_number, :kind_of => Integer

attr_accessor :exists
