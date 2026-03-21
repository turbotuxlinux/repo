# TurboTux Repository

The APT repository for TurboTux Linux.

## Adding

```bash
curl -fsSL https://turbotuxlinux.github.io/repo/turbotux.gpg | sudo gpg --dearmor -o /usr/share/keyrings/turbotux.gpg
echo "deb [signed-by=/usr/share/keyrings/turbotux.gpg] http://turbotuxlinux.github.io/repo noble main" | sudo tee /etc/apt/sources.list.d/turbotux.list
sudo apt update
```
