# 已有服务器访问资料

核验日期：2026-11-02，Asia/Shanghai。这是已有配置的记录；连接、端口、服务和路由都应在执行时再次确认。

| 项目 | 已核实信息 |
| --- | --- |
| 产品 / 地域 | 腾讯云轻量应用服务器，广州七区 |
| 实例 | `lhins-2cu3mkqz`；购买时名称 `Hermes Agent-37GP` |
| 公网 IPv4 | `106.53.187.46` |
| 系统 | Ubuntu 24.04，x86_64 |
| SSH | 端口22，用户 `ubuntu`，私钥认证 |
| 私钥文件位置 | `C:/Users/ww/Desktop/ltodo.pem`，仅引用路径，不包含文件内容 |
| 管理能力 | 本次 `sudo -n true` 成功；可通过 sudo 管理 Caddy、systemd 和项目目录；无需启用 root SSH |
| 当前待办入口 | `http://106.53.187.46/todolist/`，本次公网 HTTP 返回200 |
| HTTPS 状态 | 本次没有443监听；不能把 `https://106.53.187.46/todolist/` 当作可用入口 |
| 网关 | `/etc/caddy/Caddyfile`；`caddy.service`，active且enabled |
| 既有路由 | `:80`；`/todolist`重定向到尾斜杠；`handle_path /todolist/*` → `127.0.0.1:4317`；保留默认根站点 |
| 待办服务 | 系统级 `qing-todo.service`，运行用户 `qing-todo`，active且enabled |
| 代码 | `/opt/qing-todo/current`，执行时用readlink确认实际release；本次为`releases/20261030-appearance` |
| 数据 | `/opt/qing-todo/shared/data`，各账号独立SQLite数据库；不要上传本机示例库覆盖 |
| 环境 | `/opt/qing-todo/shared/server.env`；只读取任务所需字段，不输出其中可能存在的秘密 |
| 应用运行时 | `/opt/qing-todo/runtime/node-v24.22.0-linux-x64/bin/node`；镜像系统另有Node，勿混用 |
| 发布备份 | `/opt/qing-todo/backups/`；首次迁移为`bootstrap-20261028`，后续操作以当前真实备份为准 |

## 只读预检示例

在 Windows PowerShell 中运行：

```powershell
Test-Path -LiteralPath 'C:/Users/ww/Desktop/ltodo.pem'
ssh -i C:/Users/ww/Desktop/ltodo.pem -o IdentitiesOnly=yes -o BatchMode=yes -o StrictHostKeyChecking=yes -o ConnectTimeout=8 ubuntu@106.53.187.46 'id; sudo -n true; sudo ss -ltn; sudo systemctl is-active caddy qing-todo.service; readlink -f /opt/qing-todo/current'
curl.exe --noproxy '*' --connect-timeout 5 --max-time 10 -sS -o NUL -w 'HTTP=%{http_code}\n' http://106.53.187.46/todolist/
```

`StrictHostKeyChecking=yes`使用已有known_hosts记录，不忽略主机身份校验。其他电脑缺少私钥或known_hosts时，按实际缺失项处理，不从公钥推导私钥，不猜密码，也不扫描无关私钥。若OpenSSH拒绝此私钥的过宽文件权限，只收紧指定私钥的本机ACL后重试，不关闭检查。

## 云控制台和旧入口

- 本实例控制台：[服务器详情](https://console.cloud.tencent.com/lighthouse/instance/detail?rid=1&id=lhins-2cu3mkqz)、[防火墙](https://console.cloud.tencent.com/lighthouse/instance/detail?rid=1&id=lhins-2cu3mkqz&tab=firewall)。控制台登录会话可能过期，需要当次检查。
- 入站80已于2026-10-28由用户在云防火墙放行；443没有本次公网验收，不凭此资料推定已放行。
- 旧服务器`124.222.207.103`与旧域名`stararc.site`不是本技能的默认部署目标；旧网关权限受限。两个服务器不自动同步，不能使用旧数据快照覆盖新服务器的当前任务。
- 本机待办源项目：`D:/Game_design/todolist`，部署维护详见其`deploy/DEPLOYMENT.md`；在其他项目使用本技能不要求该项目目录必须存在。
- 尚未记录域名注册商/DNS管理账号、云API凭据或可供复用的域名管理授权。未来新域名由用户指定，按本次请求和已连接的账号权限执行。
