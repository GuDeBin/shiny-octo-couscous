+++
title = "折腾hugo-GitHub Action"
date = "2023-07-03T12:28:15+08:00"

#
# description is optional
#
# description = "An optional description for SEO. If not provided, an automatically created summary will be used."

tags = ["hugo博客"]
+++

既然选择了放弃了宝塔，😭

那么开始折腾 GitHub Action

其实，我使用过 GitHub Action，这 GitHub 比云效慷概，给出的机器配置

Windows 和 Linux 虚拟机的硬件规格：

- 2 核 CPU (x86_64)
- 7 GB RAM
- 14 GB SSD 空间

而云效容器构建环境规格默认 1C1G，Node 相关任务 4C8G，其他任务 3C6G

其实到也不能批判谁，国内的成本比国外高，原因多方面，就这点资源估计也是云效挤出来的

为啥一开始没有用 GitHub Action，原因很简单，这个 GitHub 是在美国构建，然后穿过太平洋到杭州，结果服务器频繁拒绝权限，我试了好几个 ssh 部署的 Action 拓展，结果往往出现各种问题，所以放弃操作。

这次必须成功，我换了一个思路，不在寻找教程之类的，而是实例，也就是使用 GitHub Action 部署自己网站的，也很庆幸，我之前关注的一个博主，也就是花果山大圣，他的博客便是用 GitHub Action 部署的，这是他的网站[大圣前端进阶指南](https://shengxinjing.cn/)

```yaml
- name: copy file via ssh password
        uses: appleboy/scp-action@master
        with:
          host: ${{ secrets.REMOTE_HOST }}
          username: ${{ secrets.REMOTE_USER }}
          password: ${{ secrets.REMOTE_PASS }}
          port: 22
          source: "docs/"
          target: ${{ secrets.REMOTE_TARGET }}
```

这里的 appleboy/scp-action@master 测试成功，我长舒一口气，终于过了最大的门槛，我立马找到这个插件的作者，居然还有一个 appleboy/ssh-action@master，可以在服务器上执行命令，立马配合使用

```yaml
# Sample workflow for building and deploying a Hugo site to GitHub Pages
name: Deploy Hugo site to Pages

on:
  # Runs on pushes targeting the default branch
  push:
    branches:
      - main

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# Sets permissions of the GITHUB_TOKEN to allow deployment to GitHub Pages
permissions:
  contents: read
  pages: write
  id-token: write

# Allow only one concurrent deployment, skipping runs queued between the run in-progress and latest queued.
# However, do NOT cancel in-progress runs as we want to allow these production deployments to complete.
concurrency:
  group: "pages"
  cancel-in-progress: false

# Default to bash
defaults:
  run:
    shell: bash

jobs:
  # Build job
  build:
    runs-on: ubuntu-latest
    env:
      HUGO_VERSION: 0.114.0
    steps:
      - name: 安装hugo
        run: |
          wget -O ${{ runner.temp }}/hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb \
          && sudo dpkg -i ${{ runner.temp }}/hugo.deb
      - name: 安装Dart Sass
        run: sudo snap install dart-sass
      - name: 迁出代码
        uses: actions/checkout@v3
        with:
          submodules: recursive
          fetch-depth: 0
      - name: 安装node依赖
        run: "[[ -f package-lock.json || -f npm-shrinkwrap.json ]] && npm ci || true"
      - name: Build with Hugo
        env:
          # For maximum backward compatibility with Hugo modules
          HUGO_ENVIRONMENT: production
          HUGO_ENV: production
        run: |
          hugo \
            --gc \
            --minify \
      - name: 设置工作目录
        run: |
          mkdir build
          mv public build
          cp Dockerfile build
          cp docker-compose.yaml build
          cp default.conf build
      - name: 上传
        uses: appleboy/scp-action@master
        with:
          host: ${{ secrets.REMOTE_HOST }}
          username: ${{ secrets.REMOTE_USER }}
          # password: ${{ secrets.REMOTE_PASS }}
          key: ${{ secrets.REMOTE_KEY }}
          port: 22
          # 上传多个文件
          source: "build/*"
          target: ${{ secrets.REMOTE_TARGET }}
      - name: 使用ssh执行命令
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.REMOTE_HOST }}
          username: ${{ secrets.REMOTE_USER }}
          # password: ${{ secrets.REMOTE_PASS }}
          key: ${{ secrets.REMOTE_KEY }}
          port: 22
          # 构建镜像
          script: |
            cd ${{ secrets.REMOTE_TARGET }}/build
            docker compose down
            docker compose build
            docker compose up -d
            rm -rf ${{ secrets.REMOTE_TARGET }}/build
            exit
```

这里面的逻辑是先构建，再将构建产物、docker 配置文件和 nginx 配置文件一起打包部署到服务器，再执行命令构建 docker 镜像，启动服务

这里面的我遇到坑有这几个

- hugo 构建

之前使用 action 插件构建，但是出现不稳定，也就是有的构建成功、有时构建失败，十分难以捉摸，干脆直接用 hugo 官网的[Host on GitHub](https://gohugo.io/hosting-and-deployment/hosting-on-github/)Action 文件修改，将部署到 GitHub Page 后半段修改为部署服务器上

还有就是，我本地使用的 hugo0.92.2，但是在部署时设置这个版本时构建失败，只能采用 0.114.0

- 部署文件

这个 appleboy/scp-action@master 貌似只能将文件夹整体部署到服务器，我有点死脑筋的在一条线上，想法设法希望能只能构建文件夹 public 里的构建文件传递到服务器，反复尝试后，我很沮丧

可是当我停下来，去做别的事情时，突然想到两个关于问题的逻辑，一个是如果出现问题，先思考这是不是自作自受，也就是问题有没有意义，需求有没有意义，第二个是这个问题能绕开吗

基于这两个逻辑，我才想起，他的功能是部署文件\文件夹到服务器，它也满足我这个需求，那么我的其他需求，也就是希望将多个文件传递到服务器，这个不是它的定义，也就是这个问题是我的其他需求，不是我部署到服务器需求，这个问题能不能绕开，能啊，太能了，他只是传递文件 or 文件夹到服务器，那为什么我不把所有我想要到服务器的文件都放在一个指定的文件夹中传递呢

所以直接在构建后加了一个设置工作目录，将所有我想传递到服务的文件复制进入，在服务器执行命令时就在这个工作目录下工作，最后再删除

完结
