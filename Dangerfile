# Helper functions and variables

def is_dir_modified(dir)
    dir_regex = /#{Regexp.quote(dir)}\//
    modified_dir = !git.modified_files.grep(dir_regex).empty?
    added_to_dir = !git.added_files.grep(dir_regex).empty?
    
    return modified_dir || added_to_dir
end

declared_trivial = github.pr_title.include? "#trivial"

# --- Git Hygine

def perform_git_hygiene_checks
    # Prefer rebasing in-progress features onto the destination branch rather than polluting the history
    
    if git.commits.any? { |c| c.message =~ /^Merge branch '#{github.branch_for_base}'/ }
        fail("Please rebase to get rid of the merge commits in this PR")
    end
end

# --- Basic PR Checks

def perform_basic_pr_checks
    has_wip_label = github.pr_labels.any? { |label| label.include? "WIP" }
    has_wip_title = github.pr_title.include? "[WIP]"

    if has_wip_label || has_wip_title
        warn("PR is classed as Work in Progress")
    end

    warn("This PR is pretty big. Consider breaking the change down into smaller slices") if git.lines_of_code > 1000
    warn("Please add a short summary about the change you have made in the PR description") unless github.pr_body.length > 10

    File.readlines("Eurofurence.xcodeproj/project.pbxproj").each_with_index do |line, index|
        if line.include?("sourceTree = SOURCE_ROOT;") and line.include?("PBXFileReference")
            warn("Files should be in sync with project structure", file: project_file, line: index+1)
        end
    end
end

# --- Test Quality

def catch_untested_code
    if is_dir_modified("Eurofurence") && !(is_dir_modified("EurofurenceTests") || is_dir_modified("EurofurenceUITests"))
        warn("The app target was modified but no tests were changed")
    end
    
    if is_dir_modified("Packages/EurofurenceApplication/Sources") && !is_dir_modified("Packages/EurofurenceApplication/Tests")
        warn("The app logic package was modified but no tests were changed")
    end

    model_tests_changed = is_dir_modified("Packages/EurofurenceModel/Tests")
    if is_dir_modified("Packages/EurofurenceModel/Sources") && !model_tests_changed
        warn("The model was modified but no tests were changed")
    end
    
    if model_tests_changed && !is_dir_modified("Packages/EurofurenceModel/Sources/XCTEurofurenceModel")
        message("Model changes detected - if any behavioural contracts have changed make sure to update the corresponding test doubles")
    end
end

# --- Automating Swift Code Review

def perform_swift_code_review_on_file(file)
    is_model_file = file =~ /EurofurenceModel/

    filelines = File.readlines(file)
    filelines.each_with_index do |line, index|

        if line.include?("override") and line.include?("func") and filelines[index+1].include?("super") and filelines[index+2].include?("}")
            warn("Override methods which only call super can be removed", file: file, line: index+1)
        end

        if line =~ /^\/\/([^\/]|$)/ and !line.include?("MARK:") and !line.include?("swift")
            warn("Comments should be avoided in favour of expressing intent in code", file: file, line: index + 1)
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

perform_git_hygiene_checks
perform_basic_pr_checks
catch_untested_code
perform_swift_code_review
