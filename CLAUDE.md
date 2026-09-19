# Hestia : consignes pour l'IA

Application Rails 8.1 de gestion du foyer (budget, courses, tâches, calendrier…). Interface en
français, traduite en anglais via i18n.

## Avant toute modification d'interface

Le design system est la source de vérité. Avant d'écrire une vue, un composant ou une classe CSS :

1. **Lire [.design-sync/design-language.md](.design-sync/design-language.md)** : les quatre
   règles, les rôles de couleur, l'échelle typographique, les seuls endroits où le serif est permis.
2. **Chercher un composant existant** dans `app/components/ui/`. Le catalogue est
   `app/models/design_system_registry.rb`, rendu sur `/design-system` avec une preview par
   composant. Réutiliser `Ui::*Component`, ne jamais recopier ses classes à la main.
3. **Si rien ne convient, compléter le design system d'abord** : un token sémantique dans
   `app/assets/stylesheets/application.tailwind.css` (clair et `.dark`), ou un nouveau
   `Ui::*Component` avec son entrée dans le registre, sa preview dans
   `app/views/design_system/previews/` et son test dans `test/components/ui/`. Puis documenter
   dans design-language.md. Jamais de solution ponctuelle dans une vue.

## Interdits

- Une action isolée (retour, déconnexion, précédent / suivant) écrite en
  `link_to ..., class: "underline"` : c'est un `Ui::ButtonComponent` (avec `href:`) ou un
  `Ui::ButtonToComponent` (POST, PATCH, DELETE).
- Une couleur en dur (`bg-gray-100`, `text-red-700`, `#hex`, `style="color: …"`) ou un variant
  `dark:` : uniquement les tokens sémantiques (`bg-surface`, `text-secondary`, `text-link`,
  `bg-gauge`…). Un besoin non couvert signale un token manquant, pas une couleur à peindre.
- Une valeur arbitraire Tailwind (`w-[13px]`, `text-[11px]`) quand l'échelle a un équivalent.
- Un `button_to` (qui rend un `<form>`) dans un `<p>` : le navigateur ferme le paragraphe avant.
- Du texte en dur dans une vue : tout passe par `config/locales/fr/` et `config/locales/en/`.
- Le serif (`--font-display`) ailleurs que dans les emplacements listés par design-language.md.

## Vérifier avant d'annoncer que c'est fait

- **Recompiler le CSS** : `bin/dev`, ou `yarn build:css` (`npx yarn@1.22.22 build:css` si yarn
  n'est pas installé). Une classe Tailwind ajoutée n'existe pas tant que le CSS n'est pas
  reconstruit, et la page aura l'air cassée.
- **Regarder la page pour de vrai** : capture en desktop (1280 px) et mobile (390 px), en clair et
  en sombre, avec Puppeteer (dans `node_modules`). Compte démo créé par `bin/rails demo_data` :
  `demo@hestia.local` / `password123`. Vérifier qu'aucun élément ne déborde.
- **Tests** : `SKIP_JS_BUILD=1 SKIP_CSS_BUILD=1 bin/rails test`. Contrôle visuel automatisé de
  toutes les pages : `bin/rails visual:check`.

## Repères

- Backlog et historique du projet : `app/models/roadmap.rb` et `config/locales/*/roadmap.yml`,
  rendus sur `/roadmap`.
- Journal des changements : `CHANGELOG.md`.
