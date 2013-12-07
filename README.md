# bats-runner Cookbook
This cookbook installs the [Bash Automated Testing System][1] and
runs a set of BATS tests at the end of the Chef converge.  It serves
as an alternative to [test-kitchen][2] for running a test suite in
a Chef environment.  I developed it so that I could run my existing
BATS tests in a local Chef environment containing multiple boxes.
It could also be used to run a set of "proof of correctness" checks
during convergence of a production node.

[1]: https://github.com/sstephenson/bats
[2]: http://kitchen.ci

## Requirements
* **Platform:** Debian or RHEL
* Network access to github.com so that I can clone the BATS repo.

## Attributes
The following attributes control this cookbook.  They are contained
in the `node.attributes[:bats_runner]` Mash.

<table>
    <tr><th>Name</th><th>Description</th><th>Default</th></tr>
    <tr><th>:git_repo</th>
        <td>The git repository to clone when installing BATS</td>
        <td>https://github.com/sstephenson/bats.git</td></tr>
    <tr><th>:bats_revision</th>
        <td>The revision of the repository to clone.  This is
            passed to the git LWRP.</td>
        <td>v0.3.1</td></tr>
    <tr><th>:bats_root</th>
        <td>Install BATS into this directory.</td>
        <td>/opt/bats</td></tr>
    <tr><th>:test_root</th>
        <td>Run the BATS files located in this tree.</td>
        <td>/vagrant/test</td></tr>
</table>

## Usage
1. Install your test scripts into a known location.
2. Include the install-bats recipe in your run list.
3. Converge the node.

BATS will be installed from github and your tests will be run by a
Chef handler if the converge succeeds otherwise.

### Recipes
#### install-bats
Clones the git repository named in the `:git_repo` attribute into
the directory identified by the `:bats_root` attribute.

## Contributing
This cookbook is developed using [GitFlow][3] which implements the
work flow [described by Vincent Driessen][4].  If you already have
it installed, then fork the repo and start a new feature.  You can
implement the same workflow by

1. fork the repo on github
2. create a new branch from *develop* in the "feature" folder with
   a descriptive name for your feature (e.g., "feature/froboz")
3. describe your feature in the README
4. add an integration test suite that installs and configures your
   feature in its default use case
5. implement your feature until the integration tests pass
6. add specs to cover any recipes that you have introduced
7. add any attributes needed to configure your feature, add RSpec
   tests that cover configuration options or logic associated with
   your feature
8. once all tests pass, pull any changes from upstream into *develop*
9. finish your feature by checking out develop and doing a `--no-ff`
   merge from your feature branch
10. delete your branch and issue a pull request against the upstream
    *develop* branch.

If your changes aren't tested, I'm not going to accept the pull request.
The same goes if your changes break other tests.

[3]: https://github.com/nvie/gitflow
[4]: http://nvie.com/posts/a-successful-git-branching-model/

## License and Authors

### Cookbook Authors
* Dave Shawley

### License
Copyright (C) 2013, Dave Shawley.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.