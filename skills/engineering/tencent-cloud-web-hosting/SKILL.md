---
name: tencent-cloud-web-hosting
description: Use when the user wants to reuse their Guangzhou Tencent Cloud server for a new website or domain, configure DNS and Caddy routing, or diagnose access to 106.53.187.46 and the existing 轻待办 deployment.
---

# 腾讯云服务器与域名接入

用于跨项目复用用户已有的广州轻量应用服务器。先读 [服务器资料](references/server-access.md)，使用已记录的连接方式做只读预检；不要重新询问已有的服务器 IP、SSH 用户名或私钥位置。

## 权限与任务范围

- 已实测的能力是 `ubuntu` 的 SSH 登录和 `sudo -n` 管理权限，可管理服务器文件、应用服务与 Caddy。以当前用户请求确定本次要部署的项目、域名和改动范围；这个技能保存访问资料，不会创造新的权限或扩展任务范围。
- 域名注册商、DNS 控制台权限、腾讯云控制台/API 权限是独立的。目前未记录可用 DNS/API 凭据；先检查当前可用连接器、登录会话及用户提供的信息，缺失时仅询问具体域名、DNS 平台或必要的登录协助。SSH 成功不代表可以修改云防火墙或任意域名的 DNS。
- 私钥只在用户电脑上供 SSH 使用。技能、归档、Git、聊天输出和部署包均不包含私钥正文、密码、会话 Cookie、云 API 密钥或令牌；不要为复用而把私钥上传到服务器。

## 接入一个新网站或域名

1. 确认用户指定的完整域名及目标项目；如未指定，只询问缺少的目标。预检 `id`、`sudo -n true`、`ss -ltn`、现有 Caddyfile 和相关 systemd 服务，读取项目自己的部署说明。服务器资料中的状态是有日期的观察，先刷新再操作。
2. 为新应用选择独立目录、服务名和空闲环回端口，保留现有待办的 `/todolist/`、4317 端口和数据目录。现有应用不因创建新网站而被覆盖、重装或清空。
3. 核对当前 DNS 的 A、AAAA、CNAME 及管理权限。为用户指定的主机名配置 A 记录到 `106.53.187.46`；仅处理与目标冲突的记录，保留其他主机、邮件和验证记录。不要把未知域名或旧 `stararc.site` 的管理权当作既有事实。
4. 在服务器备份现有 Caddy 配置；新增该域名的独立站点块或项目专属片段，静态站点指定正确目录，动态应用转发到独立环回端口。用候选配置执行 `sudo caddy validate --config <候选配置绝对路径> --adapter caddyfile`，确认无误再安装并 reload；失败恢复本次网关备份，保留数据库和用户新数据。
5. 若本次提供 HTTPS，检查 DNS、证书签发、Caddy 实际监听以及云防火墙入站 80/443。`ufw` 或 `iptables` 规则不是腾讯云控制台防火墙规则。先检查已存在规则，只处理本次需要的入口。遵循当前工具的授权要求，不重复索取会话内已明确给出的同一授权。
6. 同步应用的外部 URL、子路径、可信 Origin 与 Cookie 策略。待办目前使用 HTTP；若迁移其入口到 HTTPS，不能只改代理而漏掉 `PUBLIC_URL`、`SECURE_COOKIES` 和登录/写入验证。
7. 分别验证环回后端、源站 Host/SNI 和真实公网 DNS 入口：页面完整加载、资源路径、登录及本次相关业务。使用有效证书校验，不用跳过证书错误冒充 HTTPS 成功。仅源站或内部 200 不代表用户的公网入口可用；命令行成功也不等于真实手机/浏览器实测。
8. 在目标项目既有变更记录中保存实际配置、服务位置、备份、检查结果和回退办法。只有公网验收后才交付“可用网址”；若 DNS、云规则或证书尚未就绪，明确当前结果和确切缺口。

## 常见入口诊断

- 先比较用户实际打开的协议、域名、端口和路径。`http://106.53.187.46/todolist/` 与 `https://106.53.187.46/todolist/` 是不同入口；IP 本身不是已注册域名。
- 超时先分清 DNS、TCP、TLS、页面、脚本或 API。对比直连与已知代理，凭测量判断 VPN 影响；不自动修改用户 VPN 或浏览器安全设置。
- 新站点的证书和公网入口尚未通过验证时，保留现有可用站点。浏览器工具连接失败只代表该检查未完成，不是网站一定故障，也不能据此声称页面已验收。

资料：[Caddy 自动 HTTPS](https://caddyserver.com/docs/automatic-https)、[腾讯云实例防火墙](https://cloud.tencent.com/document/product/1207/44577)。涉及具体 DNS 平台或上线条件时读取其当前官方说明。
