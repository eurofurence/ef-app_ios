# Helper functions and variables

def is_dir_modified(dir)
    return !git.modified_files.grep(/#{Regexp.quote(dir)}/).empty?
end

declared_trivial = github.pr_title.include? "#trivial"

# Catch branching strategy violations
failure("Features should be based from, and merged into, release branches") unless github.branch_for_base.include? "release"

# Basic PR status checks

has_wip_label = github.pr_labels.any? { |label| label.include? "WIP" }
has_wip_title = github.pr_title.include? "[WIP]"

if has_wip_label || has_wip_title
    warn("PR is classed as Work in Progress")
end

warn("This Pull Request is pretty big. Consider breaking the work down into smaller changes next time") if git.lines_of_code > 500
warn("Please add a short summary about the change you have made in the Pull Request description") unless github.pr_body.length > 10

# Prefer rebasing in-progress features onto the destination branch rather than polluting the history
if git.commits.any? { |c| c.message =~ /^Merge branch '#{github.branch_for_base}'/ }
    fail("Please rebase to get rid of the merge commits in this PR")
end

# Application Specific Checks

if is_dir_modified(Eurofurence) && !is_dir_modified(EurofurenceTests)
    warn("Application code has been modified without any changes to the tests - if this PR was for refactoring then ignore this message, otherwise consider backfilling tests for your solution")
end

# Model Specific Checks

if is_dir_modified(EurofurenceModel) && !is_dir_modified(EurofurenceModel)
    warn("Application code has been modified without any changes to the tests - if this PR was for refactoring then ignore this message, otherwise consider backfilling tests for your solution")
end

# Automating Swift Code Review

files_to_check = (git.modified_files + git.added_files).uniq
(files_to_check - %w(Dangerfile)).each do |file|
    next unless File.file?(file)
    next unless File.extname(file).include?(".swift")

    filelines = File.readlines(file)
    filelines.each_with_index do |line, index|

        if line.include?("unowned self")
            warn("Use weak instead of unowned when capturing self", file: file, line: index+1)
        end

        if line.include?("override") and line.include?("func") and filelines[index+1].include?("super") and filelines[index+2].include?("}")
            warn("Override methods which only call super can be removed", file: file, line: index+3)
        end

    end
end
