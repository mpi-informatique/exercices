# Connexion GitHub

Le site statique utilise ce Worker uniquement pour échanger un code OAuth contre un jeton ; le navigateur accède ensuite directement à GitHub. Le jeton reste en mémoire, avec vérification de l'origine, du `state` et de PKCE S256.

Production : `https://exercices-github-auth.qpfortier.workers.dev`. L'application [Contributions Enseignement MPI](https://github.com/settings/applications/3927033) est administrée par `fortierq`.

## Configuration

1. Créer une [OAuth App GitHub](https://github.com/settings/applications/new), avec l'accueil `https://mpi-informatique.github.io/exercices/` et le callback `https://mpi-informatique.github.io/exercices/contribution/`.
2. Renseigner `GITHUB_CLIENT_ID` et `SITE_URL` dans [wrangler.jsonc](wrangler.jsonc), en conservant le préfixe `/exercices/`.
3. Depuis `worker/`, installer, connecter et déployer :

   ```sh
   nix develop ..#web -c npm ci
   nix develop ..#web -c npx wrangler login
   nix develop ..#web -c npm run deploy
   nix develop ..#web -c npx wrangler secret put GITHUB_CLIENT_SECRET
   ```

   Saisir le secret uniquement à l'invite ; `.dev.vars` et `.env` restent exclus de Git.
4. Dans les variables GitHub Actions du dépôt, définir `PUBLIC_GITHUB_AUTH_URL` avec l'URL HTTPS du Worker sans barre finale, puis relancer **Vérifications et publication**.
5. Tester la contribution avec un compte disposant de l'écriture et un compte nécessitant un fork.

Le scope `public_repo` sert aux contributions publiques ; `repo` est demandé séparément pour les dépôts privés et autorise aussi leur écriture. GitHub OAuth ne propose pas de restriction par dépôt ni de scope privé en lecture seule. Les organisations peuvent exiger une autorisation supplémentaire.

Sans `PUBLIC_GITHUB_AUTH_URL`, le site copie le brouillon et ouvre l'éditeur GitHub. La déconnexion locale efface les ressources en mémoire ; révoquer l'autorisation dans **GitHub → Settings → Applications → Authorized OAuth Apps**.

## Développement

Créer une autre OAuth App avec le callback `http://127.0.0.1:4321/contribution/`. Placer ses identifiants et `SITE_URL=http://127.0.0.1:4321/` dans `worker/.dev.vars`. Lancer `npm run dev` dans `worker/`, puis, à la racine :

```sh
PUBLIC_GITHUB_AUTH_URL=http://127.0.0.1:8787 nix develop . -c just web
```

Adapter exactement le callback et `SITE_URL` si le port ou le préfixe change. Les tests simulant GitHub font partie de `npm test` dans `web/` et ne créent aucune ressource distante. Pour les parcours de contribution et de banque privée, voir le [guide du site](../web/README.md).
