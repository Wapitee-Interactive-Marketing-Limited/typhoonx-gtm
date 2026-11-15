# Changesets

This repo uses [Changesets](https://github.com/changesets/changesets) to version the TyphoonX GTM template.

1. After a user-facing change, run `pnpm changeset` and commit the generated file under `.changeset/`. Its summary becomes the release's change notes in the Community Template Gallery.
2. Merging that file to `main` opens or updates a **chore: version template** pull request.
3. Merging that pull request tags the release, adds it to `metadata.yaml` and creates a GitHub Release.
