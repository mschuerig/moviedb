view = {
  :id        => award_path(award),
  :name      => award.name,
  :awardings => { '$ref' => award_awardings_path(award) }
}
if award.parent
  view[:group] = { '$ref' => award_path(award.parent) }
end
if award.children.size > 0
  view[:children] = award.children.map { |a| render :partial => 'awards/award.json.rb', :object => a }
end
view
