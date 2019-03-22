workflow "Ansible" {
  resolves = "ansible-lint"
  on = "pull_request"
}

action "filter-to-pr-open-synced" {
  uses = "actions/bin/filter@master"
  args = "action 'opened|synchronize'"
}

action "ansible-lint" {
  uses = "evalytica/ansible-github-actions/lint@0.2.0"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    ANSIBLE_ACTION_WORKING_DIR = "./ansible/roles"
  }
}
