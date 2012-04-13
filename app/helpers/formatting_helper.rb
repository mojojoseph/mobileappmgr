module FormattingHelper

  def formatted_uploaded_date(mobileapp)
    from_yaml = mobileapp['uploaded']
    from_yaml.gsub!('---','') and from_yaml.gsub!("'",'')
  end

end