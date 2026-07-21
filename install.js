#!/usr/bin/env node
// ============================================================
// 跨平台一键安装脚本 - Node.js
// 统一命令：npx github:BigMianBao/coding-standards
// 项目初始化：npx github:BigMianBao/coding-standards --init /path/to/project
// 支持：macOS / Windows / Linux
// ============================================================
const { execSync } = require("child_process");
const fs = require("fs");
const path = require("path");
const os = require("os");

const REPO_URL = "https://github.com/BigMianBao/coding-standards.git";
const HOME = os.homedir();
const INSTALL_DIR = path.join(HOME, ".workbuddy", "coding-standards");

// ---------- 解析参数 ----------
const args = process.argv.slice(2);
let initProject = null;
for (let i = 0; i < args.length; i++) {
  if (args[i] === "--init" && args[i + 1]) {
    initProject = path.resolve(args[i + 1]);
    break;
  }
}

// ---------- 工具函数 ----------
function log(msg) { console.log(msg); }
function ok(msg) { console.log("  \u2713 " + msg); }
function fail(msg) { console.log("  \u2717 " + msg); }
function run(cmd, opts) { return execSync(cmd, { stdio: "pipe", encoding: "utf-8", ...opts }).trim(); }
function has(cmd) {
  try { execSync(`which ${cmd} 2>/dev/null || where ${cmd} 2>nul`, { stdio: "pipe" }); return true; }
  catch { try { execSync(`command -v ${cmd}`, { stdio: "pipe" }); return true; } catch { return false; } }
}

function copyDir(src, dest) {
  fs.mkdirSync(dest, { recursive: true });
  for (const entry of fs.readdirSync(src, { withFileTypes: true })) {
    const s = path.join(src, entry.name);
    const d = path.join(dest, entry.name);
    if (entry.isDirectory()) { copyDir(s, d); }
    else { fs.copyFileSync(s, d); }
  }
}

function copyFiles(srcDir, pattern, destDir) {
  fs.mkdirSync(destDir, { recursive: true });
  for (const f of fs.readdirSync(srcDir)) {
    if (pattern instanceof RegExp ? pattern.test(f) : f.endsWith(pattern)) {
      fs.copyFileSync(path.join(srcDir, f), path.join(destDir, f));
    }
  }
}

// ---------- 确保仓库存在（两种模式共用） ----------
function ensureRepo() {
  if (fs.existsSync(path.join(INSTALL_DIR, ".git"))) {
    log("  -> 仓库已存在，拉取最新更新...");
    try {
      execSync("git pull --ff-only origin main", { cwd: INSTALL_DIR, stdio: "pipe" });
    } catch {
      log("  -> 本地有修改，强制同步远程...");
      execSync("git fetch origin", { cwd: INSTALL_DIR, stdio: "pipe" });
      execSync("git reset --hard origin/main", { cwd: INSTALL_DIR, stdio: "pipe" });
    }
  } else {
    log("  -> 克隆仓库到 " + INSTALL_DIR + " ...");
    fs.mkdirSync(path.dirname(INSTALL_DIR), { recursive: true });
    if (fs.existsSync(INSTALL_DIR)) fs.rmSync(INSTALL_DIR, { recursive: true });
    execSync(`git clone --depth 1 ${REPO_URL} "${INSTALL_DIR}"`, { stdio: "pipe" });
  }
  ok("仓库就绪");
}

// ============================================================
// 模式一：项目初始化 (--init /path/to/project)
// ============================================================
if (initProject) {
  log("");
  log("========================================");
  log("  项目规范初始化");
  log("  系统: " + os.type());
  log("  项目: " + initProject);
  log("========================================");
  log("");

  // 检查项目目录
  if (!fs.existsSync(initProject)) {
    log("  -> 创建项目目录...");
    fs.mkdirSync(initProject, { recursive: true });
  }

  // 获取/更新仓库
  log("[1/3] 获取规范仓库...");
  try { ensureRepo(); } catch (e) { fail("仓库获取失败: " + e.message); process.exit(1); }
  log("");

  const SRC = INSTALL_DIR;

  // 部署 CODEBUDDY.md
  log("[2/3] 部署 CODEBUDDY.md...");
  const cbmd = path.join(initProject, "CODEBUDDY.md");
  if (fs.existsSync(cbmd)) {
    log("  -> CODEBUDDY.md 已存在，跳过");
  } else {
    fs.copyFileSync(path.join(SRC, "templates", "CODEBUDDY.md"), cbmd);
    ok("CODEBUDDY.md -> " + cbmd);
  }
  log("");

  // 部署 openspec/ 配置目录
  log("[3/3] 部署 openspec/ 配置...");
  const opsRulesDir = path.join(initProject, "openspec", "rules");
  fs.mkdirSync(opsRulesDir, { recursive: true });
  copyFiles(path.join(SRC, "rules"), ".md", opsRulesDir);
  const cfgPath = path.join(initProject, "openspec", "config.yaml");
  if (fs.existsSync(cfgPath)) {
    fs.copyFileSync(cfgPath, cfgPath + ".bak");
    log("  -> 已备份旧 config.yaml -> config.yaml.bak");
  }
  fs.copyFileSync(path.join(SRC, "templates", "openspec-config.yaml"), cfgPath);
  ok("规则文件 -> " + opsRulesDir);
  ok("config.yaml -> " + cfgPath);
  log("");

  log("========================================");
  log("  \u2713 项目初始化完成！");
  log("========================================");
  log("");
  log("后续操作：");
  log("  1. 用 CodeBuddy 打开项目: " + initProject);
  log("  2. 新建对话会话（规范在会话启动时加载）");
  log("  3. 验证：问 AI '当前应用了哪些规则？'");
  log("  4. 将 CODEBUDDY.md 和 openspec/ 提交到项目 Git 仓库");
  log("");
  process.exit(0);
}

// ============================================================
// 模式二：全局安装（默认）
// ============================================================
log("");
log("========================================");
log("  企业编程规范 - 一键安装");
log("  系统: " + os.type() + " " + os.release());
log("========================================");
log("");

// ---------- [1/6] 前提检查 ----------
log("[1/6] 检查前提条件...");

if (!has("git")) {
  fail("未安装 Git");
  log("    macOS:  brew install git");
  log("    Windows: https://git-scm.com");
  log("    Ubuntu:  sudo apt install git");
  process.exit(1);
}
ok("Git " + run("git --version").replace(/git version\s*/i, ""));

if (!has("node")) {
  fail("未安装 Node.js（需要 >= 20.19.0）");
  log("    https://nodejs.org");
  process.exit(1);
}
const nodeVer = process.versions.node;
const nodeMajor = parseInt(nodeVer.split(".")[0]);
if (nodeMajor < 20) {
  fail("Node.js 版本过低: " + nodeVer + "（需要 >= 20.19.0）");
  process.exit(1);
}
ok("Node.js " + nodeVer);
log("");

// ---------- [2/6] 克隆 / 更新仓库 ----------
log("[2/6] 获取规范仓库...");
try { ensureRepo(); } catch (e) { fail("仓库获取失败: " + e.message); process.exit(1); }
log("");

const SRC = INSTALL_DIR;

// ---------- [3/6] 部署全局规则到 ~/.workbuddy/ ----------
log("[3/6] 部署全局规则文件...");
const wbRulesDir = path.join(HOME, ".workbuddy", "rules");
fs.mkdirSync(wbRulesDir, { recursive: true });
copyFiles(path.join(SRC, "rules"), ".md", wbRulesDir);
fs.copyFileSync(path.join(SRC, "MEMORY.md"), path.join(HOME, ".workbuddy", "MEMORY.md"));
const ruleCount = fs.readdirSync(wbRulesDir).filter(f => f.endsWith(".md")).length;
ok(ruleCount + " 个规则文件 -> " + wbRulesDir);
ok("MEMORY.md -> " + path.join(HOME, ".workbuddy", "MEMORY.md"));
log("");

// ---------- [4/6] 部署 CodeBuddy 用户规则 ----------
log("[4/6] 部署 CodeBuddy 用户规则...");
const cbRulesDir = path.join(HOME, ".codebuddy", "rules", "coding-standards");
fs.mkdirSync(cbRulesDir, { recursive: true });
fs.copyFileSync(
  path.join(SRC, "templates", "coding-standards.mdc"),
  path.join(cbRulesDir, "RULE.mdc")
);
ok("RULE.mdc -> " + cbRulesDir + " (alwaysApply)");
log("");

// ---------- [5/6] 部署 OpenSpec 命令和技能 ----------
log("[5/6] 部署 OpenSpec 命令和技能...");
const cmdDir = path.join(HOME, ".codebuddy", "commands", "opsx");
fs.mkdirSync(cmdDir, { recursive: true });
copyFiles(path.join(SRC, "templates", "codebuddy-commands", "opsx"), ".md", cmdDir);
const cmdCount = fs.readdirSync(cmdDir).filter(f => f.endsWith(".md")).length;

const skillsDir = path.join(HOME, ".codebuddy", "skills");
fs.mkdirSync(skillsDir, { recursive: true });
copyDir(path.join(SRC, "templates", "codebuddy-skills"), skillsDir);
const skillCount = fs.readdirSync(skillsDir, { withFileTypes: true }).filter(d => d.isDirectory()).length;

ok(cmdCount + " 个斜杠命令 -> " + cmdDir);
ok(skillCount + " 个技能文件 -> " + skillsDir);
ok("所有项目可用 /opsx:propose、/opsx:apply、/opsx:archive 等命令");
log("");

// ---------- [6/6] OpenSpec CLI ----------
log("[6/6] 检查 OpenSpec CLI...");
if (has("openspec")) {
  ok("OpenSpec CLI 已安装: " + run("openspec --version"));
} else {
  log("  -> 安装 OpenSpec CLI...");
  try {
    execSync("npm install -g @fission-ai/openspec@latest", { stdio: "inherit" });
    ok("OpenSpec CLI 安装完成: " + run("openspec --version"));
  } catch {
    fail("OpenSpec CLI 安装失败，请手动执行: npm install -g @fission-ai/openspec@latest");
  }
}
log("");

// ---------- 完成 ----------
log("========================================");
log("  \u2713 一键安装完成！");
log("========================================");
log("");
log("后续操作：");
log("  1. 新项目初始化：npx github:BigMianBao/coding-standards --init /path/to/project");
log("  2. 在 CodeBuddy 中新建会话，规范自动生效");
log("  3. 验证：新会话中问 AI '当前应用了哪些规则？'");
log("");
log("规范更新：重新执行 npx github:BigMianBao/coding-standards");
log("");
