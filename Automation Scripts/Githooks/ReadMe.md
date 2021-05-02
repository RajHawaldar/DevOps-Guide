Git hooks allow us to run custom scripts whenever certain important events occur in the git repository such as commit, push, merge. Basically git hooks are stored in the .git/hook directory of your local repository.

Initially all hook files contain .sample as extension, which indicate those are disabled. These sample hooks are stored in one of the below locations as per your operating system,

* **Linux**: /usr/share/git-core/templates

* **Windows**: C:\Program Files\Git\mingw64\share\git-core\templates

* **Mac OS**: /usr/local/git/libexec/git-core

Whenever you initialize a local git repository these sample hooks templates which are already stored on your machine get copied into your local repository.

All hooks pre-fix with pre label will execute before the particular event happens and hooks with pre-fix post will execute after the event.

For Example: pre-push hook will execute before the push operation.

As hooks are disabled by default, we need to perform below steps to enable them ,

* Remove .sample extension from the hook name.
* Make that hook file executable using command chmod +x 

**Before we start remember this:**

* As we see here hooks present inside .git/hook/ directory which means these are not source control. You can use symbolic link.
* You can bypass pre-commit git hook locally by adding --no-verify flag.<hook_name>

Lets start with the practical use of git hooks.

**Scenario 1:** In one of the projects we used to create a feature-branch from the environment branch(master,dev,release). We should not commit our code directly on the environment branches.

**Solution:** pre-commit hook is run first, so we will use this hook. copy below code snippet in your pre-commit hook.

```
#!/bin/sh
# Avoid doing commit in environment branches.


BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
forbidden_branchs="^(master|dev|release)$"


message="You should not commit directly into ${BRANCH_NAME} branch.\nPlease create a new branch from '$BRANCH_NAME' and Try again."


if [[ $BRANCH_NAME =~ $forbidden_branchs ]]
then
	echo -e $message
    exit 1
fi
```
In windows operating system instead of **#!bin/sh** use **#!C:\Program Files\Git\bin\sh.exe** path where git installed its shell script.

Now git provides you the freedom to select scripting language. If you are comfortable with other scripting languages like python, ruby, powershell you just need to add the path of its library on the first line of the hook.

Always remember, If your hooks returns **zero** means that it is **succeed**.  If it exists with any other number it is failed. In the above code snippet we exit code 1 which means hook failed so commit will not happen.

**Scenario 2:**

Sometimes we amend commits multiple times and in later stages we need one of the previous state of commits. If we write a script which will make stash before committing code every time then we will get state if each and every commit in our stash.

**Solution:**
```
if [[ $(git diff --cached --exit-code) ]];then
  BRANCH_NAME=$(git branch --show-current)
  STASH_NAME="pre-commit-on-$BRANCH_NAME-$(date +"%m-%d-%y::%T")"
  git stash save -q --keep-index $STASH_NAME
  echo "Stash:${STASH_NAME} saved!"       
fi
```
**$(git diff --cached --exit-code)** will check whether there is any code present in staging area. As there is no point running this code for empty commit. **$(git branch --show-current )** gives us current branch name.
We will use the same pre-commit hook. Add below line your pre-commit hook.

**Scenario 3:**

Before pushing our branches to remote lets create a hook which will execute build and tests before pushing your code to remote branch.

**Solution:**

We can use pre-push or pre-commit hook for this scenario.

```
echo "Running Build"
sh run-test-scripts.sh

if [ $? -ne 0 ]; then
  echo "Build must be succeed before commit!"
  exit 1
fi
```
Here, **$?** stores the exit value of last command. Add test cases and build commands in run-test-scripts.sh file. **You can use this hook for automatic code quality checks.**


###How to deploy these git hooks ?

As git hooks are stored in .git/hook directory so developers will not be able to commit these hooks. We will create our own .githooks directory in our code base. We will copy our created hooks into this newly created directory and ensure permissions are correctly set on the file.

```chmod a+x ~/.githooks/pre-commit```

Done!

**There is another way**, from git version 2.9.0 you can set **core.hookspath** which will allow you to set a global directory for hooks on your machine. So all your local repository will point to that directory and use hooks present over there.

To set **core.hookspath** use below command:

```
git config --global core.hookspath <hooks-directory-path>
```

**Note: Keep your hooks folder outside of local repository. Otherwise if you delete local repository for some reason. Your other project will not able to access the hooks.**

With git hooks imagination is the limit! You can find my original article on LinkedIn([here](https://www.linkedin.com/pulse/use-git-hooks-ease-your-development-workflow-raj-hawaldar-/)).

Let me know if the article is useful. 
Happy coding!