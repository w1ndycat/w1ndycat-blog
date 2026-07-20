@echo off
chcp 65001 >nul
setlocal

echo ===== 1/4 构建网站 (hugo) =====
hugo
if errorlevel 1 (
    echo.
    echo [出错] hugo 构建失败，请看上面的报错信息。没有 add，没有 commit，没有 push。
    pause
    exit /b 1
)

echo.
echo ===== 2/4 检查改动 =====
set "hasChanges="
for /f "delims=" %%i in ('git status --porcelain') do set "hasChanges=1"
if not defined hasChanges (
    echo 没有检测到任何文件改动，不需要提交。
    pause
    exit /b 0
)

git add -A

set "commit="
set /p commit=请输入本次提交说明（直接回车则用默认说明）: 
if "%commit%"=="" set "commit=更新博客 %date% %time%"

git commit -m "%commit%"
if errorlevel 1 (
    echo.
    echo [出错] git commit 失败，请看上面的报错信息。
    pause
    exit /b 1
)

echo.
echo ===== 3/4 拉取远端最新改动，避免推送冲突 =====
git pull --rebase
if errorlevel 1 (
    echo.
    echo [出错] git pull 失败，可能有冲突需要手动处理。commit 已经保存在本地，
    echo 处理完冲突后自己手动 git push 就行，不会丢改动。
    pause
    exit /b 1
)

echo.
echo ===== 4/4 推送到 GitHub =====
git push -u origin main
if errorlevel 1 (
    echo.
    echo [出错] git push 失败，请看上面的报错信息。commit 已经保存在本地，
    echo 可以稍后重新运行这个脚本，或者手动 git push。
    pause
    exit /b 1
)

echo.
echo ===== 全部完成！=====
pause
