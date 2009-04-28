path = awarding_path(awarding)
{ 
  :id    => path,
  '$ref' => path,
  :title => awarding.name,
  :award => { '$ref' => award_path(awarding.award) }
}
