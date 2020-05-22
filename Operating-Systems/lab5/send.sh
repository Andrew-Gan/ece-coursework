
echo -n "What do you want to commit? "
read commit_str

git pull
git add *
git commit -m "$commit_str"
git push
