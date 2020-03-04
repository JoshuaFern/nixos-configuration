{ pkgs, user, flatpakFlathubPackages, flatpakKdeappsPackages, flatpakFirefoxPackages, ... }:

''
echo [Flatpak] Start...
${pkgs.sudo}/bin/sudo -u ${user} ${pkgs.flatpak}/bin/flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
${pkgs.sudo}/bin/sudo -u ${user} ${pkgs.flatpak}/bin/flatpak remote-add --user --if-not-exists kdeapps https://distribute.kde.org/kdeapps.flatpakrepo
${pkgs.sudo}/bin/sudo -u ${user} ${pkgs.flatpak}/bin/flatpak remote-add --user --if-not-exists org.mozilla.FirefoxRepo https://firefox-flatpak.mojefedora.cz/org.mozilla.FirefoxRepo.flatpakrepo

${pkgs.sudo}/bin/sudo -u ${user} ${pkgs.flatpak}/bin/flatpak install --user --noninteractive -y flathub ${toString flatpakFlathubPackages}
${pkgs.sudo}/bin/sudo -u ${user} ${pkgs.flatpak}/bin/flatpak install --user --noninteractive -y kdeapps ${toString flatpakKdeappsPackages}
${pkgs.sudo}/bin/sudo -u ${user} ${pkgs.flatpak}/bin/flatpak install --user --noninteractive -y org.mozilla.FirefoxRepo ${toString flatpakFirefoxPackages}

${pkgs.sudo}/bin/sudo -u ${user} ${pkgs.flatpak}/bin/flatpak update --user -y
echo [Flatpak] Done.
''
