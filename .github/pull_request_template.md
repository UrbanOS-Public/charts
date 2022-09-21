## Reminders

- [ ] Did you up the relevant chart version numbers? (If appropriate)
  - [ ] If you up a chart version within urban-os, have you also upped the urban-os chart version itself?
  - [ ] If charts within the urban-os chart (andi, etc) have been updated, have you run `helm dependency update` in /charts/urban-os and commited the Chart.lock file?
- [ ] If chart values added, were default values provided in the chart? (Will `helm template` pass?)
  - [ ] Additionally, was the list of values in the chart readme documentation updated to reflect the changes?
- [ ] If references to external charts were added:
  - [ ] Was the github release action updated to `helm update {new_thing}` it's dependencies?
  - [ ] Was the deploy repo `-u` flag updated to `helm udpate {new_thing}` to ensure it's not left out of deployments?
