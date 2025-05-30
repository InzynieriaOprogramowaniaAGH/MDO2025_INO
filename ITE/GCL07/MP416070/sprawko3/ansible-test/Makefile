.PHONY: install_docker run_container verify_container cleanup full

INVENTORY=inventory

install_docker:
	ansible-playbook -i $(INVENTORY) install_docker.yml

run_container:
	ansible-playbook -i $(INVENTORY) run_container.yml

verify_container:
	ansible-playbook -i $(INVENTORY) verify_container.yml

cleanup:
	ansible-playbook -i $(INVENTORY) cleanup_container.yml

full: install_docker run_container verify_container
