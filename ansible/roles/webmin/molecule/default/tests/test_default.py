import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_webmin_package(Package):
    assert Package("webmin").is_installed


def test_webmin_socket(Socket):
    assert Socket("tcp://0.0.0.0:10000").is_listening
