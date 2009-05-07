path = awarding_path(awarding)
{
  :id    => path,
  '$ref' => path,
  :title => awarding.name,
  :year  => awarding.year,
  :award => { '$ref' => award_path(awarding.award) }
}
