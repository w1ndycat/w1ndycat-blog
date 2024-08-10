hugo
git add -A
echo Your commit is:
set /p commit=
git commit -m "%commit%"
git push -u origin main