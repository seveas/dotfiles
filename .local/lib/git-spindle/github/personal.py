from gitspindle import GitSpindlePlugin, command
from gitspindle.ansi import *
from pprint import pprint
import github3.checks

import collections
import datetime
import sys
import time

class GithHub(GitSpindlePlugin):
    confusion = '😕'
    mergeable_map = {None: '⏳', 'CONFLICTING': '❌', 'MERGEABLE': '✅'}
    review_map = {None: '❗', 'CHANGES_REQUESTED': '❌', 'APPROVED': '✅', 'REVIEW_REQUIRED': '⏳'}
    check_map = {
        None: '❗',
#       'COMPLETED':
        'IN_PROGRESS': '⚙️ ',
        'QUEUED': '⏳',
        'REQUESTED': '⏳',

        'ACTION_REQUIRED': '🛑',
        'CANCELLED': '🛑',
        'FAILURE': '❌',
        'NEUTRAL': '🔵',
        'SKIPPED': '🔵',
#       'STALE':
        'STARTUP_FAILURE': '❌',
        'SUCCESS': '✅',
        'TIMED_OUT': '🛑',
    }
    check_priority = ['🛑', '❌', '⚙️ ' '⏳', '🔵', '😕', '✅', '❗']

    def __init__(self):
        self.graphql_method("get_my_prs",
"""
query MyPullRequests
{
  viewer {
    pullRequests(last: 50, states: [OPEN], orderBy: {field: CREATED_AT, direction: ASC}) {
      nodes {
        number
        title
        mergeable
        url
        reviewDecision
        repository {
          name
          owner {
            login
          }
        }
        commits(last: 1) {
          nodes {
            commit {
              checkSuites(last: 30) {
                nodes {
                  status
                  conclusion
                  url
                  checkRuns(last: 30) {
                    nodes {
                      name
                      status
                      conclusion
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
""")
        self.graphql_method("pr_ci_status",
"""
""")

    @command
    def my_prs(self, opts):
        """\nList my GitHub pr's"""

        mrl = 0
        msl = 0
        prs = self.get_my_prs().viewer.pullRequests
        if prs:
            print("              ⛙ 👀✔️ ")
        for pr in prs:
            if pr.repository.owner.login != 'github':
                continue
            ident = "%s/%d" % (pr.repository.name, pr.number)
            mrl = mrl if len(ident) < mrl else len(ident)
            msl = msl if len(pr.title) < msl else len(pr.title)
            status = self.mergeable_map.get(pr.mergeable, self.confusion)
            status += self.review_map.get(pr.reviewDecision, self.confusion)
            suites = [suite for suite in pr.commits[0].commit.checkSuites if suite.checkRuns]
            cs = self.check_map[None]
            for suite in suites:
                for check in suite.checkRuns:
                    s = self.check_map.get(check.status, self.check_map.get(check.conclusion))
                    cs = s if self.check_priority.index(s) < self.check_priority.index(cs) else cs
            status += cs
            print('[%-*s]  %s  %-*s %s' % (mrl, ident, status, msl, pr.title, wrap(pr.url, attr.faint)))

    @command
    def wait_for_ci(self, opts):
        """[<branch>]
           Wait for ci to complete on a branch"""
        opts['--wait'] = True
        self.ci_status(opts)

    @command
    def ci_status(self, opts):
        """[<branch>] [--wait]
           Show the status of all check runs on the branch"""
        lines = 0
        branch = opts['<branch>']
        if not branch:
            branch = self.git('rev-parse', 'HEAD').stdout.strip()
            remote_branch = self.git('rev-parse', '--symbolic-full-name', '@{u}').stdout.strip()
            if remote_branch:
                remote_branch = 'refs/heads/%s' % remote_branch.split('/', 3)[3]
                remote_sha = self.git('ls-remote', 'origin', remote_branch).stdout.strip()
                if remote_sha and branch != remote_sha.split()[0]:
                    print(wrap("Your local branch is not up-to-date with GitHub", fgcolor.red, attr.bright))
        repo = self.repository(opts)
        branch_data = repo.branch(repo.default_branch).as_dict()
        required = branch_data['protection']['required_status_checks']['contexts']
        commit = repo.commit(branch)
        failing = False
        pending = False
        
        while True:
            runs = list(commit.check_runs())
            now = datetime.datetime.now().astimezone(datetime.timezone.utc)
            print(cursor_up(lines))
            mnl = 0
            pending = False
            names = [x.name for x in runs]
            for name in required:
                if name not in names:
                    runs.append(FakeCheckRun(name=name))
            runs.sort(key=lambda run: run.name)
            mnl = max([len(run.name) for run in runs])
            for run in runs:
                ts = '     '
                symbol = '  '
                if run.name in required:
                    symbol = '📍'
                if run.status == 'expected':
                    symbol += '❓'
                    pending = True
                elif run.status == 'queued':
                    symbol += '⌛'
                    if not run.name.startswith('puppet-integration'):
                        pending = True
                elif run.status == 'in_progress':
                    symbol += '⚙️ '
                    if not run.name.startswith('puppet-integration'):
                        pending = True
                    td = (now-run.started_at).seconds
                    ts = '%02d:%02d' % (td/60, td%60)
                else:
                    if run.conclusion in ('success', 'neutral', 'skipped'):
                        symbol += '✅' 
                    else:
                        symbol += '❌'
                        failing = True
                    td = (run.completed_at - run.started_at).seconds
                    ts = '%02d:%02d' % (td/60, td%60)
                text = "%s %s %-*s %s" % (symbol, ts, mnl, run.name, run.details_url)
                if run.name.startswith('puppet-integration'):
                    text = wrap(text, attr.faint)
                print(text)

            lines = len(runs)+1
            if not (pending and opts['--wait']):
                break
            time.sleep(5)

        if failing:
            sys.exit(1)
        if pending:
            sys.exit(2)

class FakeCheckRun:
    status = 'expected'
    details_url = ''
    def __init__(self, name):
        self.name = name
