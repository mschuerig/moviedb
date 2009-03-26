puts "***** RENDERING: #{award.inspect}"
aw = {
  :id => award.to_param,
  :name => award.name
}
unless award.children.empty?
  aw[:awards] = award.children.map { |a| render :partial => 'awards/award.json.rb', :object => a }
end
aw
