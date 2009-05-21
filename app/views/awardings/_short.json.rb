{
  '$ref' => awarding_path(awarding),
  :title => awarding.name,
  :year  => awarding.year,
  :award => { '$ref' => award_path(awarding.award) }
}
