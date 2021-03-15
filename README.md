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
Now, return to the terminal:

```bash
git init # create a local git repository
git add . # add all files in current working directory
git commit -m "first commit" # comment on your progress
git branch -M main # create a branch
git remote add origin https://github.com/soderling-lab/Rpackage.git # track remote url
git push -u origin main # push changes to git
```

## Including data
A powerful feature of R is its ability to share data. 
```R

hi <- "hello world!"
save(hi, file="hi.rda", version=2)
```
Save R objects with the `save` command. It's best practice to save the object
using the same filename (e.g. `hi` saved as `hi.rda`). You must explicitly
provide `file` and `version` arguments to `save`. Use `version=2` to avoid
warnings about the data version when installing the package. Put saved `rda`
files in the `data/` directory. 
Document the data by generating a Roxygen2 formatted file in the `R/` directory.
Be sure to call `devtools::document` to generate the documentation!

You can also include raw data in `inst/extdata`, these files are not loaded when
loading your package.

After loading your package (`library(Rpackage)`) you can access its data
(`data(hi)`). You can also more explicitly load a piece of data from any package
with `data("hi", package="Rpackage")`. 

See https://r-pkgs.org/data.html#documenting-data for more about documenting
data.


## Testing

You can use `devtools::load_all()` to load your package as it is locally. You
will then have access to its functions, data, and documentation.
