from ansiblelint import AnsibleLintRule

import os

class PlaybookExtension(AnsibleLintRule):
    id = 'EXTRA0101'
    shortdesc = 'Playbooks should have the ".yml" extension'
    description = ''
    tags = ['playbook']
    done = []  # already noticed path list

    def matchplay(self, file, text):
        path = file['path']
        ext = os.path.splitext(path)
        if ext[1] != ".yml" and path not in self.done:
            self.done.append(path)
            return True
        return False
