aw = {
  :id        => award.to_param,
  :name      => award.name,
  :awardings => { '$ref' => award_awardings_path(award) }
}
unless award.children.empty?
  aw[:awards] = award.children.map { |a| render :partial => 'awards/award.json.rb', :object => a }
end
aw
