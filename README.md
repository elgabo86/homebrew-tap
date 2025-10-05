# Homebrew Tap for VSCodium Linux

Ce dépôt contient un tap Homebrew pour installer VSCodium sur Linux.

## Installation

Pour installer cette formule personnalisée :

```bash
brew tap elgabo86/brew
brew install --cask vscodium-linux
```

## Ce que fait ce tap

Ce tap permet d'installer VSCodium, une version open-source de Visual Studio Code, sur les systèmes Linux via Homebrew. Il inclut :

- Le binaire `codium`
- Le binaire `codium-tunnel` (si disponible)
- Les fichiers de complétion bash et zsh
- Les fichiers .desktop pour le menu d'applications
- L'icône d'application
- La prise en charge des URL personnalisées (vscodium://)

## Commentaires

VSCodium est une version open-source de Visual Studio Code avec les télémétries Microsoft et le code propriétaire supprimés.

## Licence

Comme il s'agit d'un simple fichier de formule pour un logiciel existant, ce dépôt est distribué sous la licence MIT.