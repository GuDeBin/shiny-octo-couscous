+++
title = "GitHub Action"
date = "2023-07-03T12:36:59+08:00"

description = "Github Action简明教程"

#
# description is optional
#
# description = "An optional description for SEO. If not provided, an automatically created summary will be used."

tags = ["Github-Action"]
+++

## GitHub Action 简介

GitHub Actions 是一个用于自动化软件开发工作流程的工具。它允许你在代码仓库中直接设置工作流程，并根据你指定的事件自动触发。

GitHub Actions 还提供了强大的功能来管理和协调工作流程。你可以定义步骤之间的依赖关系，为每个步骤指定不同的上下文和环境变量，并使用工作流程模板创建可重复使用的工作流程。

此外，GitHub Actions 还提供了许多内置功能，以增强你的自动化能力。包括安全地存储和访问敏感数据的密钥管理、用于共享构建输出的存储和传输工具，以及丰富的市场集成生态系统，使你能够连接和与外部服务和工具进行交互。

总的来说，GitHub Actions 通过自动化重复任务并让你专注于编写代码和交付软件，简化和优化了开发过程。它能够创建高效、可扩展和可定制的工作流，提高开发团队之间的协作和生产力。

## 简明教程

GitHub Actions 是一项非常强大和灵活的持续集成/持续部署（CI/CD）工具，它可以帮助开发人员自动化构建、测试和部署他们的代码。下面是一个 GitHub Actions 入门教程，以帮助你快速上手。

步骤 1：创建 GitHub 仓库
首先，在 GitHub 上创建一个新的仓库。你可以使用命令行工具，也可以在 GitHub 网站上手动创建。确保在仓库中添加一个示例代码，用于后续的操作。

步骤 2：创建 Action 工作流文件
进入你的仓库，并点击上方的 "Actions" 选项卡。然后，点击 "Set up a workflow yourself" 创建一个新的工作流文件。

示例工作流文件的名称可以是 `.github/workflows/main.yml`。在该文件中，你可以编写工作流程的具体步骤。

步骤 3：编写工作流程步骤
在你的工作流程文件中，你可以定义一系列步骤来执行不同的操作。例如，构建、测试和部署代码。

下面是一个示例的工作流程文件：

```yaml
name: CI/CD Workflow

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Node.js
        uses: actions/setup-node@v2
        with:
          node-version: "14"

      - name: Install dependencies
        run: npm install

      - name: Build and test
        run: |
          npm run build
          npm run test

      - name: Deploy
        run: npm run deploy
```

在这个例子中，工作流程在推送到 `main` 分支时触发。它会在 Ubuntu 环境中运行，并依次执行以下步骤：

1. 检出代码
2. 设置 Node.js 环境
3. 安装依赖项
4. 构建和测试代码
5. 部署代码

步骤 4：推送代码并触发工作流
在你的本地修改代码后，将代码推送到 GitHub 仓库。这将触发 GitHub Actions 开始执行工作流程。

你可以在 "Actions" 选项卡中查看工作流程的执行情况，并查看每个步骤的日志输出。如果工作流程中的步骤发生错误，你会在日志中看到对应的错误提示。

总结：
这是一个简单入门的 GitHub Actions 教程，它帮助你创建一个基本的工作流程文件，并触发执行。你可以根据自己的需求，根据注释添加其他步骤，以构建更复杂的 CI/CD 流水线。同时，GitHub Actions 支持许多其他的功能和集成，例如通知、部署到不同的云平台等等。

详细文档[Github Action](https://docs.github.com/zh/actions)
