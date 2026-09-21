# MD 阅读器

一个纯前端的本地 Markdown 阅读器：把 md 文件拖进来，或者选择整个文件夹，就能跨全部文档检索关键词，一键跳转到命中的具体段落。单文件、零依赖、无需联网、无需安装。

![截图](screenshot.png)

## 功能

- **段落级全文检索**：输入关键词，跨所有文档列出命中的内容段，关键词高亮；支持空格分隔多词并含、大小写不敏感。
- **一键定位**：点右侧任意结果，左侧跳到该文档对应段落，命中段高亮并自动滚动居中。
- **拖拽读入**：把 md 文件直接拖进窗口即可阅读，支持一次拖多个；同名文件自动覆盖。
- **选文件夹**：选择整个文件夹，递归读取所有 `.md` / `.markdown` / `.txt`。
- **Markdown 渲染**：标题、列表、任务列表、引用、表格、代码块、链接、强调、分隔线。
- **深浅主题**：右上角一键切换，记忆偏好。
- **键盘操作**：`/` 聚焦搜索，`↑↓` 切换结果，`Enter` 跳转，`Esc` 清空。
- **分享链接**：支持 `?q=关键词` 参数直接带入检索并定位，例如 `index.html?q=基金`。

## 快速开始

也可以直接从 [Releases](https://github.com/Jesse1024/md-reader/releases) 下载打包好的 zip（含一键安装脚本）。

下载 `index.html`，双击用浏览器打开即可。无需安装、无需联网。

Windows 用户也可以直接双击 `install.bat`，一键装到桌面并生成快捷方式，见下文「安装与桌面快捷方式」。

或克隆仓库：

```bash
git clone https://github.com/Jesse1024/md-reader.git
cd md-reader
start index.html   # Windows
open index.html    # macOS
```

## 使用

1. 把 md 文件拖进窗口，或点右上角「选择 MD 文件夹」。
2. 右侧输入关键词，命中的内容段按文档分组列出。
3. 点任意一条，左侧跳到对应位置。

左侧默认显示全文（能看到上下文），可切「只看命中」只看含关键词的段落。

## 安装与桌面快捷方式（Windows）

**方式一：一键安装（推荐）**

下载并解压仓库后，双击 `install.bat`，脚本会：

1. 把文件复制到 `%LOCALAPPDATA%\MDReader`
2. 在桌面创建「MD Reader」快捷方式（用系统自带的 Edge，以应用模式打开，无地址栏、无标签页）

之后双击桌面「MD Reader」就是独立窗口。脚本会自动检测 Edge，没有 Edge 时回退到 Chrome。

> 若 Windows 提示「来自其他计算机」的安全警告，点「更多信息 → 仍要运行」。

**方式二：便携使用**

不安装，直接双击 `index.html` 用浏览器打开，功能完全一样。

**方式三：手动创建快捷方式**

想自己控制，手动新建快捷方式，目标填：

```
"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --app="file:///D:/path/to/index.html"
```

把路径换成你解压后的实际位置。

## 技术说明

- 纯 HTML/CSS/JS 单文件，无构建步骤，无第三方依赖。
- 自研轻量 Markdown 解析器；按标题与空行切分自然段，段落是检索和定位的最小单元。
- 检索为全文遍历式：载入时预生成段落小写文本，输入带 150ms 防抖，实测千篇级文档（数百万字）单次扫描约 10ms，敲字无感；命中超 300 条时仅渲染前 300 条，计数仍显示全部。
- 用 File System Access API 读取本地文件，全程本地处理，不上传、无后端。
- 浏览器不支持 `showDirectoryPicker` 时自动降级为文件选择器。

## 浏览器兼容

| 功能 | Chrome / Edge | Firefox | Safari |
|------|--------------|---------|--------|
| 检索 / 定位 / 渲染 | 支持 | 支持 | 支持 |
| 拖拽读入 | 支持 | 支持 | 支持 |
| 选文件夹 | 支持 | 降级为选文件 | 降级为选文件 |

## 目录结构

```
md-reader/
├── index.html      # 应用主体（单文件）
├── icon.ico        # 图标
├── install.bat     # Windows 一键安装（双击）
├── install.ps1     # 安装脚本（install.bat 调用）
├── screenshot.png  # 截图
├── README.md
└── LICENSE
```

## License

[MIT](LICENSE) © 南山怪客
