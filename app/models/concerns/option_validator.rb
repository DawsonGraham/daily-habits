class OptionValidator < ActiveModel::Validator
  def validate(record)
    errors.add_to_base “one answer type is required” if !record.text && !record.integer && !record.boolean
  end
end