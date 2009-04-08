
require 'branch_db/switcher'

module BranchDB
  VERSION = '0.0.1'
  DEFAULT_BRANCH = 'master'
  
  class Error < StandardError; end

  def self.current_repo_branch(raise_on_error = false)
    @current_repo_branch ||=
      begin
        raw = `git rev-parse --symbolic-full-name HEAD`
        if $? == 0
          raw.sub(%r{^refs/heads/}, '').chomp
        elsif raise_on_error
          raise Error, "Unable to determine the current repository branch."
        else
          # Don't raise an exception. We might be running in an exported copy.
          $stderr.puts %{Unable to determine the current repository branch, assuming "#{DEFAULT_BRANCH}".}
          DEFAULT_BRANCH
        end
      end
  end
end
