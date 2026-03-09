## Reminders for Creating a Release

- [ ] Did you up the relevant chart version numbers? [charts/urban-os/Chart.yaml etc.] (If appropriate)
  - [ ] If you up a chart version within urban-os, have you also upped the urban-os chart version itself?
  - [ ] If charts within the urban-os chart (andi, etc) have been updated, have you run `helm dependency update`h in /charts/urban-os and commited the Chart.lock file?
- [ ] Does `helm template . -f values.yaml` pass? (Checks for default values provided in chart and catches other errors)
- [ ] Do you have git hooks installed? (See README.md to install)
- [ ] If global values were altered, are they included as chart default values?
  - [ ] Are they also specified in the urbanos chart values file?
- [ ] If references to external charts were added:
  - [ ] Was the github release action updated to `helm update {new_thing}` it's dependencies?
  - [ ] Was the deploy repo `-u` flag updated to `helm update {new_thing}` to ensure it's not left out of deployments?
