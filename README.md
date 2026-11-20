# Koi Pond customizations for T3 Code

Two Windows desktop themes based on [Koi Pond by Dwite](https://t3themes.com/themes/koi-pond/). Both use a dark teal palette and scope the artwork to the chat and New thread canvas. The No Fish variant hides the koi and slows the remaining animation by 20%.

## Install

Save the original theme JSON from T3 Themes as `koi-pond.json`. The download supplies the original artwork, which is stored separately from this repository.

Run the installer in PowerShell 7 from this repository:

```powershell
./install.ps1 -SourceTheme ./koi-pond.json
```

Press **Ctrl+Alt+A** in T3 Code and select **Koi Pond (Chat Background)** or **Koi Pond (No Fish)**. To remove the variants, switch to another theme and delete their JSON files from `~/.t3/userdata/themes`.
