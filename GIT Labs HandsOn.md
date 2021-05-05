# **GITLAB Hands ON Guide**

## LAB 1: CREATE A PROJECT AND ISSUE
1. Create a project

    - Navigate to Groups > Your groups in the top navigation bar.
    - Expand the arrow to the left of Training Users. Expand the arrow to the left of the Session entry for your class. Click on the entry for My Test Group that includes your username (hint: the group with the Owner tag is yours).
    - Click the blue New project button. Click Create blank project.
    - In the Project name field, enter Top Level Project. Optionally, include a few notes in the Project description box.
    - Under Visibility Level, click the radio button for Private.
    - Click the Initialize repository with a README checkbox. If you don't initialize your repository with a README, you will create a “bare” Git repository that you will need to add content to in order to bring into existence.
    - Click the green Create project button.

2. Create an issue

    - On the left-hand side of the screen, click the Issues section on the taskbar. You might need to click the double right-arrow icon at the bottom of the taskbar to make the section names visible.
    - Click the blue New issue button.
    - In the Title field, type my first issue. Optionally, enter a comment in the Description field.
    - In the Assignees field, click the Assign to me link.
    - Leave all other fields at their defaults and click Submit issue.

3. Create custom labels

    - On the left-hand side of the screen, click the Labels section (under the Issues header) on the taskbar.
    - Click the blue New label button.
    - In the Title field, type Opened and assign it a background color of your choosing.
    - Click the blue Create label button. Note: this label has been created at the project level, so it is specific to that project. It will not be available at the group level.
    - Using the same steps, create labels for Completed and Needs documentation, using label colors of your choice.
    - You should now have 3 labels created under the Labels section of the taskbar.

4. Utilize a quick action

    - On the left-hand side of the screen, click the Issues section on the taskbar.
    - Click on my first issue to open it.
    - Below the comment field, click the quick actions link.
    - Review the various quick actions you can complete by using the comment field in an issue.
    - Navigate back to the GitLab page for my first issue.
    - In the text editor field in the comment section, type /spend 1 h
    - Click the green Comment button.
    - Notice that in the right-hand pane, the time tracking widget reflects your last action.

5. Assign labels to an issue

    - Find the Labels section in the right-hand pane of the my first issue page. Click Edit in that section.
    - Click on the Opened and Needs documentation labels you created earlier.
    - Click away from the Labels section, and notice that the issue has both labels applied to it.


## LAB 2: WORKING WITH GIT LOCALLY

1. Verify git is installed locally

    - Open a terminal session or command prompt and type git version. If it prints a version number, git is installed.

2. Generate an SSH key
    - These steps are only needed if you do not have an SSH key already installed.
    - In a terminal or command prompt, type ssh-keygen
    - If prompted for a key type, choose ed25519, which is more secure than the more older id_rsa type.
    - You will be prompted to select the location in which your key will be saved. Press Enter to leave it at the default.
    - You may be prompted to create a passphrase. Leave it blank or enter a passphrase of your choice, and then hit Enter. If you do use a passphrase, you'll have to enter it every time you push or pull code from GitLab.com.

3. Add an SSH Key to Your GitLab profile

    - In the top right-hand corner of the the GitLab app, locate your user avatar and click the down arrow.
    - From the dropdown menu, click the Edit profile item.
    - On the left-hand side of the screen, click on SSH Keys.
    - If you have no SSH keys added to your profile, you will land on the Add an SSH Key screen.
    - Return to your terminal/command session. To retrieve the SSH key you created, move into the folder you saved it to by typing cd {file path}
    - Type ls -al to see two key files: a public key and a private key. The public key is called either id_ed25519.pub or id_rsa.pub and is what you need to share with GitLab.
    - Type cat id_ed25519.pub or cat id_rsa.pub (depending on which kind of key you generated) to print the contents of your public key. Copy those contents to your clipboard.
    - Return to the GitLab app in your browser. Paste the public key contents into the Key field, enter any title you want in the Title field, and click Add key.
    - Your local computer is now authenticated to push and pull (interact) with GitLab.

4. Copy (clone) a project repo to your local machine

    - Use the top navigation bar to get back to your Project Overview by clicking Projects > Your projects. Find your Top Level Project by looking for the one with the Owner label next to it (you might need to advance to the next page of projects).
    - Locate the blue Clone button and click the dropdown arrow.
    - In the Clone with SSH section, click the Copy URL button.

5. Create a directory on your local machine

    - Note: The following git commands are summarized in GitLab's helpful git cheat sheet.

    - In your terminal/command window, type cd to get out of the .ssh directory and into your home directory.
    - Type mkdir training to create a new directory.
    - Type cd training to move into your new directory.
    - Type git clone <URL you copied previously> to copy the git repository from your Top Level Project onto your local machine.
    - Move into the repository you just cloned by typing cd top-level-project. This is where git will track your changes, and where you will interact with the repo and git.
    - Type ls -al to see a list of all files in your current directory, including hidden files.
    - Type git status. You will see a message saying your working tree is clean.

6. Work on a branch

    - Type git checkout -b temporary_branch
    - Type git branch -a to see all branches.

        - Note: the red branches are on the remote server (GitLab.com).
    - Make a change to a README file

    - In your terminal/command window, navigate to the directory that contains the README.md file.
    - Using the editor of your choice, add a new line a second line added to master branch locally at the end of README.md. Save the file.
        - Developer Tip: Visual Studio Code is the preferred editor of most GitLab users, but any text editor (including Sublime Text, Atom, or vi) will do.
    - Type git status to see if git has noticed that the file has been modified.
        - Note: Git has detected that we have edited a file in our local repo, but since we have not created a "commit" yet, git has not yet added that edit to a snapshot.
7. Add README.md to the local GitLab staging area

    - Type git add README.md. If this is successful, git will produce no output. The add command doesn't move README.md on your filesystem, but it does add it to what git calls a "staging area".
    - Type git status to see that README.md is now ready to be committed (that is, it has been successfully staged).

8. Commit the changes to README.md

    - Type git commit -m "added a second line to readme.md"
        - Developer Tip: You can stage and commit a change at the same time by using the git commit -am "commit message" command to save time!
    - You have now created a record or point-in-time snapshot of the file that you can refer back to if needed.
    - Type git status to see that the staging area is empty again, following the commit.

9. Push Your changes to the temporary_branch on the remote GitLab server

    - Type git push -u origin temporary_branch. Enter the passcode for your SSH key if prompted. This creates a new branch on the GitLab server called temporary_branch and pushes your changes to that branch.
       -  Developer Tip: If you are ever unsure of the exact command to push your changes to the remote server, type git push and git will output an error message with the correct commands you can copy/paste.

10. Modify your content again

    - In your local machine's text editor (not the GitLab.com editor), add a new line to your local copy of README.md that says add a third line to file, and save the file.
    - In your terminal/command window, type git add README.md to move the edited file to git's staging area.
    - Type git commit -m "modified README.md" to commit the file that was in the staging area.
    - Type git log to see a description of the commit you just made.
    - Type git push to copy the edited README.md to the repo on GitLab.com.
        - Developer Tip: To commit your changes to the upstream branch (that is, the branch on the remote server with the same name as the branch on your local machine), simply type git push. The system only needs to set the upstream branch once.
    - Navigate to your GitLab.com project in your browser, switch from master to temporary_branch using the dropdown under the project's title, and confirm that your local changes were pushed up.

11. Simulate a change on the remote temporary_branch
        
      - In this section, let's simulate someone else in your organization making a change to the copy of temporary_branch that lives on GitLab.com. When we're done with this section, the remote and local versions of temporary_branch will be different: the code on that branch will have moved under your feet (so to speak)! In the section that follows this one, we'll see how to reconcile this difference.

    - From the GitLab.com dashboard, navigate to the Top Level Project and click on temporary_branch from the dropdown just below the project's name.
    - You are now looking at files in temporary_branch. Click on README.md.
    - Click the Web IDE button.
    - In the Web IDE screen, add a new line to the end of the file: add a fourth line from the remote copy of temporary_branch
    - Click the Commit… button.
    - Check the radio button for Commit to temporary_branch and uncheck Start a new merge request.
    - Click the Commit button to finalize the changes on the remote copy of temporary_branch. Since you made this change on the Gitlab.com server, the server's repository is now one commit ahead of your local repository.

12. Refresh your local branch with git fetch

     - Since your local temporary_branch is out of sync with the remote temporary_branch, you must update your local copy of that branch to incorporate the changes from the remote copy.
      - The git fetch command retrieves the updated state of remote branches without updating the contents of your local branches. In other words, it tells you how many commits your local branches are behind the remote branches, but it won't make any changes to your local branches.  
    - Return to your terminal/command window and type git fetch. If you are prompted for your SSH passphrase, enter it.
    - Type git status and review the updated status of your local branch.

13. Pull from the remote (upstream) repository

    - You now need to explicitly tell git to update the contents of your local temporary_branch by merging in changes from the GitLab.com temporary_branch.
    - In your terminal/command window, type git pull and check the output to see how many files it updated locally.
    - Type cat README.md to view the updated contents of the file. You should see the fourth line that you added in the GitLab.com Web IDE.
    - Merge all changes from temporary_branch into the master branch
    - In your terminal/command window, type git branch to verify which branch you are currently working in. You should already be in temporary_branch.
    - Switch to your master branch by typing git checkout master
    - Type git merge temporary_branch to incorporate all changes from your local temporary_branch (in this case, just the modified README.md) into your local master branch.

14, Update the remote repository
    - In your terminal/command window, type git status to see that there are no changed files that you need to stage or commit and to confirm that you are on the master branch.
    - Type git push to update the remote copy of master branch with any changes from your local copy.
    - Navigate back to GitLab.com and view README.md in your project's master branch to view the changes.

## LAB 3: USING GITLAB ISSUES TO PUSH CODE

1. Create a new project and issue

    - Navigate to your group, click the New project button, click Create blank project, and name your project Second Project.
    - Under Visibility Level, click the radio button for Private.
    - Enable the Initialize repository with a README checkbox.
    - Click the green Create project button. After a few seconds it will take you to a page showing your new project's details.
    - On the left-hand side of the screen, click the Issues section on the taskbar.
    - Click the blue New issue button.
    - In the title field, type new issue. Optionally, enter a comment in the Description dialog box.
    - In the Assignees field, click the link for Assign to me.
    - Click the Submit issue button to create the issue.

2. Create a merge request

    - Just above the comment box, click the dropdown arrow next to the green Create merge request button. The dropdown lets you customize the branch name for this new merge request. For this exercise, leave it at the default.
    - Click Create merge request to make a merge request for a branch named after the issue's title.

3. Edit files on a branch, using GitLab's Web IDE

    - In the middle of the merge request page, click Open in Web IDE.
    - Double-check that you are on the branch you just created by looking for the branch name in a dropdown in the top left corner of the page.
    - In the left-hand file list, click README.md.
    - On line 3 of the file, type Edit my README.md file.
    - Click the blue Commit… button at the bottom of the screen.
    - In the commit message box, type Updated the README.md file. Leave the radio box button at the default, so the commit will be on the branch you created earlier. Click Commit.

4. Verify Changes in a Merge Request

    - Navigate to the merge request you just added a commit to. A convenient way to do this is to click the small blue link at the very bottom of the page, that shows an exclamation point and the merge request number.
    - On the merge request page, locate the Assignee section in the upper right-hand corner (you might have to click the double arrow at the top right of the screen to expand the widget bar). Ensure the merge request is assigned to yourself.
    - Click the Changes tab directly below the merge request title.
    - Hover over the left side of any line, and a comment icon will appear. Hover over line 3 and click the comment icon.
    - In the comment field, type this code will fix this! and click the Start a review button. Click Submit review to add your comment.
    - To mark that the comment has been seen and the commit has been adjusted, close the review by clicking Resolve thread.

5. Approve the merge request

    - To mark the merge request ready to merge, click Mark as ready in the upper right-hand corner.
    - Click the Overview tab.
    - If there were eligible approvers, an Approve button would be in the View eligible approvers section.
    - Ensure the Delete source branch checkbox is enabled, and click the green Merge button.
    - Navigate back to your repository's project by clicking Repository in the left-hand nav bar. Switch to the master branch in the branch dropdown at the top left of the page, if you're not on that branch already. Verify that the merge successfully added the Edit my README.md file line to the bottom of README.md.


##LAB 4: BUILD A .gitlab-ci.yml FILE
1. Create a new project and add a CI/CD configuration file

    - Navigate to your group, click New project, click Create blank project.
    - In the Project name dialog box, enter CI Test.
    - Under Visibility Level, click the radio button for Private.
    - Enable the checkbox for Initialize repository with a README.
    - Click the green Create project button.
    - You should be on the Project overview page for your CI Test project. If not, navigate to it using the top navigation bar: Groups > Your Groups > Training Users > Session NUMBER > My Test Group - USERNAME > CI Test.
    - Create a new file by clicking the + dropdown 2 lines below the project's title. Click New file in the This directory section.
    - In the File name dialog box enter .gitlab-ci.yml.
    - If it's not already selected, click .gitlab-ci.yml in the next dropdown to the right, which selects a file template.
    - In the Apply a template dropdown, select Bash in the General section. This creates a minimal .gitlab-ci.yml file.
    - In the editor, delete all lines above and below the build1 and test1 sections
    - Define build and test stages by adding these 3 lines at the top of the file. Hint: watch your spacing! The stages keyword should be flush left. The stage names should each be indented by 2 spaces.

            stages:
              - build
              - test

    - Click the green Commit changes button.

2. Inspect the CI/CI pipeline

    - GitLab started running a CI/CD pipeline as soon as you committed .gitlab-ci.yml to your project's repository. To see the project's pipelines, go to the left navigation bar and click CI/CD > Pipelines.
    - Only one pipeline has run so far. See the details of that pipeline by clicking the green passed label next to the pipeline's table entry.
    - In the Build column, there's a widget representing the build1 job that belongs to that stage. In the Test column there's a widget representing the test1 job that belongs to that stage.
    - Click the build1 widget to see a web terminal that shows what happened when that job ran.
    - Go back and do the same for the test1 widget

## LAB 5: AUTO DEVOPS WITH A PREDEFINED PROJECT TEMPLATE

        - We will use a pre-defined template for NodeJS Express to show how Auto DevOps works.
        - Resource: SAST docs
        - 
1. Create a new Node JS Express project with Auto DevOps

    - Just like with previous labs, navigate to your group and click New project. Click Create from template and then click Use template next to NodeJS Express.
    - In the Project name field, enter Auto DevOps-test. Make sure the Visiblity Level is Private. Click Create project.
    - Auto DevOps is an alternative to crafting your own .gitlab-ci.yml file. Note the banner at the top of the window alerting us that Auto DevOps is running in the background.
    - In the left pane, click Pipelines in the CI/CD section. Note there are no pipelines running. The most common way to run a pipeline is simply to make a commit to any branch of your project's repository, so let's do that next.
    - In the left pane, click Branches in the Repository section. Click the green New branch button.
    - In the Branch name field, enter new-feature. Click Create branch.
    - In the left pane, click Pipelines in the CI/CD section. Note that there is now a pipeline running, and that it has the Auto DevOps label.
    - Click running and note the 6 stages that Auto DevOps has created.

2. Commit a change in order to trigger a pipeline run

    - In the left pane, click Repository.
    - Switch to the new-feature branch by selecting it in the dropdown that currently says master near the top left of the window.
    - To edit a file on this branch, click Web IDE near the top right of the window.
    - Click views > index.pug.
    - Click the blue Edit button and then modify the last line of index.pug to: p GitLab welcomes you to #{title} Note: be sure to include the p at the beginning of the line.
    - In the Commit message field, type update welcome message in index.pug. Click Commit changes.
    - Click the blue Create merge request button.
    - Assign the merge request to yourself.
    - Add Draft:to the beginning of the text in the Title field to show that it isn't ready to be merged yet.
    - Leave all other fields at their default values and click Submit merge request at the bottom of the page. You now have an active merge request for merging the new-feature branch into the master branch. The page you are on shows the details of that merge request, including the status of the last pipeline that was run on the new-feature branch (sometimes you have to refresh the page to see the pipeline's status). GitLab will run a new pipeline every time you commit to the new-feature branch.
    - Toward the end of the Auto DevOps pipeline, it will deploy your NodeJS Express application into a review environment named after the branch: review/new-feature.
    - You can see the Docker container that the Auto DevOps pipeline created when it was deploying your application to the review environment: in the left pane, click Container Registry in the Packages & Registries section


## LAB 6: Static Application Security Testing (SAST)

        - SAST, an optional feature of CI/CD pipelines, analyzes your source code for known vulnerabilities. On every commit to a SAST-enabled project, GitLab checks the SAST report and compares the found vulnerabilities between the source and target branches.

        - The purpose of this lab is to use SAST to identify potential security vulnerabilities in your code.
        - 
1. Navigate to the CI Test Project

    - Open your CI Test project and click on the .gitlab-ci.yml file.
    - Click on Web IDE to edit the file.
    - Pull up this docs page in another tab to assist you with this lab. This page displays instructions for including SAST in CI/CD pipelines. The page also lists the languages and frameworks that SAST supports.
    - On the docs page, scroll down to the Configure SAST manually section.
    - Copy the following line:

        include:
          - template: Security/SAST.gitlab-ci.yml

    - Navigate back to the Web IDE where you were editing .gitlab-ci.yml.
    - Paste the code just copied below the test1 section, leaving a blank line between the blocks of code. Ensure the first line of the pasted code is flush-left, and the second line is indented.
    - Click the blue Commit… button.
    - Add a commit message: Add SAST to pipeline.
    - Click Commit to master branch instead of creating a new branch.
    - Click Commit. Now that you have committed this change, the pipeline will run.

2. Next, let's add a file with a known vulnerability and see if SAST detects it. Add a main.go file and view SAST results

    - Navigate away from the Web IDE and back to your project overview page repository by clicking the CI Test project title on the top left of the window.
    - Click the + icon to the right of the master branch name near the top left of the window. Under This directory, click New file.
    - Type main.go in the File name field.
    - Copy entire file contents from this snippet and paste them into your empty main.go file.
    - Click Commit changes.
    - In the left pane, click Pipelines in the CI/CD section. Click the running or passed status label next to the top entry in the list of pipelines. Under the Test stage, you should see the SAST scan running.
    - Click the Security tab near the middle of the page. In the Vulnerability column, click on the Errors unhandled vulnerability to learn more about a potential security problem that SAST scanning detected
