import gitlab
## Instal gitlag package: pip install --upgrade python-gitlab
import json
# anonymous read-only access for public resources (GitLab.com)
new_gl = gitlab.Gitlab('https://gitlab.com', private_token='replace with your new repo')
new_gl.auth()

old_gl = gitlab.Gitlab('https://gitlab.com', private_token='replace with your old repo(ci/cd vars to be picked up)')
old_gl.auth()

old_project = old_gl.projects.get('replace with old project id from the gitlab')
new_project = new_gl.projects.get('replace with new project id from the gitlab')

variables = old_project.variables.list(all=True)
new_variables = new_project.variables.list(all=True)

for variable in variables:
    new_project.variables.create(json.loads(variable.to_json()))

