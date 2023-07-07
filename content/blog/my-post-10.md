+++
title = "第十篇文章-折腾hugo-最终"
date = "2023-07-07T12:39:11+08:00"

#
# description is optional
#
# description = "An optional description for SEO. If not provided, an automatically created summary will be used."

tags = ["hugo博客"]
+++

现在我的博客基本成型

流程如下

1. 本地编辑文章
2. 发布到 GitHub 存储库，触发 Github Action
3. GitHub Action 构建并部署到服务器
4. GitHub Action 部署后执行 docker compose
5. 构建镜像并启动容器映射 80 端口

折腾时间大概是一周，主要是空余时间，其中最让我头疼的是 GitHub Action 部署到服务器，幸好找到一个十分丝滑的 action 插件

但是后续仍有些让我这个强迫症烦恼的地方

服务器每次部署都会报警，虽然没事，但是仍让我考虑是不是换个构建方式，例如使用云效，GitHub 只是一个托管

静待后续
