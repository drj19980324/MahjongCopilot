#!/bin/bash

# 设置环境变量
export PLAYWRIGHT_BROWSERS_PATH=0

# 安装必要的浏览器
playwright install chromium

# 清理旧的构建文件
rm -rf dist

# 使用PyInstaller打包主程序
pyinstaller --windowed --noconfirm --name=MahjongCopilot --icon=resources/icon.icns main.py
if [ $? -ne 0 ]; then
    echo "PyInstaller encountered an error."
    exit 1
fi

# 复制必要的资源文件
cp -R resources dist/MahjongCopilot.app/Contents/MacOS/resources
cp -R liqi_proto dist/MahjongCopilot.app/Contents/MacOS/liqi_proto
cp -R proxinject dist/MahjongCopilot.app/Contents/MacOS/proxinject
cp -R libriichi3p dist/MahjongCopilot.app/Contents/MacOS/libriichi3p

# 创建必要的目录
mkdir -p dist/MahjongCopilot.app/Contents/MacOS/models
mkdir -p dist/MahjongCopilot.app/Contents/MacOS/chrome_ext

# 复制版本信息
cp version dist/MahjongCopilot.app/Contents/MacOS/

# 复制浏览器驱动
cp -R .venv/lib/python*/site-packages/playwright/driver/package/.local-browsers dist/MahjongCopilot.app/Contents/MacOS/_internal/playwright/driver/package/

# 创建dmg文件
# 首先创建一个临时目录
mkdir -p dist/dmg
cp -R dist/MahjongCopilot.app dist/dmg/

# 创建软链接到Applications
ln -s /Applications dist/dmg/Applications

# 使用hdiutil创建dmg文件
hdiutil create -volname "MahjongCopilot" -srcfolder dist/dmg -ov -format UDZO dist/MahjongCopilot.mac.dmg

# 清理临时文件
rm -rf dist/dmg

# 打开输出目录
open dist 