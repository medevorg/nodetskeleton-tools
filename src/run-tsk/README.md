# Run-TSK 🚀

run-tsk tool is one part of the `NodeTskeleton` template project to install, to initialize and to interact with it.

`NodeTskeleton` is a `Clean Architecture` based `template project` for `NodeJs` using `TypeScript` to implement with any `web server framework` or even any user interface.

<a href="https://github.com/medevorg/nodetskeleton" target="_blank" >Go to NodeTskeleton</a>


## Using Run-TSK

We can use it by installation and without install it.

### Without install it

- Run it using NPX and replace `my-awesome-project` for your own project name
```console
> npx run-tsk setup project-name=my-awesome-project
```
Or
```console
> pnpx run-tsk setup project-name=my-awesome-project
```

You'll see something like: 
```console
Done in 5.0s
Your project wonderful is ready
Now go to the project directory typing 'cd wonderful'
 And type 'npm run dev' to start the server
 And then try typing 'run-tsk help' to see the available commands to support your development
Happy coding!
```

### Using installing it

We have to install it globally
- Install using PNPM
```console
> pnpm i -g run-tsk
```
- Or using NPM
```console
> npm i -g run-tsk
```

### Then, use it

Is simple to use it, and you only need to go to some root directory when you would want to create your project and type the following in your console:
- Replace `my-awesome-project` for your own project name
```console
> run-tsk help
> run-tsk setup project-name=my-awesome-project
```

### Run the project
```console
> cd my-awesome-project
> npm run dev
```

## Available commands

- help
  - Command to see all commands available and their explanation.
- setup
  - Command to setup and initialize the TSK project
- alias
  - Command to see aliases for argument names
- validate
  - Command to validate if you are in a root TSK project.
- add-use-case
  - Command to add a new use case to the project.

Is important keep in mind that some commands only work in a root directory of TSK project. 
A root directory is where there is a package.json file.


You can explore and follow the instructions in the official documentation about NodeTSKeleton
<a href="https://github.com/medevorg/nodetskeleton?tab=readme-ov-file#create-your-first-use-case" target="_blank" >Go to NodeTskeleton</a>

## Warning 💀

> Use this resource at your own risk.
