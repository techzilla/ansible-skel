import six
from ansiblelint import AnsibleLintRule

class IncludeDeprecatedRule(AnsibleLintRule):
    id = 'DEPRE0001'
    shortdesc = 'Deprecated include'
    description = 'Use include_tasks, import_playbook, import_tasks.'
    tags = ['deprecated']


    def _check_value(self, play_frag):
        results = []
        if isinstance(play_frag, dict):
            for key, value in six.iteritems(play_frag):
                if key == 'include':
                    results.append(({'include': play_frag['include']},
                                    'deprecated include feature'))
                elif isinstance(value, list):
                    for item in value:
                        output = self._check_value(item)
                        if output:
                            results += output

        return results

    def matchplay(self, file, play):
        return self._check_value(play)
