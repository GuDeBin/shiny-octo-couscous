+++
title = "折腾hugo-Docker"
date = "2023-07-06T14:02:11+08:00"

#
# description is optional
#
# description = "An optional description for SEO. If not provided, an automatically created summary will be used."

tags = ["hugo博客"]
+++

在解决了 GitHub Action 持续部署后，如何在服务运行服务又是一个选择题

- 直接安装 nginx
- 用 docker

这两个思考后，我选择的是 docker，因为一句话打动了我，想换直接把容器和镜像删了，多简单快捷

所以，用 docker 部署就是我下一步的选择，之前了解过 docker，但是觉得是麻烦，因为一些配置软件，都是固定的需求，服务器运行一种服务，我没明白 docker 的用处，仿佛只有环境一致性能打动我

而这一次不同，借助 ChatGPT，我不再是看文档-了解全局-确定需求-针对搜索-落地测试这种路径，而是直接将我的需求提给 ChatGPT，他给出我方式，我验证，在完善中反复提问，不得不说这个方式效率实在是高，我几乎只学到我需要的 docker 知识

需求就是使用 nginx 部署静态网页，在服务器上生成镜像，构建容器，映射端口提供服务

镜像生成文件 Dockerfile

```docker
# 使用基于nginx:stable-alpine3.17-slim的基础镜像
FROM nginx:stable-alpine3.17-slim

# 将./public目录的内容复制到容器中的/usr/share/nginx/html目录下
COPY ./public /usr/share/nginx/html

# 将default.conf文件复制到容器中的/etc/nginx/conf.d/default.conf路径下
COPY default.conf /etc/nginx/conf.d/default.conf

# 暴露80端口，以允许外部流量访问
EXPOSE 80

# 设置容器启动时的主进程命令为"nginx -g 'daemon off;'"，以保持容器持续运行
CMD ["nginx", "-g", "daemon off;"]
```

而 ChatGPT 给出的介绍

- 我们使用了 nginx:stable-alpine3.17-slim 基础镜像，它提供了一个在 Alpine Linux 上稳定版本的 Nginx。
- COPY 指令将主机机器上./public 目录的内容复制到容器内的/usr/share/nginx/html 目录下。
- COPY 指令还将主机机器上的 default.conf 文件复制到容器内的/etc/nginx/conf.d/default.conf 路径下，这个文件被用于配置 Nginx。
- EXPOSE 指令暴露 80 端口，以允许外部流量访问容器中运行的 Nginx 服务器。
- 最后，CMD 指令设置容器启动时要执行的命令。它运行 nginx 二进制文件，并使用-g 'daemon off;'选项，以非守护进程模式启动 Nginx 作为主进程，以保持容器运行。

很有针对性，虽然不是一开始就告诉我如此操作，但也是在我不断地询问中完善、发掘自己真正的需求后，生成的

接下来的构建并启动容器，需要的就是 docker compose

先上代码

```yaml
version: "3" # Docker Compose的版本号

services: # 定义服务
  nginx: # 定义一个名为nginx的服务
    image: my-blog:latest # 使用my-blog镜像的最新版本作为容器运行
    build: # 构建选项
      context: . # 指定上下文路径，Dockerfile文件将在当前目录中查找
      dockerfile: Dockerfile # 指定Dockerfile文件的名称
    ports: # 端口映射
      - 80:80 # 将主机的80端口映射到容器的80端口
```

通过上述配置，可以创建一个名为 nginx 的容器，在该容器中可以使用 my-blog 镜像的最新版本。构建选项可以定义如何构建容器，context 指定了 Dockerfile 的上下文路径，dockerfile 指定了 Dockerfile 的文件名。ports 部分定义了将容器内部的 80 端口映射到主机的 80 端口，这样可以通过主机的 80 端口访问 nginx 容器。

要使用上述的 Docker Compose 配置文件，只需将其保存为 docker-compose.yml（或其他名称的 YAML 文件），然后在该文件所在的目录中运行 docker-compose up -d 命令即可启动 nginx 服务。

不过这 GitHub Action 中，我使用 docker compose down 先停止并删除容器，再用 docker compose bulid 构建新的镜像，docker compose up -d 启动容器并后台运行

这里有几个插曲分享下

- 在 docker-compose.yml 中没有设置 image：my-blog：latest 这个镜像标签，结果每次重新构建都会出现<none><none>，询问后知道是因为不指定镜像标签产生的，在添加 image：my-blog：latest 后消失

- 不明白 Dockerfile 已经暴漏端口，为啥 docker-compose 里还要制定，按照 ChatGPT 回复，两者不冲突，Dockerfile 是定义对外暴漏端口，而 Compose 是定义主机和容器的端口映射关系
