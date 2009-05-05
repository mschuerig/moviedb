@award_groups.map { |a|
  render(:partial => 'awards/award.json.rb', :object => a)
}
