workflow "yada" {
  on = "pull_request"
  resolves = ["tag-filter"]
}

action "tag-filter" {
  uses = "actions/bin/filter@master"
  args = "tag"
}
