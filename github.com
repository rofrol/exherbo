Global setup:

  Download and install Git
  git config --global user.name "Your Name"
  git config --global user.email rofrol@gmail.com
        

Next steps:

  mkdir exline
  cd exline
  git init
  touch README
  git add README
  git commit -m 'first commit'
  git remote add origin git@github.com:rofrol/exline.git
  git push origin master
      

Existing Git Repo?

  cd existing_git_repo
  git remote add origin git@github.com:rofrol/exline.git
  git push origin master
      
