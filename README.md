# Rpackage

Creating an R package is simple with `devtools` and `git`.

There are three essential `devtools` commands.
* devtools::create("packageName") - use `create` to create a empty R package.
* devtools::document() - use `document` to generate documentation for R
    functions (see below).
* devtools::install_github("user/packageName") - use `install_github` to install
    a github user's package.


## Creating a new package

Start by creating a new directory for your package, in the terminal type:
```bash

mkdir Rpackage

```

Now, launch the R interpreter by typing `R` into the terminal, and use
`devtools` to populate this directory with a new package.

```R
devtools::create("Rpackage")

```

You will find a couple of new files in your new directory:
```bash
cd Rpackage
ls -1

# DESCRIPTION
# NAMESPACE
# R

```

You can edit the `DESCRIPTION` file with information about your package. You should also create a README and add a license.
See github for more about adding a license: https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/licensing-a-repository

## Creating and documenting functions

Put R functions in the `R/` directory. I put each function in a seperate file.
Document your function with `Roxygen2` markdown syntax. At a minimum, your
function's header should start with the name of your function and include an
`export` statement. See https://kbroman.org/pkg_primer/pages/docs.html for more.

Simply use `document` to generate documentation--this will be put in the `man/`
directory.


## Sharing your package

Sync your changes with github using git.
Start by creating a new repository on github: https://github.com/soderling-lab/Rpackage

Now, return to the terminal
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/soderling-lab/Rpackage.git
git push -u origin main
