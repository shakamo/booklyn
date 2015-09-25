# == Schema Information
#
# Table name: errors
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  url         :text
#  created_at  :datetime
#  updated_at  :datetime
#
class Error < ActiveRecord::Base
  after_initialize :set_default_value, if: :new_record?

  def set_default_value
    self.name = class_name + ':' + method_name
  end

  def class_name
    caller_locations(14).first.path.scan(%r{.*\/(.*)[.]rb$}).join
  end

  def method_name
    caller_locations(14).first.label
  end
end
