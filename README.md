# 貓咪金幣跑酷（kitty-gold-runner）

橫向無盡跑酷：可愛小花貓自動往前跑，跳躍撿金幣、躲避障礙。

## Play

- Live: https://mhraymondwong.github.io/game-kitty-gold-runner/
- License: MIT

## Local

```bash
cd "/workspace/agents/Game Designer/kitty-gold-runner"
/home/box/bin/godot --path .
```

## Web export

```bash
mkdir -p build/pwa
/home/box/bin/godot --headless --path . --export-release Web build/pwa/index.html
python3 tools/patch_pwa_html.py
```

GitHub Pages currently serves `docs/` (legacy). Actions workflow template: `tools/deploy-pages.yml` (also intended as `.github/workflows/deploy-pages.yml`).
