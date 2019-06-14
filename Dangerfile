# Helper functions and variables

def is_dir_modified(dir)
    return !git.modified_files.grep(/#{Regexp.quote(dir)}/).empty?
end

declared_trivial = github.pr_title.include? "#trivial"

# --- Branching Strategy

def catch_branching_strategy_violations
    failure("Features should be based from, and merged into, release branches") unless github.branch_for_base.include? "release"
end

# --- Basic PR Checks

def perform_basic_pr_checks
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

    ["Eurofurence.xcodeproj"].each do |project_file|
        next unless File.file?(project_file)

        File.readlines(project_file).each_with_index do |line, index|
            if line.include?("sourceTree = SOURCE_ROOT;") and line.include?("PBXFileReference")
                warn("Files should be in sync with project structure", file: project_file, line: index+1)
            end
        end
    end
end

# --- Test Quality

def catch_untested_code
    if is_dir_modified("Eurofurence") && !is_dir_modified("EurofurenceTests")
        warn("The app was modified but no tests were changed. Make sure new behaviour is documented with tests. If you were refactoring or working in the view tier then ignore this message")
    end

    if is_dir_modified("EurofurenceModel") && !is_dir_modified("EurofurenceModelTests")
        warn("The model was modified but no tests were changed. Make sure new behaviour is documented with tests. If you were refactoring then ignore this message")
    end
end

# --- Automating Swift Code Review

def perform_swift_code_review_on_file(file)
    is_model_file = file =~ /EurofurenceModel/

    filelines = File.readlines(file)
    filelines.each_with_index do |line, index|

        if line.include?("override") and line.include?("func") and filelines[index+1].include?("super") and filelines[index+2].include?("}")
            warn("Override methods which only call super can be removed", file: file, line: index+3)
        end

        if line =~ /^\/\/([^\/]|$)/ and !line.include?("MARK:")
            warn("Comments should be avoided - express intent in proper names and functions", file: file, line: index)
        end

        if line =~ /.text = \"(.)+/ || line =~ /setTitle\(\"(.)+/
            warn("User facing strings set in code should use NSLocalizedString", file: file, line: index)
        end

        # Model specific stuff

        if is_model_file && line.include?("UIKit")
            fail("The model cannot depend on UIKit - invert the dependency on the framework", file: file, line: index)
        end

    end
end

def perform_swift_code_review
    files_to_check = (git.modified_files + git.added_files).uniq
    (files_to_check - %w(Dangerfile)).each do |file|
        next unless File.file?(file)
        next unless File.extname(file).include?(".swift")

        perform_swift_code_review_on_file(file)
    end

    swiftlint.lint_files
end

# ---

catch_branching_strategy_violations
perform_basic_pr_checks
catch_untested_code
perform_swift_code_review
