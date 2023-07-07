+++
title = "第十二篇文章-折腾hugo-bug"
date = "2023-07-07T15:57:56+08:00"

#
# description is optional
#
# description = "An optional description for SEO. If not provided, an automatically created summary will be used."

tags = ["hugo博客"]
+++

刚才上服务器查看下 docker 的日志，结果发现之前以为解决的

```
<none><none>
```

也就是无用镜像，按照搜索和 ChatGPT 给出的解答

Docker 中的"none"镜像是指在构建镜像过程中产生的无标签（untagged）镜像。它通常是由以下情况导致的：

1. 构建镜像时没有为其指定标签：当你使用 Docker 的`docker build`命令构建镜像时，如果没有给镜像指定标签，那么在构建过程中会生成一个"none"标签的镜像。例如，使用以下命令构建镜像会产生一个"none"标签的中间镜像：

   ```
   docker build -t myimage .
   ```

2. 删除标签后的残留镜像：如果你删除了一个已有标签的镜像，但是其他镜像仍然依赖于它或被用作缓存，那么被删除标签的镜像将会被标记为"none"。这通常发生在多阶段构建或使用缓存的情况下。

注意，"none"镜像并不会占用额外的存储空间，因为它只是一个指向其他镜像的指针。你可以使用`docker image prune`命令清除无用的"none"镜像。

```
docker image prune
```

这个命令会删除没有标签的镜像，以及没有引用的缓存镜像，以释放磁盘空间。

我这边测试过本地，本地的 docker compose 文件在指定 image 的标签后不再出现无用镜像，本能地认为服务器也是如此，结果还是出现了

这次应该是残留镜像导致的，我估计仍在运行时构建了镜像，docker compose build 时导致问题

现在可以通过在 GitHub Action 文件中添加

```
docker image prune -f
```

但这是一个有风险的命令

我再想能不能采用挂载磁盘，也就是将持续部署的内容和服务分开，之前不想分开是因为我觉得在容器内运行，效果更好，现在看来有点风险

后面考虑下分离
