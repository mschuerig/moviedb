aw = {
  :id        => award.to_param,
  :name      => award.name,
}
if award.awardable?
  aw[:awardings] = { '$ref' => award_awardings_path(award) }
end
unless award.children == []
  aw[:children] = award.children.map { |a| render :partial => 'awards/award.json.rb', :object => a }
end
aw
