cask "vscodium-linux" do
  arch arm: "arm64", intel: "x64"
  os linux: "linux"

  version "1.104.26450"
  sha256 arm64_linux:  "9bd248aa5a28d1ebd820f797b46197f261574679594b6c1e82fa37f2e1d3f520",
         x86_64_linux: "bfa70638a038c1ec077e15635d65e44019afe7a8923026b1728d86f44432d632"

  url "https://github.com/VSCodium/vscodium/releases/download/#{version}/VSCodium-linux-#{arch}-#{version}.tar.gz",
      verified: "github.com/VSCodium/vscodium/"
  name "VSCodium"
  desc "Open-source code editor"
  homepage "https://vscodium.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on formula: "git"

  binary "bin/codium"
  binary "bin/codium-tunnel"
  bash_completion "resources/completions/bash/codium"
  zsh_completion  "resources/completions/zsh/_codium"

  artifact "codium.desktop",
           target: "#{Dir.home}/.local/share/applications/codium.desktop"
  artifact "codium-url-handler.desktop",
           target: "#{Dir.home}/.local/share/applications/codium-url-handler.desktop"
  artifact "resources/app/resources/linux/code.png",
           target: "#{Dir.home}/.local/share/icons/vscodium.png"

  preflight do
    FileUtils.mkdir_p("#{Dir.home}/.local/share/applications")
    FileUtils.mkdir_p("#{Dir.home}/.local/share/icons")

    File.write("#{staged_path}/codium.desktop", <<~EOS)
      [Desktop Entry]
      Name=VSCodium
      Comment=Code Editing. Redefined.
      GenericName=Text Editor
      Exec=#{HOMEBREW_PREFIX}/bin/codium %F
      Icon=vscodium
      Type=Application
      StartupNotify=false
      StartupWMClass=VSCodium
      Categories=TextEditor;Development;IDE;
      MimeType=text/plain;inode/directory;application/x-codium-workspace;
      Actions=new-empty-window;
      Keywords=vscodium;codium;vscode;

      [Desktop Action new-empty-window]
      Name=New Empty Window
      Name[de]=Neues leeres Fenster
      Name[es]=Nueva ventana vacía
      Name[fr]=Nouvelle fenêtre vide
      Name[it]=Nuova finestra vuota
      Name[ja]=新しい空のウィンドウ
      Name[ko]=새 빈 창
      Name[ru]=Новое пустое окно
      Name[zh_CN]=新建空窗口
      Name[zh_TW]=開新空視窗
      Exec=#{HOMEBREW_PREFIX}/bin/codium --new-window %F
      Icon=vscodium
    EOS
    File.write("#{staged_path}/codium-url-handler.desktop", <<~EOS)
      [Desktop Entry]
      Name=VSCodium - URL Handler
      Comment=Code Editing. Redefined.
      GenericName=Text Editor
      Exec=#{HOMEBREW_PREFIX}/bin/codium --open-url %U
      Icon=vscodium
      Type=Application
      NoDisplay=true
      StartupNotify=true
      Categories=Utility;TextEditor;Development;IDE;
      MimeType=x-scheme-handler/vscodium;
      Keywords=vscodium;codium;vscode;
    EOS
  end

  # Remove any macOS-specific attributes that may have been added during packaging
  postflight do
    # Only run on Linux systems
    if OS.linux?
      # Ensure proper permissions
      system_command "/bin/chmod", args: ["+x", "#{HOMEBREW_PREFIX}/bin/codium"]
      system_command "/bin/chmod", args: ["+x", "#{HOMEBREW_PREFIX}/bin/codium-tunnel"] if File.exist?("#{HOMEBREW_PREFIX}/bin/codium-tunnel")

      # Update desktop database
      system_command "/usr/bin/update-desktop-database", args: ["-q"], must_succeed: false
      system_command "/usr/bin/gtk-update-icon-cache", args: ["-f", "-t", "#{Dir.home}/.local/share/icons"], must_succeed: false
    end
  end

  uninstall_postflight do
    if OS.linux?
      system_command "/usr/bin/update-desktop-database", args: ["-q"], must_succeed: false
      system_command "/usr/bin/gtk-update-icon-cache", args: ["-f", "-t", "#{Dir.home}/.local/share/icons"], must_succeed: false
    end
  end

  zap trash: [
    "#{Dir.home}/.config/Codium",
    "#{Dir.home}/.vscodium",
  ]
end
